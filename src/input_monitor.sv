class input_monitor extends uvm_monitor;

`uvm_component_utils(input_monitor)
virtual axi.inp_mon vif;
uvm_analysis_port#(trans)wrt_port;
uvm_analysis_port#(trans)rd_port;
trans wrt_trans,rd_trans;
bit addr_done,data_done,rd_addr_done,is_create;

function new(string name,uvm_component parent);
  super.new(name,parent);
  wrt_port=new("wrt_port",this);
  rd_port=new("rd_port",this);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual axi.inp_mon)::get(this,"","vif",vif))
    `uvm_fatal("INP MON","config db not set for input monitor")
endfunction

// task run_phase(uvm_phase phase);
//   forever
//     begin
//     @(vif.inp_mon_cb);
//       if((vif.inp_mon_cb.AWVALID || vif.inp_mon_cb.WVALID))
//         begin
//           if(is_create==0)
//             begin
//             wrt_trans=trans::type_id::create("wrt_trans");
//             is_create=1;
//             end

//         fork
//           begin
//           fork
//           wrt_addr();
//           wrt_data();
//           join

//           if(addr_done && data_done)
//             send_write();

//           end
//         begin
//         rd_addr();
//         send_read();
//         end

//         join

//         end

// //       if((vif.inp_mon_cb.AWVALID || vif.inp_mon_cb.WVALID) && !vif.inp_mon_cb.ARVALID)
// //         begin
// //         if(!is_create)
// //           begin
// //             wrt_trans=trans::type_id::create("wrt_trans");
// //             is_create=1;
// //           end
// //         fork
// //         wrt_addr();
// //         wrt_data();
// //         join

// //         if(addr_done && data_done)
// //           send_write();

// //         end

//       if( vif.inp_mon_cb.ARVALID)
//         begin
//         rd_addr();
//         send_read();
//         end

//     end
// endtask
    task run_phase(uvm_phase phase);
  forever
    begin
    @(vif.inp_mon_cb);
      if(vif.inp_mon_cb.AWVALID || vif.inp_mon_cb.WVALID)
        begin
          if(is_create==0)
            begin
            wrt_trans=trans::type_id::create("wrt_trans");
            is_create=1;
            end

        fork
          begin
          fork
          wrt_addr();
          wrt_data();
          join

          if(addr_done && data_done)
            send_write();
          end

          begin
          if(vif.inp_mon_cb.ARVALID)
            begin
            rd_addr();
            send_read();
            end
          end
        join
        end

      else if(vif.inp_mon_cb.ARVALID)
        begin
        rd_addr();
        send_read();
        end

    end
endtask

    
    
    
task wrt_addr();
   if(vif.inp_mon_cb.AWVALID && addr_done==0)
    begin
      $display("INPUT MONITOR WAITING FOR AWREADY at time %t",$time);
      @(posedge vif.ACLK iff vif.inp_mon_cb.AWREADY);
      $display("INPUT MONITOR GOT AWREADY at time %t",$time);

      addr_done=1;
      wrt_trans.AWADDR=vif.inp_mon_cb.AWADDR;
      wrt_trans.AWVALID=vif.inp_mon_cb.AWVALID;
      $display("INP MON ADDR AWADDR %d AWVALID %B",wrt_trans.AWADDR,wrt_trans.AWVALID);
    end
endtask

task wrt_data();
  if(vif.inp_mon_cb.WVALID && data_done==0)
    begin
    $display("INPUT MONITOR WAITING FOR WREADY at time %t",$time);
      @(posedge vif.ACLK iff vif.inp_mon_cb.WREADY);
      $display("INPUT MONITOR GOT WREADY at time %t",$time);
        data_done=1;
    wrt_trans.WDATA=vif.inp_mon_cb.WDATA;
    wrt_trans.WSTRB=vif.inp_mon_cb.WSTRB;
    wrt_trans.WVALID=vif.inp_mon_cb.WVALID;
      $display("INP MON DATA WDATA=%d WVALID %b",wrt_trans.WDATA,wrt_trans.WVALID);
  
    end
endtask

task send_write();
  if(vif.inp_mon_cb.BREADY)
   begin
  $display("waiting for WRITE RESPONSE HANDSHAKE at time %t",$time);
     @(posedge vif.ACLK iff  vif.inp_mon_cb.BVALID);

  wrt_port.write(wrt_trans);
  addr_done=0;
  data_done=0;
  is_create=0;
  $display("INPUT MONITOR WRITE AWADDR = %d WVALID=%d WDATA =%d WSTRB = %b WVALID= %b at time  %t",wrt_trans.AWADDR,wrt_trans.WVALID,wrt_trans.WDATA,wrt_trans.WSTRB,wrt_trans.WVALID,$time);
   end
endtask

task rd_addr();
  if(vif.inp_mon_cb.ARVALID && rd_addr_done==0)
    begin
      rd_trans=trans::type_id::create("rd_trans");
      $display("INPUT MONITOR WAITING FOR ARREADY at time %t",$time);
      @(posedge vif.ACLK iff vif.inp_mon_cb.ARREADY);
      $display("INPUT MONITOR GOT  ARREADY at time %t",$time);
	  rd_trans.ARADDR=vif.inp_mon_cb.ARADDR;
      rd_trans.ARVALID=vif.inp_mon_cb.ARVALID;
      rd_addr_done=1;
    end
endtask

task send_read();
  if(rd_addr_done)
    begin
      @(posedge vif.ACLK iff(vif.inp_mon_cb.RREADY && vif.inp_mon_cb.RVALID)); 
    rd_port.write(rd_trans);
      $display("INPUT MONItOR READ ARADDR = %d ARVALID= %b at time =%t ",rd_trans.ARADDR,rd_trans.ARVALID,$time);
    rd_addr_done=0;
    end

endtask
endclass
