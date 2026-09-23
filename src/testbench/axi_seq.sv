
///////////// Sequence ////////////////
class axi_seq extends uvm_sequence #(axi_seq_item);
	`uvm_object_utils(axi_seq)
	
	function new(string name="axi_seq");
		super.new(name);
	endfunction

	task body();
		req = axi_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		finish_item(req);
	endtask
endclass
//////////////////

class valid_write_addr extends axi_seq;
	`uvm_object_utils(valid_write_addr)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
      			op == WRITE;
      			awaddr inside {[32'h0:32'h24], 32'h3C};
    		});
    		finish_item(req);
  	endtask
endclass

class write_data_strb0 extends axi_seq;
	`uvm_object_utils(write_data_strb0)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == WRITE;
			wstrb[0] == 1'b1; 	// strb 0
    		});
    		finish_item(req);
  	endtask
endclass

class write_data_strb1 extends axi_seq;
	`uvm_object_utils(write_data_strb1)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == WRITE;
			wstrb[1] == 1'b1; 	// strb 1
    		});
    		finish_item(req);
  	endtask
endclass

class write_data_strb2 extends axi_seq;
	`uvm_object_utils(write_data_strb2)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == WRITE;
			wstrb[2] == 1'b1; 	// strb 2
    		});
    		finish_item(req);
  	endtask
endclass

class write_data_strb3 extends axi_seq;
	`uvm_object_utils(write_data_strb3)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == WRITE;
			wstrb[3] == 1'b1; 	// strb 3
    		});
    		finish_item(req);
  	endtask
endclass
		
class write_data_strb extends axi_seq;
	`uvm_object_utils(write_data_strb)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == WRITE;
			wstrb == 4'b1111; 	// all bits of strb set
    		});
    		finish_item(req);
  	endtask
endclass

class valid_read_addr extends axi_seq;
	`uvm_object_utils(valid_read_addr)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == READ;
			araddr inside {[32'h0:32'h24], 32'h3C};	 // valid read addr	
    		});
    		finish_item(req);
  	endtask
endclass

class write_in_ro extends axi_seq;
	`uvm_object_utils(write_in_ro)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == WRITE;
			awaddr inside {[32'h28:32'h30]};	// invalid write addr -> slverr
    		});
    		finish_item(req);
  	endtask
endclass

class read_in_wo extends axi_seq;
	`uvm_object_utils(read_in_wo)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == READ;
			araddr inside {[32'h34:32'h38]};	// invalid read addr -> slverr
    		});
    		finish_item(req);
  	endtask
endclass

class addr_unalignment extends axi_seq;
	`uvm_object_utils(addr_unalignment)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == READ;
			araddr inside {!(araddr[1:0] == 2'b00)};	// unaligned addr -> slverr
    		});
    		finish_item(req);
  	endtask
endclass

class addr_out_of_bound extends axi_seq;
	`uvm_object_utils(addr_out_of_bound)

	task body();
		req = axi_seq_item::type_id::create("req");
    		start_item(req);
    		assert(req.randomize() with {
			op == READ;
			araddr inside {[32'h39:32'h100]};		// out_of_bound addr -> decerr
    		});
    		finish_item(req);
  	endtask
endclass

