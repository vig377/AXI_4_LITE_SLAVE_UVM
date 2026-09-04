`include "package.sv"
`include "interface.sv"
`include "design.sv"
module top;
import uvm_pkg::*;
import pkg::*;
bit ACLK,ARESETn;

initial begin
  ACLK=0;
  forever #5 ACLK=~ACLK;
end

axi intf(ACLK,ARESETn);

axi4_lite_slave duv(.ARESETn(ARESETn),.ACLK(ACLK),.AWADDR(intf.AWADDR),.AWPROT(intf.AWPROT),.AWVALID(intf.AWVALID),.AWREADY(intf.AWREADY),.WDATA(intf.WDATA),.WSTRB(intf.WSTRB),.WVALID(intf.WVALID),.WREADY(intf.WREADY),.BVALID(intf.BVALID),.BRESP(intf.BRESP),.BREADY(intf.BREADY),.ARADDR(intf.ARADDR),.ARPROT(intf.ARPROT),.ARVALID(intf.ARVALID),.ARREADY(intf.ARREADY),.RRESP(intf.RRESP),.RDATA(intf.RDATA),.RVALID(intf.RVALID),.RREADY(intf.RREADY));

initial begin
  uvm_config_db#(virtual axi.drv)::set(null,"uvm_test_top.e.ag1.drv","vif",intf.drv);
  uvm_config_db#(virtual axi.inp_mon)::set(null,"uvm_test_top.e.ag1.mon","vif",intf.inp_mon);
  uvm_config_db#(virtual axi.out_mon)::set(null,"uvm_test_top.e.ag2.mon","vif",intf.out_mon);
  run_test("base_test");
end

initial begin

  ARESETn=0;
  #2;
  ARESETn=1;

end

endmodule


