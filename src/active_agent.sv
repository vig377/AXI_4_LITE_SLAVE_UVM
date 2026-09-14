class active_agent extends uvm_agent;

`uvm_component_utils(active_agent)

driver drv;
input_monitor mon;
wrt_sqr sqr1;
rd_sqr sqr2;

function new(string name,uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  drv=driver::type_id::create("drv",this);
  mon=input_monitor::type_id::create("mon",this);
  sqr1=wrt_sqr::type_id::create("sqr1",this);
  sqr2=rd_sqr::type_id::create("sqr2",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  drv.wrt_port.connect(sqr1.seq_item_export);
  drv.rd_port.connect(sqr2.seq_item_export);
  `uvm_info("AGENT","WRT PORT CONNECTED",UVM_LOW)
  `uvm_info("AGENT","RD PORT CONNECTD",UVM_LOW)
endfunction
endclass
