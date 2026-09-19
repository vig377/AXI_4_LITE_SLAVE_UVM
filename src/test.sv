class base_test extends uvm_test;

`uvm_component_utils(base_test)

environment e;

function new(string name,uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  e=environment::type_id::create("e",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction

task run_phase(uvm_phase phase);
//   rd_seq sq2;
//   wrt_seq sq1;
  virtual_seq v_sq;
  phase.raise_objection(this,"objection raised");
  uvm_top.set_timeout(20000ns);
  v_sq=virtual_seq::type_id::create("v_Sq");
  v_sq.start(e.v_sqr);
//   sq1=wrt_seq::type_id::create("sq1");
//   sq2=rd_seq::type_id::create("sq2");
//   sq1.start(e.ag1.sqr1);
//   sq2.start(e.ag1.sqr2);
  phase.drop_objection(this,"objection dropped");
endtask

endclass
