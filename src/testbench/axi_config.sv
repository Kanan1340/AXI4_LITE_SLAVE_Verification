
//////////////	Config	/////////////
class axi_config extends uvm_object;
	`uvm_object_utils(axi_config)
	virtual axi_if vif;
	uvm_active_passive_enum in_agent;
	uvm_active_passive_enum out_agent;
		
	function new(string name="axi_config");
		super.new(name);
		in_agent = UVM_ACTIVE;
		out_agent = UVM_PASSIVE;
	endfunction
endclass

