
//typedef virtual axi_if;
	
//////////////	Driver  /////////////
class axi_driver extends uvm_driver #(axi_seq_item);
	`uvm_component_utils(axi_driver)
	axi_config cfg;
	virtual axi_if vif;
	// axi_if vif;

	function new(string name="axi_driver", uvm_component parent = null);
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

	task drive_valid_awaddr();
    		vif.drv_cb.awaddr  <= req.awaddr;
		vif.drv_cb.awprot  <= req.awprot;
		vif.drv_cb.awvalid <= 1;
    		do
       			@(vif.drv_cb);
    		while(!vif.drv_cb.awready);
    		vif.drv_cb.awvalid <= 0;
	endtask	

	task drive_valid_wdata();
    		vif.drv_cb.wdata  <= req.wdata;
		vif.drv_cb.wstrb  <= req.wstrb;
    		vif.drv_cb.wvalid <= 1;
    		do
       			@(vif.drv_cb);
    		while(!vif.drv_cb.wready);
    		vif.drv_cb.wvalid <= 0;
	endtask	

	task drive_valid_araddr();
    		vif.drv_cb.araddr  <= req.araddr;
		vif.drv_cb.arprot  <= req.arprot;
    		vif.drv_cb.arvalid <= 1;
    		do
       			@(vif.drv_cb);
    		while(!vif.drv_cb.arready);
    		vif.drv_cb.arvalid <= 0;
	endtask	

	task write_response();
		vif.drv_cb.bready <= 1;
		do
			@(vif.drv_cb);
		while(!vif.drv_cb.bvalid);
		vif.drv_cb.bready <= 0;
	endtask

	task read_response();
		vif.drv_cb.rready <= 1;
		do 
			@(vif.drv_cb);
		while(!vif.drv_cb.rvalid);
		vif.drv_cb.rready <= 0;
	endtask
	
	task drive();
		@(vif.drv_cb);
		if(req.op == axi_seq_item::WRITE)begin
			fork
				drive_valid_awaddr();
				drive_valid_wdata();
			join
			write_response();
		end 
		else if(req.op == axi_seq_item::READ)begin
			drive_valid_araddr();
			read_response();	
		end
	endtask

	task run_phase(uvm_phase phase);
		forever begin 
			seq_item_port.get_next_item(req);
			drive();
			$display("-------------------------------------------------------------------");
     			`uvm_info("[DRV]",$sformatf("awaddr=%0h awvalid=%0b wdata=%0h wstrb=%0b wvalid=%0b bready=%0b araddr=%0h arvalid=%0b rready=%0b ",req.awaddr, req.awvalid, req.wdata, req.wstrb, req.wvalid, req.bready, req.araddr, req.arvalid, req.rready), UVM_LOW )  
			seq_item_port.item_done();
		end
	endtask
endclass

