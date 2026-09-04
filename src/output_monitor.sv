class output_monitor extends uvm_monitor;

`uvm_component_utils(output_monitor)
virtual axi.out_mon vif;
uvm_analysis_port#(trans)wrt_port;
uvm_analysis_port#(trans)rd_port;
trans wrt_resp,rd_data;

function new(string name ,uvm_component parent);
  super.new(name,parent);
  wrt_port=new("wrt_port",this);
  rd_port=new("rd_port",this);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual axi.out_mon)::get(this,"","vif",vif))
    `uvm_fatal("OUT_MON","config db not set for output monitor")
endfunction

task run_phase(uvm_phase phase);
  forever
    begin
      @(vif.out_mon_cb);
      if((vif.out_mon_cb.BVALID) && vif.out_mon_cb.RVALID)
        begin
          fork
            addr_resp();
            read_data();
          join
        end
      else if(vif.out_mon_cb.BVALID && !vif.out_mon_cb.RVALID)
        begin
        addr_resp();
        end
      else if(!vif.out_mon_cb.BVALID && vif.out_mon_cb.RVALID)
        begin
        read_data();
        end
      end
endtask

task addr_resp();
  if(vif.out_mon_cb.BVALID)
    begin
      wrt_resp=trans::type_id::create("wrt_resp");
      @(posedge vif.ACLK iff vif.BREADY);
      wrt_resp.BVALID=vif.out_mon_cb.BVALID;
      wrt_resp.BRESP=vif.out_mon_cb.BRESP;
      wrt_port.write(wrt_resp);
    end
endtask

task read_data();
    if(vif.out_mon_cb.RVALID)
    begin
      rd_data=trans::type_id::create("rd_data");
      @(posedge vif.ACLK iff vif.RREADY);
      rd_data.RVALID=vif.out_mon_cb.RVALID;
      rd_data.RDATA=vif.out_mon_cb.RDATA;
      rd_data.RRESP=vif.out_mon_cb.RRESP;
      rd_port.write(rd_data);
    end
endtask
endclass
