interface dut_if#()
(
    input   logic   i_clock
);

    logic   [tb_pkg::NB_METRIC      -1:0]   o_metric    ;
    logic   [tb_pkg::NB_WEIGHT      -1:0]   o_weight_0  ;
    logic   [tb_pkg::NB_WEIGHT      -1:0]   o_weight_1  ;
    logic                                   o_valid     ;
    logic   [tb_pkg::NB_CODEWORD*2  -1:0]   i_codeword  ;
    logic                                   i_valid     ;

endinterface