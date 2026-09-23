
class axi_seq_item extends uvm_sequence_item;	
	rand bit [`AW-1:0] awaddr;
	rand bit [2:0] awprot;		
	bit awvalid; 
	rand bit [`DW-1:0] wdata;
	rand bit [`STRB_W-1:0] wstrb;
	bit wvalid;
	rand bit bready;
	rand bit [`AW-1:0] araddr;
	rand bit [2:0] arprot;
	bit arvalid;
	rand bit rready; 

	bit awready, wready, arready;
	bit [`DW-1:0] rdata;
	bit [1:0] bresp;
    	bit bvalid;
	bit [1:0] rresp;
	bit rvalid;

	typedef enum {WRITE, READ} cmd;
	rand cmd op;

	`uvm_object_utils_begin(axi_seq_item)
		`uvm_field_int(awaddr,UVM_ALL_ON)
		`uvm_field_int(awprot,UVM_ALL_ON)
		`uvm_field_int(awvalid,UVM_ALL_ON)
		`uvm_field_int(wdata,UVM_ALL_ON)
		`uvm_field_int(wstrb,UVM_ALL_ON)
		`uvm_field_int(wvalid,UVM_ALL_ON)
		`uvm_field_int(bvalid,UVM_ALL_ON)
		`uvm_field_int(bready,UVM_ALL_ON)
		`uvm_field_int(araddr,UVM_ALL_ON)
		`uvm_field_int(arprot,UVM_ALL_ON)
		`uvm_field_int(arvalid,UVM_ALL_ON)
		`uvm_field_int(rready,UVM_ALL_ON)
		`uvm_field_int(awready,UVM_ALL_ON)
		`uvm_field_int(wready,UVM_ALL_ON)
		`uvm_field_int(arready,UVM_ALL_ON)
		`uvm_field_int(rdata,UVM_ALL_ON)
		`uvm_field_int(bresp,UVM_ALL_ON)
		`uvm_field_int(rresp,UVM_ALL_ON)
		`uvm_field_int(rvalid,UVM_ALL_ON)
	`uvm_object_utils_end
	
	function new(string name="axi_seq_item");
		super.new(name);
	endfunction 
	
	constraint c{
		op dist{WRITE:=50, READ:=50};
	}

endclass

