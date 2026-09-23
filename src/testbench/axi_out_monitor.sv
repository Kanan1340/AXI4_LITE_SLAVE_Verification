
class axi_out_monitor extends uvm_monitor;
	`uvm_component_utils(axi_out_monitor)
	axi_config cfg;
	virtual axi_if vif;
	axi_seq_item tr;
	uvm_analysis_port #(axi_seq_item) ap;
	
	function new(string name="axi_out_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal(get_type_name(),"config_db not found")
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = cfg.vif;
	endfunction

	task capture_b();
		tr.bready = 1;
    		do
       			@(vif.mon_cb);
    		while(!vif.mon_cb.bvalid);
    		tr.bready <= 0;
	endtask
	
	task capture_r();
		tr.rready = 1;
    		do
       			@(vif.mon_cb);
    		while(!vif.mon_cb.rvalid);
    		tr.rready <= 0;
	endtask
	
	task capture();
		if(vif.mon_cb.bvalid && vif.mon_cb.bready)
			capture_b();
		if(vif.mon_cb.rvalid && vif.mon_cb.rready)
			capture_r();
	endtask	
	
	task run_phase(uvm_phase phase);
		@vif.mon_cb;
		tr = axi_seq_item:: type_id:: create("tr",this);
		forever begin 
			capture();
			`uvm_info("[OUT_MON]",$sformatf("awaddr=%0h awvalid=%0b awready= %0b wdata=%0h wstrb=%0b wvalid=%0b wready=%0b bready=%0b bresp=%d bvalid=%b araddr=%0h arvalid=%0b arready=%0b rdata=%0h rready=%0b rresp=%0d rvalid=%0b", tr.awaddr, tr.awvalid, tr.awready, tr.wdata, tr.wstrb, tr.wvalid, tr.wready, tr.bready, tr.bresp, tr.bvalid, tr.araddr, tr.arvalid, tr.arready, tr.rdata, tr.rready, tr.rresp, tr.rvalid), UVM_LOW )  
			ap.write(tr);
		end
	endtask
endclass

