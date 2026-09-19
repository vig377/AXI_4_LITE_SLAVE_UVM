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
  $display("driver run phase started at %t",$time);
`uvm_info("DRV","DRIVER RUN PHASE STARTED",UVM_LOW)
fork
  forever
    begin
      //`uvm_info("DRV","WAITING FOR WRT ITEM",UVM_LOW)
      wrt_port.get_next_item(write);
      //`uvm_info("DRV","GOT WRT ITEM",UVM_LOW)
      wrt_drive(write);
      wrt_port.item_done();
    end
  forever
    begin
      //`uvm_info("DRV","WAITING FOR READ ITEM",UVM_LOW)
      rd_port.get_next_item(read);
      //`uvm_info("DRV","GOT RD ITEM",UVM_LOW)
      rd_drive(read);
      rd_port.item_done();
    end
join_none
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
  
  vif.drv_cb.RREADY<=t.RREADY;

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
      $display("DRV write addr AWADDR= %d AWVALID= %b at time %t",t.AWADDR,t.AWVALID,$time);
    end
endtask

task wrt_data(trans t);
  if(t.WVALID && data_done==0)
    begin
      @(posedge vif.ACLK iff vif.WREADY)
      data_done=1;
      $display("DRV write data WDATA= %d WSTRB=%b WVALID = %b at time %t" ,t.WDATA,t.WSTRB,t.WVALID, $time);
    end
endtask

task wrt_resp(trans t);
  if(t.BREADY )
    begin
      @(posedge vif.ACLK iff vif.BVALID);
      $display("first handahke of drivere write is done at time %t",$time);
      addr_done=0;
      data_done=0;
    end
endtask

  task rd_drive(trans r);
  @(vif.drv_cb);
  vif.drv_cb.ARADDR<=r.ARADDR;
  vif.drv_cb.ARPROT<=r.ARPROT;
  vif.drv_cb.ARVALID<=r.ARVALID;

  vif.drv_cb.RREADY<=r.RREADY;
    
  vif.drv_cb.BREADY<=r.BREADY;

  begin
    rd_addr(r);
    rd_data(r);
  end
endtask

  task rd_addr(trans r);
    if(r.ARVALID && rd_addr_done==0)
    begin
      @(posedge vif.ACLK iff vif.ARREADY);
      rd_addr_done=1;
      $display("DRV READ  ARADDR =%d ARVALID = %b at time =%t ",r.ARADDR,r.ARVALID,$time);
    end
endtask

  task rd_data(trans r);
    if(r.RREADY && rd_addr_done==1 )
    begin
      @(posedge vif.ACLK iff (vif.RVALID));
      rd_addr_done=0;
      $display("READ RESP HANDSHAKE DONE");
    end
endtask
endclass
