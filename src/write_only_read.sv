class write_only_read extends uvm_sequence#(trans);
  `uvm_object_utils(write_only_read)

  function new(string name="write_only_read");
    super.new(name);
  endfunction

  task body();
    repeat(20)
      begin
        `uvm_do_with(req, { req.ARVALID == 1; req.ARADDR inside{52,56}; req.RREADY == 1; req.WVALID == 0; req.AWVALID == 0; req.BREADY == 0; });
      end
  endtask
endclass