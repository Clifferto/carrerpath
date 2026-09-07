interface dut_if#()
(
    input logic i_clock
);
    logic   [tb_pkg::NB_LED     -1:0]   o_led       ;
    logic   [tb_pkg::NB_LED     -1:0]   o_led_g     ;
    logic   [tb_pkg::NB_LED     -1:0]   o_led_b     ;
    logic   [tb_pkg::NB_SWITCH  -1:0]   i_switch    ;
    logic                               i_reset     ;

endinterface