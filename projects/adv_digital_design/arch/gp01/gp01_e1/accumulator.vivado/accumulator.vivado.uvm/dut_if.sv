interface dut_if#()
(
    input logic i_clock
);
    logic   [tb_pkg::NB_DATA*2  -1:0]   o_data      ;
    logic                               o_overflow  ;
    logic   [tb_pkg::NB_DATA    -1:0]   i_data1     ;
    logic   [tb_pkg::NB_DATA    -1:0]   i_data2     ;
    logic   [tb_pkg::NB_SEL     -1:0]   i_sel       ;
    logic                               i_reset_n   ;

endinterface