class read_normal extends uvm_sequence#(trans);
`uvm_object_utils(read_normal)

  function new(string name="read_normal");
    super.new(name);
  endfunction

  task body();
    repeat(2)
      begin
        `uvm_do_with(req, { req.ARVALID == 1; req.ARADDR <63; req.ARADDR[1:0] == 0; req.RREADY == 1; req.WVALID == 0; req.AWVALID == 0; req.BREADY == 0; });
      end
      $display("READ NORAML COMPLETED\n");
  endtask
//   task body();
//   repeat(10)
//     begin
//       `uvm_do_with(req,{req.ARVALID==1;req.ARADDR==4;req.ARADDR[1:0]==0;req.RREADY==1;req.AWVALID==0;req.WVALID==0;req.BREADY==0;});
//     end
// endtask
endclass
