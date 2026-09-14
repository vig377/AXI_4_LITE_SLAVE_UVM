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
      if((vif.out_mon_cb.BREADY) && vif.out_mon_cb.RREADY)
        begin
          fork
            addr_resp();
            read_data();
          join
        end
      else if(vif.out_mon_cb.BREADY && !vif.out_mon_cb.RREADY)
        begin
        addr_resp();
        end
      else if(!vif.out_mon_cb.BREADY && vif.out_mon_cb.RREADY)
        begin
        read_data();
        end
      end
endtask

task addr_resp();
  if(vif.out_mon_cb.BREADY)
    begin
      wrt_resp=trans::type_id::create("wrt_resp");
      $display("OUTPUT MONIOR WAITNG FOR BVALID at time %t",$time);
      @(posedge vif.ACLK iff vif.out_mon_cb.BVALID);
      $display("OUTPUT MONIOR GOT BVALID at time %t",$time);
      wrt_resp.BVALID=vif.out_mon_cb.BVALID;
      wrt_resp.BRESP=vif.out_mon_cb.BRESP;
      wrt_port.write(wrt_resp);
      $display("OUTPUT MONITOR write  BRESP= %b BVALID = %b at time %t",wrt_resp.BRESP,wrt_resp.BVALID,$time);
    end
endtask

task read_data();
  if(vif.out_mon_cb.RREADY)
    begin
      rd_data=trans::type_id::create("rd_data");
      $display("OUTPUT MONITOR WAITING for RVALID at time %t",$time);
      @(posedge vif.ACLK iff vif.out_mon_cb.RVALID);
      $display("OUTPUT MONITOR GOT RVALID at time %t",$time);
      rd_data.RVALID=vif.out_mon_cb.RVALID;
      rd_data.RDATA=vif.out_mon_cb.RDATA;
      rd_data.RRESP=vif.out_mon_cb.RRESP;
      rd_port.write(rd_data);
      $display("OUTPUT MONITOR read RDATA = %d RRESP = %b RVALID =%b at time %t",rd_data.RDATA,rd_data.RRESP,rd_data.RVALID,$time);
    end
endtask
endclass
