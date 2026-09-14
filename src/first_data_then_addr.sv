class first_data_then_addr extends uvm_sequence#(trans);
  `uvm_object_utils(first_data_then_addr)
  bit [`DATA_WIDTH-1:0]wdata;
  
  function new(string name="first data then addr");
    super.new(name);
  endfunction
 
  task body();
    repeat(10)
      begin
        req=trans::type_id::create("req");
    	start_item(req);
        req.randomize() with {req.AWVALID==0;req.AWADDR[1:0]==0;req.AWADDR<63;req.WVALID==1;req.WDATA inside{[1:10]};req.WSTRB==4'b1111;req.BREADY==0;req.ARVALID==0;req.RREADY==0;};
    	//wdata=req.WDATA;
        finish_item(req);
        `uvm_do_with(req,{req.AWVALID==1;req.WVALID==0;req.AWADDR[1:0]==0;req.AWADDR<63;req.WSTRB inside{[1:4]};req.BREADY==1;req.ARVALID==0;req.RREADY==0;});
      end
  endtask
endclass