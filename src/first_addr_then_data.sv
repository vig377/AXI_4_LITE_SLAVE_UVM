class first_addr_then_data extends uvm_sequence#(trans);
`uvm_object_utils(first_addr_then_data)
  bit [`DATA_WIDTH-1:0]waddr;
  
  function new(string name="first_addr then data");
    super.new(name);
  endfunction
 
  task body();
    repeat(10)
      begin
        req=trans::type_id::create("req");
    	start_item(req);
    	req.randomize() with {req.AWVALID==1;req.AWADDR[1:0]==0;req.AWADDR<63;req.WVALID==0;req.WDATA inside{[1:10]};req.WSTRB==4'b1111;req.BREADY==0;req.ARVALID==0;req.RREADY==0;};
    	//waddr=req.AWADDR;
        finish_item(req);
        `uvm_do_with(req,{req.AWVALID==0;req.WVALID==1;req.WSTRB == 4'b1111;req.BREADY==1;req.ARVALID==0;req.RREADY==0;});
      end
  endtask
endclass
