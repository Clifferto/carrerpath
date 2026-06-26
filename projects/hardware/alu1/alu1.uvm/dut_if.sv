interface dut_if#()
(
    input   logic   i_clock
);

    logic   [alu1_pkg::NB_DATA    -1:0]   o_data      ;
    logic   [alu1_pkg::NB_FLAGS   -1:0]   o_flags     ;
    logic   [alu1_pkg::NB_DATA*2  -1:0]   i_data      ;
    logic   [alu1_pkg::NB_OPCODE  -1:0]   i_opcode    ;

endinterface