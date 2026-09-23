
class axi_in_monitor extends uvm_monitor;
	`uvm_component_utils(axi_in_monitor)
	axi_config cfg;
	virtual axi_if vif;
	axi_seq_item tr;
	uvm_analysis_port #(axi_seq_item) ap;

	function new(string name="axi_in_monitor", uvm_component parent = null);
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
	
	task capture_aw();
		tr.awaddr = vif.mon_cb.awaddr;
		tr.awprot = vif.mon_cb.awprot;
		tr.awvalid = 1;
    		do
       			@(vif.mon_cb);
    		while(!vif.mon_cb.awready);
    		tr.awvalid <= 0;
	endtask

	task capture_w();
		tr.wdata = vif.mon_cb.wdata;
		tr.wstrb = vif.mon_cb.wstrb;
		tr.wvalid = 1;
    		do
       			@(vif.mon_cb);
    		while(!vif.mon_cb.wready);
    		tr.wvalid <= 0;
	endtask

	task capture_ar();
		tr.araddr = vif.mon_cb.araddr;
		tr.arprot = vif.mon_cb.arprot;
		tr.arvalid = 1;
    		do
       			@(vif.mon_cb);
    		while(!vif.mon_cb.arready);
    		tr.arvalid <= 0;
	endtask
	
	task capture();
		if(vif.mon_cb.awvalid && vif.mon_cb.awready)
			capture_aw();
		if(vif.mon_cb.wvalid && vif.mon_cb.wready)
			capture_w();
		if(vif.mon_cb.arvalid && vif.mon_cb.arready)
			capture_ar();
	endtask
	
	task run_phase(uvm_phase phase);
		@vif.mon_cb;
		tr = axi_seq_item:: type_id:: create("tr",this);
		forever begin 
			capture();
			`uvm_info("[IN_MON]",$sformatf("awaddr=%0h awvalid=%0b wdata=%0h wstrb=%0b wvalid=%0b bready=%0b araddr=%0h arvalid=%0b rready=%0b ",tr.awaddr, tr.awvalid, tr.wdata, tr.wstrb, tr.wvalid, tr.bready, tr.araddr, tr.arvalid, tr.rready), UVM_LOW )  
			ap.write(tr);	
		end
	endtask
endclass

