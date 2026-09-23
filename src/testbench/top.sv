
`include "interface.sv"
`include "axi4_lite_slave.sv"
`include "test_pkg.sv"

module top;

	import uvm_pkg::*;
	import test_pkg::*;
	bit clk;
	bit rstn;
	// interface 
	axi_if inf(clk, rstn);

	// design - dut
	axi4_lite_slave #(.DATA_WIDTH(`DW), .ADDR_WIDTH(`AW), .MEM_DEPTH(`MEM_DEPTH), .DEFAULT_PROT(`prot_default)) 
	dut (
    	.ACLK(clk), .ARESETn(rstn),
	.AWADDR(inf.awaddr), .AWPROT  (inf.awprot), .AWVALID (inf.awvalid), .AWREADY (inf.awready),
	.WDATA(inf.wdata), .WSTRB   (inf.wstrb), .WVALID  (inf.wvalid), .WREADY  (inf.wready),
	.BRESP(inf.bresp), .BVALID  (inf.bvalid), .BREADY  (inf.bready),
	.ARADDR(inf.araddr), .ARPROT  (inf.arprot), .ARVALID (inf.arvalid), .ARREADY (inf.arready),
	.RDATA(inf.rdata), .RRESP   (inf.rresp), .RVALID  (inf.rvalid), .RREADY  (inf.rready)
	);
	
	initial begin 	
		uvm_config_db #(virtual axi_if):: set(null,"*","axi_if",inf);
		run_test("axi_test");
	end
	
	initial begin 
		clk = 1'b0;
		forever  
		    #5 clk = ~clk;
	end

	initial begin 
		rstn = 1'b0;
		#20;
		rstn = 1'b1;
		#100;
		rstn = 1'b0;
		#10;
		rstn = 1'b1;
	end

endmodule 

