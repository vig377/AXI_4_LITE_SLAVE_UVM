class unaligned_write extends uvm_sequence#(trans);
  `uvm_object_utils(unaligned_write)
  
  function new(string name="unaligned_write");
    super.new(name);
  endfunction
  
  task body();
    repeat(20)
      begin
        `uvm_do_with(req,{req.AWVALID==0;req.AWADDR<63;req.WVALID==1;req.BREADY==0;req.WSTRB==4'b1111;req.ARVALID==0;req.RREADY==0;});
        `uvm_do_with(req,{req.AWVALID==1;req.AWADDR<63;req.BREADY==1;req.ARVALID==0;req.RREADY==0;})
      end
  endtask
endclass