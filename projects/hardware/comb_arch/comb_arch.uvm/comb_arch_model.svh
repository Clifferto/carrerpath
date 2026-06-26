`include "../../alu1/alu1.uvm/alu1_model.svh"
`include "../../lead_zeros_ones_counter/lead_zeros_ones_counter.uvm/lead_zeros_ones_counter_model.svh"
`include "../../priority_encoder/priority_encoder.uvm/priority_encoder_model.svh"

class comb_arch_model extends uvm_object;
    `uvm_object_utils(comb_arch_model)

    // Only to define the N_DATA_INPUTS, not for model
    lzoc_data_t x;

    localparam N_DATA_INPUTS = $bits(x);

    function new(string name="comb_arch_model");
        super.new(name);
        lzoc_model  = lead_zeros_ones_counter_model::type_id::create("lzoc_model");
        pe_model    = priority_encoder_model::type_id::create("pe_model");
        alu_model   = alu1_model::type_id::create("alu1_model");
    endfunction

    lead_zeros_ones_counter_model   lzoc_model;
    priority_encoder_model          pe_model;
    alu1_model                      alu_model;

    function void get_output(alu1_data_t input_a_data [N_DATA_INPUTS], alu1_data_t input_b_data [N_DATA_INPUTS], lzoc_data_t incode, pe_request_t opcode, ref alu1_data_t output_data, ref alu1_flags_t flags);
        lzoc_count_t    mux_a_data_sel;
        lzoc_count_t    mux_b_data_sel;
        alu1_opcode_t   alu_opcode;
        alu1_data_t     alu_data [0:1];
        bit             pe_valid;
        
        // incode ones count selects input for A operand, leading zeros selects input for B operand
        lzoc_model.get_output(incode, mux_b_data_sel, mux_a_data_sel);

        // select A and B from input data mux
        alu_data[0]    = input_a_data[mux_a_data_sel];
        alu_data[1]    = input_b_data[mux_b_data_sel];
        
        // opcode MSb position selects alu opcode
        pe_model.get_output(opcode, alu_opcode, pe_valid);
        if (pe_valid == 0) begin
            alu_opcode = 'hFF;
        end

        `uvm_info(get_name(), $sformatf(   "opcode = %0d | mux_a_data_sel = %0d, A = %0d (%0b) | mux_b_data_sel = %0d, B = %0d (%0b)"   ,
                                            alu_opcode                                                                                  ,
                                            mux_a_data_sel, alu_data[0], alu_data[0]                                                    ,
                                            mux_b_data_sel, alu_data[1], alu_data[1]                                                    ), UVM_NONE)

        // alu gives result and flags
        alu_model.get_output(alu_data, alu_opcode, output_data, flags);

        `uvm_info(get_name(), $sformatf("flags = %0b", flags), UVM_NONE)
    endfunction

endclass
