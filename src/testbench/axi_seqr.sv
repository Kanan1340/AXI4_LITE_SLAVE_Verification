
///////////// Sequencer	///////////////
class axi_seqr extends uvm_sequencer #(axi_seq_item);
	`uvm_component_utils(axi_seqr)

	function new(string name="axi_sequencer", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
endclass

