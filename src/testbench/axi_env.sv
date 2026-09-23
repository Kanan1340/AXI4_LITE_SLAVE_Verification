
////////////  environment  /////////////
class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)
	axi_in_agent ai;
	axi_out_agent ao;
	axi_scoreboard scb;
	axi_config cfg;
	
	function new(string name="axi_env", uvm_component parent= null);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal(get_type_name(),"config_db not found")
		ai = axi_in_agent::type_id::create("ai",this);
		ao = axi_out_agent::type_id::create("ao",this);
		scb = axi_scoreboard::type_id::create("scb",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ai.mon.ap.connect(scb.req_fifo.analysis_export);
		ao.mon.ap.connect(scb.rsp_fifo.analysis_export);
	endfunction
endclass

