class wrt_seq extends uvm_sequence#(trans); 
`uvm_object_utils(wrt_seq)

function new(string name="wrt_seq");
  super.new(name);
endfunction

task body();
  `uvm_info("SEQ","WRITE BODY TSARTED",UVM_LOW)
  req=trans::type_id::create("req");
  `uvm_info("SEQ","BEFORE START ITEM",UVM_LOW)
  start_item(req);
  `uvm_info("SEQ","AFTER SART ITEM",UVM_LOW)
  req.randomize() with {req.AWADDR[1:0]==0;req.AWVALID==1;req.WVALID==0;req.BREADY==0;req.ARVALID==0;req.RREADY==0;};
  finish_item(req);
  `uvm_info("SEQ","FIRST WRT ITEM FINISHED",UVM_LOW)
 // `uvm_do_with(req,{req.AWVALID==0;req.WVALID==1;req.WDATA inside {[1:20]}; req.WSTRB==4'b1111;req.BREADY==1;});
endtask

endclass

class rd_seq extends uvm_sequence#(trans);

`uvm_object_utils(rd_seq)

function new(string name="rd_seq");
  super.new(name);
endfunction

task body();
  `uvm_do_with(req,{req.ARVALID==1;req.ARADDR[1:0]==0;req.RREADY==1;req.AWVALID==0;req.WVALID==0;req.BREADY==0;});
endtask

endclass



