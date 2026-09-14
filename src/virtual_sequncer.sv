class virtual_sqr extends uvm_sequencer;
`uvm_component_utils(virtual_sqr)

function new(string name="virtual sequncer",uvm_component parent);
  super.new(name,parent);
endfunction

wrt_sqr sqr1;
rd_sqr sqr2;

endclass