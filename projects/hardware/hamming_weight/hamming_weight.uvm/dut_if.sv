interface dut_if#()
(
    input   logic   i_clock
);

    logic   [tb_pkg::NB_CODEWORD    -1:0]   i_codeword  ;
    logic   [tb_pkg::NB_WEIGHT      -1:0]   o_weight    ;

endinterface