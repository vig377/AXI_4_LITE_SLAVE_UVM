class trans extends uvm_sequence_item;

`uvm_object_utils(trans)

rand bit[`ADDR_WIDTH-1:0]AWADDR;
bit[2:0]AWPROT;
rand bit AWVALID;
rand bit[`DATA_WIDTH-1:0]WDATA;
rand bit [(`DATA_WIDTH/8)-1:0]WSTRB;
rand bit WVALID;
rand bit BREADY;
rand bit [`ADDR_WIDTH-1:0]ARADDR;
bit[2:0]ARPROT;
rand bit ARVALID;
rand bit RREADY;

bit AWREADY;
bit WREADY;
bit [1:0]BRESP;
bit BVALID;
bit ARREADY;
bit [`DATA_WIDTH-1:0]RDATA;
bit [1:0]RRESP;
bit RVALID;

bit wrt,rd;

function new(string name="trans");
  super.new(name);
endfunction

endclass
