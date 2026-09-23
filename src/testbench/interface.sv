
//////	interface //////////
`include "define.svh"

interface axi_if(input bit aclk, arstn);
	logic [`AW-1:0] awaddr;	
	logic [2:0] awprot;	
	logic awvalid; 
	logic awready;

	logic [`DW-1:0] wdata;
	logic [`STRB_W-1:0] wstrb;
	logic wvalid;
	logic wready;

	logic [1:0] bresp;
	logic bvalid;
	logic bready;

	logic [`AW-1:0] araddr;
	logic [2:0] arprot;
	logic arvalid;
	logic arready;

	logic [`DW-1:0] rdata;
	logic [1:0] rresp;
	logic rvalid;
	logic rready; 

	clocking drv_cb @(posedge aclk);
		default input #1step output #1step;
		output awaddr, awprot, awvalid, wdata, wstrb, wvalid, bready, araddr, arprot, arvalid, rready;  
		input awready, wready, bresp, bvalid, arready, rdata, rresp, rvalid;
	endclocking

	clocking mon_cb @(posedge aclk);
		default input #1step;
		input awaddr, awprot, awvalid, wdata, wstrb, wvalid, bready, araddr, arprot, arvalid, rready;
		input awready, wready, bresp, bvalid, arready, rdata, rresp, rvalid;  
	endclocking
	
	modport DRV(clocking drv_cb);
	modport MON(clocking mon_cb);
endinterface

