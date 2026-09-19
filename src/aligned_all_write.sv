class aligned_all_write extends uvm_sequence#(trans);

`uvm_object_utils(aligned_all_write)
bit [`ADDR_WIDTH-1:0]waddr;

function new(string name="aligned_all_write");
  super.new(name);
endfunction 

task body();
  for(int i=0;i<63;i=i+4)
    begin
    `uvm_do_with(req,{req.AWVALID==0;req.WVALID==1;req.BREADY==0;req.ARVALID==0;req.RREADY==0;})
    `uvm_do_with(req,{req.AWVALID==1;req.AWADDR==i;req.WVALID==0;req.BREADY==1;req.ARVALID==0;req.RREADY==0;})
    end
  endtask

  endclass
