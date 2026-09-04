class driver extends uvm_driver#(trans);
`uvm_component_utils(driver)
virtual axi.drv vif;
uvm_seq_item_pull_port#(trans)wrt_port;
uvm_seq_item_pull_port#(trans)rd_port;

bit addr_done,data_done,rd_addr_done;
trans write,read;

function new(string name,uvm_component parent);
  super.new(name,parent);
  wrt_port=new("wrt_port",this);
  rd_port=new("rd_port",this);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual axi.drv)::get(this,"","vif",vif))
    `uvm_fatal("DRV","config db not set for driver")
endfunction

task run_phase(uvm_phase phase);
`uvm_info("DRV","DRIVER RUN PHASE STARTED",UVM_LOW)
fork
  forever 
    begin
      `uvm_info("DRV","WAITING FOR WRT ITEM",UVM_LOW)
      wrt_port.get_next_item(write);
      `uvm_info("DRV","GOT WRT ITEM",UVM_LOW)
      wrt_drive(write);
      wrt_port.item_done();
    end
  forever 
    begin
      `uvm_info("DRV","WAITING FOR READ ITEM",UVM_LOW)
      rd_port.get_next_item(read);
      `uvm_info("DRV","GOT RD ITEM",UVM_LOW)
      rd_drive(read);
      rd_port.item_done();
    end
join
endtask

task  wrt_drive(trans t);
  @(vif.drv_cb);
  vif.drv_cb.AWADDR<=t.AWADDR;
  vif.drv_cb.AWPROT<=t.AWPROT;
  vif.drv_cb.AWVALID<=t.AWVALID;

  vif.drv_cb.WDATA<=t.WDATA;
  vif.drv_cb.WSTRB<=t.WSTRB;
  vif.drv_cb.WVALID<=t.WVALID;

  vif.drv_cb.BREADY<=t.BREADY;
  
  fork
  wrt_addr(t);
  wrt_data(t);
  join
  if(data_done && addr_done)
    wrt_resp(t);
endtask

task wrt_addr(trans t);
  if(t.AWVALID && addr_done==0)
    begin
      @(posedge vif.ACLK iff vif.AWREADY);
      addr_done=1;
    end
endtask

task wrt_data(trans t);
  if(t.WVALID && data_done==0)
    begin
      @(posedge vif.ACLK iff vif.WREADY)
      data_done=1;
    end
endtask

task wrt_resp(trans t);
  if(t.BREADY )
    begin
      @(posedge vif.ACLK iff vif.BVALID);
      addr_done=0;
      data_done=0;
    end
endtask

task rd_drive(trans t);
  @(vif.drv_cb);
  vif.drv_cb.ARADDR<=t.ARADDR;
  vif.drv_cb.ARPROT<=t.ARPROT;
  vif.drv_cb.ARVALID<=t.ARVALID;

  vif.drv_cb.RREADY<=t.RREADY;

  begin
  rd_addr(t);
  rd_data(t);
  end
endtask

task rd_addr(trans t);
  if(t.ARVALID && rd_addr_done==0)
    begin
      @(posedge vif.ACLK iff vif.ARREADY);
      rd_addr_done=1;
    end
endtask

task rd_data(trans t);
  if(t.RREADY && rd_addr_done==1 )
    begin
      @(posedge vif.ACLK iff vif.RVALID);
      rd_addr_done=0;
    end
endtask
endclass

