
//////////////	Test  /////////////////
class axi_test extends uvm_test;
	`uvm_component_utils(axi_test)
	axi_seq s;
	valid_write_addr s1;
	write_data_strb0 s2;
	write_data_strb1 s3;
	write_data_strb2 s4;
	write_data_strb3 s5;
	write_data_strb s6;	
	valid_read_addr	s7;
	write_in_ro s8;
	read_in_wo s9;
	addr_unalignment s10;
	addr_out_of_bound s11;

	axi_env env;
	axi_config cfg;
	
	function new(string name="axi_test", uvm_component parent= null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
			`uvm_fatal(get_type_name(),"config_db not found")
		env = axi_env::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			s1 = valid_write_addr::type_id::create("s1");
			s2 = write_data_strb0::type_id::create("s2");
			s3 = write_data_strb1::type_id::create("s3");
			s4 = write_data_strb2::type_id::create("s4");
			s5 = write_data_strb3::type_id::create("s5");
			s6 = write_data_strb::type_id::create("s6");
			s7 = valid_read_addr::type_id::create("s7");
			s8 = write_in_ro::type_id::create("s8");
			s9 = read_in_wo::type_id::create("s9");
			s10 = addr_unalignment::type_id::create("s10");
			s11 = addr_out_of_bound::type_id::create("s11");
  			
			begin
				s1.start(env.ai.seqr);
				#20;
				s2.start(env.ai.seqr);
				#20;
				s3.start(env.ai.seqr);
				#20;
				s4.start(env.ai.seqr);
				#20;
				s5.start(env.ai.seqr);
				#20;
				s6.start(env.ai.seqr);
				#20;
				s7.start(env.ai.seqr);
				#20;
				s8.start(env.ai.seqr);
				#20;
				s9.start(env.ai.seqr);
				#20;
				s10.start(env.ai.seqr);
				#20;
				s11.start(env.ai.seqr);
			end
			#50;
		phase.drop_objection(this);
	endtask
endclass

