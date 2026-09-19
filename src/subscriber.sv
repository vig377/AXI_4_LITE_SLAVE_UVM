`uvm_analysis_imp_decl(_wrt)
`uvm_analysis_imp_decl(_rd)
class subscriber extends uvm_subscriber#(trans);

`uvm_component_utils(subscriber)

uvm_analysis_imp_wrt#(trans,subscriber)wrt_port;
uvm_analysis_imp_rd#(trans,subscriber)rd_port;
trans in_wrt,in_rd;

covergroup wrt_cg;
  AWADDR:coverpoint in_wrt.AWADDR{bins mult_4[]={[0:60]} with (item%4==0);
                              bins non_mult_4={[0:60]} with (item%4!=0);}
  WDATA:coverpoint in_wrt.WDATA{ bins  other=default;}
  AWVALID:coverpoint in_wrt.AWVALID {bins b1={0,1};}
  WSTRB:coverpoint in_wrt.WSTRB{bins zero={4'b0000};bins max={4'b1111};bins other = default;}
  WVALID:coverpoint in_wrt.WVALID{bins b1={0,1};}
  BREADY:coverpoint in_wrt.BREADY { bins b1={0,1};}
endgroup

covergroup rd_cg;
  ARADDR:coverpoint in_rd.ARADDR{ bins mult_4={[0:60]} with (item%4==0);
                                bins non_mult_4={[0:60]} with (item%4!=0);}
  ARVALID:coverpoint in_rd.ARVALID{bins b1={0,1};}
  RREADY:coverpoint in_rd.RREADY{bins b2={0,1};}
endgroup

function new(string name,uvm_component parent);
  super.new(name,parent);
  wrt_cg=new();
  rd_cg=new();
  wrt_port=new("wrt_port",this);
  rd_port=new("rd_port",this);
endfunction

function void write_wrt(trans t);
  in_wrt=t;
  wrt_cg.sample();
endfunction

function void write(trans t);
endfunction

function void write_rd(trans t);
  in_rd=t;
  rd_cg.sample();
endfunction

endclass
