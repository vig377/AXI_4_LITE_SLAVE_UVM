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
  wrt_seq sq1;
  rd_seq sq2;
  phase.raise_objection(this,"objection raised");
  sq1=wrt_seq::type_id::create("sq1");
  sq2=rd_seq::type_id::create("sq2");
  fork
    begin
    `uvm_info("TEST","BEFORE WRITE START",UVM_LOW)
    sq1.start(e.ag1.sqr1);
    `uvm_info("TEST","AFTER WRITE_START",UVM_LOW)
    end
    begin
    `uvm_info("TEST","BEFORE READ  START",UVM_LOW)
    sq2.start(e.ag1.sqr2);
    `uvm_info("TEST","AFTER READ START",UVM_LOW)
    end
  join
  phase.drop_objection(this,"objection dropped");
endtask

endclass
