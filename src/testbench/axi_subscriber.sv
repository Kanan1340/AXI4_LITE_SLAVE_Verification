
///////////  subscriber	 ///////////////
class axi_cov extends uvm_subscriber #(axi_seq_item);

    `uvm_component_utils(axi_cov)

    axi_seq_item tx;

    covergroup cg;
        option.per_instance = 1;

        OP: coverpoint tx.op {
            bins write = {axi_seq_item::WRITE};
            bins read  = {axi_seq_item::READ};
        }

        AWADDR: coverpoint tx.awaddr {
            bins valid = {[32'h00:32'h24]};
            bins last  = {32'h3C};
            bins ro   = {[32'h28:32'h30]};
            bins other = default;
        }

        ARADDR: coverpoint tx.araddr {
            bins valid = {[32'h00:32'h24]};
            bins last  = {32'h3C};
            bins wo   = {[32'h34:32'h38]};
            bins other = default;
        }

        WSTRB: coverpoint tx.wstrb {
            bins strb0 = {4'b0001};
            bins strb1 = {4'b0010};
            bins strb2 = {4'b0100};
            bins strb3 = {4'b1000};
            bins all   = {4'b1111};
        }

        BRESP: coverpoint tx.bresp {
            bins okay   = {2'b00};
            bins exokay = {2'b01};
            bins slverr = {2'b10};
            bins decerr = {2'b11};
        }

        RRESP: coverpoint tx.rresp {
            bins okay   = {2'b00};
            bins exokay = {2'b01};
            bins slverr = {2'b10};
            bins decerr = {2'b11};
        }

        OP_WSTRB: cross OP, WSTRB;
        OP_BRESP: cross OP, BRESP;
        OP_RRESP: cross OP, RRESP;

    endgroup

    function new(string name="axi_cov", uvm_component parent);
        super.new(name,parent);
        cg = new();
    endfunction

    function void write(axi_seq_item t);
        tx = t;
        cg.sample();
    endfunction

endclass

