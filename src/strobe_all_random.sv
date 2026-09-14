class strobe_all_random extends uvm_sequence#(trans);
 
  `uvm_object_utils(strobe_all_random)
 
  function new(string name="strobe_all_random");
    super.new(name);
  endfunction
  
  task body();
    repeat(20)
      begin
        `uvm_do_with(req,{req.AWVALID==0;req.AWADDR<63;req.AWADDR[1:0]==0;req.WVALID==1;req.BREADY==0;req.WSTRB inside{[1:3]};req.ARVALID==0;req.RREADY==0;});
        `uvm_do_with(req,{req.AWVALID==1;req.AWADDR[1:0]==0;req.AWADDR<10;req.BREADY==1;req.ARVALID==0;req.RREADY==0;})
      end
  endtask
endclass