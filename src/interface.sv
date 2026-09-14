`include "defines.svh"
interface axi(input bit ACLK,ARESETn);
logic [`ADDR_WIDTH-1:0]AWADDR;
logic [2:0]AWPROT;
logic AWVALID;
logic AWREADY;
logic [`DATA_WIDTH-1:0]WDATA;
logic [(`DATA_WIDTH/8)-1:0]WSTRB;
logic WVALID;
logic WREADY;
logic [1:0]BRESP;
logic BVALID;
logic  BREADY;
logic [`ADDR_WIDTH-1:0]ARADDR;
logic [2:0]ARPROT;
logic ARVALID;
logic ARREADY;
logic [`DATA_WIDTH-1:0]RDATA;
logic [1:0]RRESP;
logic RVALID;
logic RREADY;

clocking drv_cb@(posedge ACLK);
  default input #0 output #1;
  output  AWADDR,AWPROT,AWVALID,WDATA,WSTRB,WVALID,BREADY,ARADDR,ARPROT,ARVALID,RREADY;
endclocking

clocking inp_mon_cb@(posedge ACLK);
  default input #1 output #0;
  input AWADDR,AWPROT,AWVALID,WDATA,WSTRB,WVALID,ARADDR,ARPROT,ARVALID,RREADY,BREADY;
  input AWREADY,WREADY,ARREADY,BVALID,RVALID;
endclocking

clocking out_mon_cb@(posedge ACLK);
  default input #1 output #0;
  input AWREADY,WREADY,BRESP,BVALID,ARREADY,RDATA,RRESP,RVALID;
  input BREADY,RREADY;
endclocking

modport drv(clocking drv_cb,input ACLK,input AWREADY,WREADY,BVALID,ARREADY,RVALID);
  modport inp_mon(clocking inp_mon_cb,input ACLK);
modport out_mon(clocking out_mon_cb,input ACLK);

endinterface
