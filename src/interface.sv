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

property write_addr_handshake;
@(posedge ACLK ) disable iff (!ARESETn)
  (AWVALID && !AWREADY) |=>(AWVALID);
  endproperty

property write_data_handshake;
@(posedge ACLK) disable iff (!ARESETn)
  (WVALID && !WREADY) |=>WVALID;
  endproperty

property write_response_handshake;
@(posedge ACLK)disable iff(!ARESETn)
  (BREADY && !BVALID)|=>BREADY;
endproperty

property read_addr_handshake;
@(posedge ACLK) disable iff(!ARESETn)
  (ARVALID && !ARREADY)|=>ARVALID;
endproperty

property read_data_handshake;
@(posedge ACLK) disable iff(!ARESETn)
  (!RVALID && RREADY)|=>RREADY;
endproperty


assert property (write_addr_handshake) $display("WRITE ADDR HANDSHAKE ASSERTION PASSED");else $display("WRITE ADDR HANDSHAKE FAILED");
assert property (write_data_handshake) $display("WRITE DATA HANDSHAKE ASSERTION PASSED");else $display("WRITE DATA HANDSHAKE FAILED");
assert property (write_response_handshake) $display("WRITE RESPONSE HANDSHAKE ASSERTION PASSED");else $display("WRITE RESPONSE HANDSHAKE FAILED");
assert property (read_addr_handshake) $display("READ ADDR HANDSHAKE ASSERTION PASSED");else $display("READ ADDR HANDSHAKE FAILED");
assert property (read_data_handshake) $display("READ DATA  HANDSHAKE ASSERTION PASSED");else $display("READ DATA HANDSHAKE FAILED");

cover property (write_addr_handshake);
endinterface
