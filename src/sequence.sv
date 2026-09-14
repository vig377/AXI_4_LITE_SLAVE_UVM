class wrt_seq extends uvm_sequence#(trans);
`uvm_object_utils(wrt_seq)
  bit [`ADDR_WIDTH-1:0]waddr;
function new(string name="wrt_seq");
  super.new(name);
endfunction

task body();
 // `uvm_info("SEQ","WRITE BODY TSARTED",UVM_LOW)
 // repeat(1)
    begin
  req=trans::type_id::create("req");
  //`uvm_info("SEQ","BEFORE START ITEM",UVM_LOW)
  start_item(req);
  //`uvm_info("SEQ","AFTER SART ITEM",UVM_LOW)
      req.randomize() with {req.AWVALID==1;req.AWADDR==4;req.WVALID==0;req.WSTRB==4'b1111;req.AWADDR[1:0]==0;req.WDATA inside {[1:20]};req.BREADY==0;req.ARVALID==0;req.RREADY==0;};
      waddr=req.AWADDR;
  finish_item(req);
  //`uvm_info("SEQ","FIRST WRT ITEM FINISHED",UVM_LOW)
      `uvm_do_with(req,{req.AWVALID==0;req.AWADDR==waddr;req.WVALID==1;req.WDATA inside {[1:20]}; req.WSTRB==4'b1111;req.BREADY==1;req.ARVALID==0;req.RREADY==0;});
   // end
   //begin
  req=trans::type_id::create("req");
  //`uvm_info("SEQ","BEFORE START ITEM",UVM_LOW)
  start_item(req);
  //`uvm_info("SEQ","AFTER SART ITEM",UVM_LOW)
      req.randomize() with {req.AWVALID==1;req.AWADDR==5;req.WVALID==0;req.WSTRB==4'b1111;req.WDATA inside {[1:20]};req.BREADY==0;req.ARVALID==0;req.RREADY==0;};
      waddr=req.AWADDR;
  finish_item(req);
  //`uvm_info("SEQ","FIRST WRT ITEM FINISHED",UVM_LOW)
      `uvm_do_with(req,{req.AWVALID==0;req.AWADDR==waddr;req.WVALID==1;req.WDATA inside {[1:20]}; req.WSTRB==4'b1111;req.BREADY==1;req.ARVALID==0;req.RREADY==0;});
    end
endtask

endclass

class rd_seq extends uvm_sequence#(trans);

`uvm_object_utils(rd_seq)

function new(string name="rd_seq");
  super.new(name);
endfunction

task body();
  repeat(10)
    begin
      `uvm_do_with(req,{req.ARVALID==1;req.ARADDR==4;req.ARADDR[1:0]==0;req.RREADY==1;req.AWVALID==0;req.WVALID==0;req.BREADY==0;});
    end
endtask

endclass
