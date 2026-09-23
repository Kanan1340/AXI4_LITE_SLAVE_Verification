
//////////////	out_agent  ///////////
class axi_out_agent extends uvm_agent;
	`uvm_component_utils(axi_out_agent)
	axi_out_monitor mon;
	axi_config cfg;

	function new(string name="axi_out_agent", uvm_component parent= null);
		super.new(name,parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))	
			`uvm_fatal(get_type_name(),"config_db not found")
		if(cfg.out_agent == UVM_PASSIVE)
			mon = axi_out_monitor::type_id::create("mon",this);
	endfunction 
	
endclass

