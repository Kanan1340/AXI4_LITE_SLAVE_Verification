
class axi_in_agent extends uvm_agent;
	`uvm_component_utils(axi_in_agent)
	axi_config cfg;
	axi_driver drv;
	axi_in_monitor mon;
	axi_seqr seqr;	

	function new(string name ="axi_in_agent", uvm_component parent=null);
		super.new(name,parent);	
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))	
			`uvm_fatal(get_type_name(),"config_db not found")
		mon = axi_in_monitor::type_id::create("mon",this);
		if(cfg.in_agent==UVM_ACTIVE)
			drv = axi_driver::type_id::create("drv",this);
			seqr = axi_seqr::type_id::create("seqr",this);
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass

