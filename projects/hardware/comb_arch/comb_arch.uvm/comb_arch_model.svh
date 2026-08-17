class comb_arch_model#(NB_DATA, N_DATA_INPUTS, NB_OPCODE, NB_FLAGS) extends uvm_object;
    `uvm_object_param_utils(comb_arch_model#(NB_DATA, N_DATA_INPUTS, NB_OPCODE, NB_FLAGS))

    function new(string name="comb_arch_model");
        super.new(name);
        lzoc_model  = lzoc_model_t::type_id::create("lzoc_model");
        pe_model    = pe_model_t::type_id::create("pe_model");
        alu_model   = alu1_model_t::type_id::create("alu1_model");
    endfunction

    lzoc_model_t    lzoc_model;
    pe_model_t      pe_model;
    alu1_model_t    alu_model;

    function void get_output(
        bit [NB_DATA-1:0] input_a_data [N_DATA_INPUTS]  ,
        bit [NB_DATA-1:0] input_b_data [N_DATA_INPUTS]  ,
        bit [N_DATA_INPUTS-1:0] incode                  ,
        bit [NB_OPCODE-1:0] opcode                      ,
        ref bit [NB_DATA-1:0] output_data               ,
        ref bit [NB_FLAGS-1:0] flags
    );
        bit [LZOC__NB_COUNT-1:0]    mux_a_data_sel;
        bit [LZOC__NB_COUNT-1:0]    mux_b_data_sel;
        bit [ALU1__NB_OPCODE-1:0]   alu_opcode;
        bit [NB_DATA-1:0]           alu_data [2];
        bit                         pe_valid;
        
        // incode ones count selects input for A operand, leading zeros selects input for B operand
        lzoc_model.get_output(incode, mux_b_data_sel, mux_a_data_sel);

        // select A and B from input data mux
        alu_data[0]    = input_a_data[mux_a_data_sel];
        alu_data[1]    = input_b_data[mux_b_data_sel];
        
        // opcode MSb high selects alu opcode
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
