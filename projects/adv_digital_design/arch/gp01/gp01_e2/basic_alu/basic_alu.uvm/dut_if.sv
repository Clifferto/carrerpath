interface dut_if#()
(
    input   logic   i_clock
);
    logic   [tb_pkg::NB_DATA    -1:0]   o_dataC ;
    logic   [tb_pkg::NB_DATA    -1:0]   i_dataA ;
    logic   [tb_pkg::NB_DATA    -1:0]   i_dataB ;
    logic   [tb_pkg::NB_SEL     -1:0]   i_sel   ;

endinterface