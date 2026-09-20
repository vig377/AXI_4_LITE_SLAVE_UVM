import uvm_pkg::*;
import pkg::*;
/*class base_test_v_seq  extends uvm_test;

`uvm_component_utils(base_test_v_seq)

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

endclass*/

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

endclass

class write_test extends base_test;

`uvm_component_utils(write_test)

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    first_addr_then_data sq1;
    first_data_then_addr sq2;
    aligned_all_write sq3;

    phase.raise_objection(this);
    sq1=first_addr_then_data::type_id::create("sq1");
    sq2=first_data_then_addr::type_id::create("sq2");
    sq3=aligned_all_write::type_id::create("sq3");

    `uvm_info("WRITE TEST ","starting First addr then data",UVM_MEDIUM)
    sq1.start(e.ag1.sqr1);
    `uvm_info("WRITE TEST","starting First data then addr",UVM_MEDIUM)
    sq2.start(e.ag1.sqr1);
    `uvm_info("WRITE TEST","starting ALLIGNED all write",UVM_MEDIUM)
    sq3.start(e.ag1.sqr1);
    phase.drop_objection(this);
  endtask
endclass

class read_test extends base_test;

`uvm_component_utils(read_test)

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    read_normal sq1;
    read_unaligned sq2;
    write_only_read sq3;

    phase.raise_objection(this);

    sq1=read_normal::type_id::create("sq1");
    sq2=read_unaligned::type_id::create("sq2");
    sq3=write_only_read::type_id::create("sq3");
    `uvm_info("READ TEST","starting read normal test",UVM_MEDIUM)
    sq1.start(e.ag1.sqr2);
    `uvm_info("READ TEST","starting read unaigned",UVM_MEDIUM)
    sq2.start(e.ag1.sqr2);
    `uvm_info("READ TEST","starting  write only read",UVM_MEDIUM)
    sq3.start(e.ag1.sqr2);
    phase.drop_objection(this);
  endtask
endclass


class strobe_test extends base_test;

`uvm_component_utils(strobe_test)

function new(string name,uvm_component parent);
  super.new(name,parent);
endfunction 

task run_phase(uvm_phase phase);
  strobe_all_zero sq1;
  strobe_all_one sq2;
  strobe_all_random sq3;

  phase.raise_objection(this);

  sq1=strobe_all_zero::type_id::create("sq1");
  sq2=strobe_all_one::type_id::create("sq2");
  sq3=strobe_all_random::type_id::create("sq3");

  `uvm_info("STROBE TEST","starting strobe all zero",UVM_MEDIUM)
  sq1.start(e.ag1.sqr1);
  `uvm_info("STROBE TEST","starting strobe all one",UVM_MEDIUM)
  sq2.start(e.ag1.sqr1);
  `uvm_info("STROBE TEST","starting strobe all random",UVM_MEDIUM)
  sq3.start(e.ag1.sqr1);

  phase.drop_objection(this);
endtask
endclass




class error_test extends base_test;

`uvm_component_utils(error_test)

  function new(string name, uvm_component parent);
  super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);

  dec_write sq1;
  dec_read sq2;

  phase.raise_objection(this);

  sq1 = dec_write::type_id::create("sq1");
  sq2 = dec_read::type_id::create("sq2");

  `uvm_info("ERROR_TEST","Starting DECERR WRITE", UVM_MEDIUM)

  sq1.start(e.ag1.sqr1);

  `uvm_info("ERROR_TEST", "Starting DECERR READ",  UVM_MEDIUM)

  sq2.start(e.ag1.sqr2);

  phase.drop_objection(this);

  endtask
endclass


class alignment_test extends base_test;

`uvm_component_utils(alignment_test)

  function new(string name, uvm_component parent);
  super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);

  unaligned_write sq1;
  read_unaligned sq2;

  phase.raise_objection(this);

  sq1 = unaligned_write::type_id::create("sq1");
  sq2 = read_unaligned::type_id::create("sq2");

  `uvm_info("ALIGNMENT_TEST","Starting UNALIGNED WRITE", UVM_MEDIUM)

  sq1.start(e.ag1.sqr1);

  `uvm_info("ALIGNMENT_TEST","Starting UNALIGNED READ", UVM_MEDIUM)

  sq2.start(e.ag1.sqr2);

  phase.drop_objection(this);

  endtask

endclass

class full_test extends base_test;

`uvm_component_utils(full_test)

  function new(string name, uvm_component parent);
  super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);

  virtual_seq v_sq;

  phase.raise_objection(this);

  v_sq = virtual_seq::type_id::create("v_sq");

  `uvm_info("FULL_TEST","Starting COMPLETE VIRTUAL SEQUENCE",UVM_MEDIUM)

  v_sq.start(e.v_sqr);

  phase.drop_objection(this);

  endtask

endclass

