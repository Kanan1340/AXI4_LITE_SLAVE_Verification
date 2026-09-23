
/////////////	scoreboard  ////////////
class axi_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(axi_scoreboard)

    uvm_tlm_analysis_fifo #(axi_seq_item) req_fifo;
    uvm_tlm_analysis_fifo #(axi_seq_item) rsp_fifo;

    axi_seq_item wr_q[$];
    axi_seq_item rd_q[$];

    bit [`DW-1:0] mem [0:`MEM_DEPTH-1];

    int match;
    int mismatch;

    function new(string name = "axi_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req_fifo = new("req_fifo", this);
        rsp_fifo = new("rsp_fifo", this);
        foreach (mem[i])
            mem[i] = '0;
    endfunction

    task run_phase(uvm_phase phase);
        fork
            get_req();
            check_rsp();
        join
    endtask

    task get_req();
        axi_seq_item tr;
        forever begin
            req_fifo.get(tr);
            if (tr.op == axi_seq_item::WRITE)
                wr_q.push_back(tr);
            else
                rd_q.push_back(tr);
        end
    endtask

    task check_rsp();
        axi_seq_item req;
        axi_seq_item rsp;
        forever begin
            rsp_fifo.get(rsp);
            if (rsp.op == axi_seq_item::WRITE) begin
                wait(wr_q.size() > 0);
                req = wr_q.pop_front();
                check_write(req, rsp);
            end
            else begin
                wait(rd_q.size() > 0);
                req = rd_q.pop_front();
                check_read(req, rsp);
            end
        end
    endtask

    function void check_write(axi_seq_item req, axi_seq_item rsp);
        int idx;
        bit [1:0] exp_resp;

        idx = req.awaddr >> 2;
        if (req.awaddr[1:0] != 2'b00)
            exp_resp = 2'b10;
        else if (idx >= `MEM_DEPTH)
            exp_resp = 2'b11;
        else if (idx >= 10 && idx <= 12)
            exp_resp = 2'b10;
        else
            exp_resp = 2'b00;

        if (rsp.bresp !== exp_resp) begin
            mismatch++;
            `uvm_error("[SB]", $sformatf("WRITE RESP MISMATCH addr=%h exp=%b act=%b", req.awaddr, exp_resp, rsp.bresp))
        end
        else begin
            match++;
        end

        if (exp_resp == 2'b00) begin
            if (req.wstrb[0])
                mem[idx][7:0] = req.wdata[7:0];
            if (req.wstrb[1])
                mem[idx][15:8] = req.wdata[15:8];
            if (req.wstrb[2])
                mem[idx][23:16] = req.wdata[23:16];
            if (req.wstrb[3])
                mem[idx][31:24] = req.wdata[31:24];
        end
    endfunction

    function void check_read(axi_seq_item req, axi_seq_item rsp);
        int idx;
        bit [1:0] exp_resp;
        bit [`DW-1:0] exp_data;

        idx = req.araddr >> 2;
        exp_data = '0;

        if (req.araddr[1:0] != 2'b00)
            exp_resp = 2'b10;
        else if (idx >= `MEM_DEPTH)
            exp_resp = 2'b11;
        else if (idx >= 13 && idx <= 14)
            exp_resp = 2'b10;
        else begin
            exp_resp = 2'b00;
            exp_data = mem[idx];
        end

        if (rsp.rresp !== exp_resp) begin
            mismatch++;
            `uvm_error("[SB]", $sformatf("READ RESP MISMATCH addr=%h exp=%b act=%b", req.araddr, exp_resp, rsp.rresp))
        end
        else if (rsp.rdata !== exp_data) begin
            mismatch++;
            `uvm_error("[SB]", $sformatf("READ DATA MISMATCH addr=%h exp=%h act=%h", req.araddr, exp_data, rsp.rdata))
        end
        else begin
            match++;
        end
    endfunction
endclass
