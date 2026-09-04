class environment extends uvm_env;

`uvm_component_utils(environment)

active_agent ag1;
passive_agent ag2;
scoreboard sb;
subscriber sc;

function new(string name,uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  ag1=active_agent::type_id::create("ag1",this);
  ag2=passive_agent::type_id::create("ag2",this);
  sb=scoreboard::type_id::create("sb",this);
  sc=subscriber::type_id::create("sc",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  ag1.mon.wrt_port.connect(sb.in_wrt_fifo.analysis_export);
  ag1.mon.rd_port.connect(sb.in_rd_fifo.analysis_export);
  ag2.mon.wrt_port.connect(sb.out_wrt_fifo.analysis_export);
  ag2.mon.rd_port.connect(sb.out_rd_fifo.analysis_export);
  ag1.mon.wrt_port.connect(sc.wrt_port);
  ag1.mon.rd_port.connect(sc.rd_port);
endfunction 

endclass
