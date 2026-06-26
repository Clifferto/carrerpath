interface dut_if#()
(
    input   logic   i_clock
);

    logic   [comb_arch_pkg::NB_DATA                                 -1:0]   o_data      ;
    logic   [comb_arch_pkg::NB_FLAGS                                -1:0]   o_flags     ;
    logic   [comb_arch_pkg::NB_DATA*comb_arch_pkg::N_DATA_INPUTS    -1:0]   i_a_data    ;
    logic   [comb_arch_pkg::NB_DATA*comb_arch_pkg::N_DATA_INPUTS    -1:0]   i_b_data    ;
    logic   [comb_arch_pkg::N_DATA_INPUTS                           -1:0]   i_incode    ;
    logic   [comb_arch_pkg::NB_OPCODE                               -1:0]   i_opcode    ;

endinterface