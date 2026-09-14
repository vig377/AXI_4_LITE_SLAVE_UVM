class dec_read extends uvm_sequence#(trans);
  `uvm_object_utils(dec_read)

  function new(string name="dec_read");
    super.new(name);
  endfunction

  task body();
    repeat(20)
      begin
        `uvm_do_with(req, { req.ARVALID == 1; req.ARADDR>63; req.RREADY == 1; req.WVALID == 0; req.AWVALID == 0; req.BREADY == 0; });
      end
  endtask
endclass