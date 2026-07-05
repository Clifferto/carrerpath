interface dut_if#()
(
    input   logic   i_clock
);

    logic   [tb_pkg::NB_METRIC      -1:0]   o_metric        ;
    logic                                   o_valid         ;
    logic   [tb_pkg::NB_CODEWORD    -1:0]   i_codeword_0    ;
    logic   [tb_pkg::NB_CODEWORD    -1:0]   i_codeword_1    ;
    logic                                   i_valid         ;

endinterface