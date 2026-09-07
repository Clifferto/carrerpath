`timescale 1ns / 1ps

module arty_tron
#(
    parameter                           NB_LED      = 4     ,
    parameter                           NB_SWITCH   = 4     ,
    parameter                           NB_COUNTER  = 12    
)(
    output  logic   [NB_LED     -1:0]   o_led               ,
    output  logic   [NB_LED     -1:0]   o_led_g             ,
    output  logic   [NB_LED     -1:0]   o_led_b             ,
    input   logic   [NB_SWITCH  -1:0]   i_switch            ,
    input   logic                       i_reset             ,
    input   logic                       i_clock         
);
    // LOCALPARAM/VARIABLES
    logic                       counter_valid       ;
    logic   [NB_LED     -1:0]   shift_register_led  ;
    logic   [NB_LED     -1:0]   led_g               ;
    logic   [NB_LED     -1:0]   led_b               ;
    logic   [NB_SWITCH  -1:0]   main_switch         ;
    logic   [NB_SWITCH  -1:0]   vio_switch          ;
    logic                       vio_control         ;
    logic                       vio_reset           ;
    logic                       main_reset          ;

    assign main_reset   = (vio_control) ? ~vio_reset : ~i_reset ;
    assign main_switch  = (vio_control) ? vio_switch : i_switch ;

    counter # (
        .NB_SWITCH  ( NB_SWITCH-1                   ),
        .NB_COUNTER ( NB_COUNTER                    )
    )
    counter_inst (
        .o_valid    ( counter_valid                 ),
        .i_switch   ( i_switch[NB_SWITCH-1  -1:0]   ),
        .i_reset    ( main_reset                    ),
        .i_clock    ( i_clock                       )
    );

    shift_register # (
        .NB_LED     ( NB_LED                )
    )
    shift_register_inst (
        .o_led      ( shift_register_led    ),
        .i_valid    ( counter_valid         ),
        .i_reset    ( main_reset            ),
        .i_clock    ( i_clock               )
    );
    
    assign led_g    = (i_switch[NB_SWITCH-1]) ? '0                  : shift_register_led    ;
    assign led_b    = (i_switch[NB_SWITCH-1]) ? shift_register_led  : '0                    ;
    
    // OUTPUT ASSIGNATION
    assign  o_led   = shift_register_led    ;
    assign  o_led_g = led_g                 ;
    assign  o_led_b = led_b                 ;
    
    // ===========================================================================================
    // UTILITY INSTANCES
    design_2  ila_inst (
        .clk_0              ( i_clock               ),
        .probe0_0           ( shift_register_led    ),
        .probe1_0           ( led_g                 ),
        .probe2_0           ( led_b                 )
    );

    design_1  vio_inst (
        .clk_0              ( i_clock               ),
        .probe_in0_led      ( shift_register_led    ),
        .probe_in1_led_g    ( led_g                 ),
        .probe_in2_led_b    ( led_b                 ),
        .probe_out0_control ( vio_control           ),
        .probe_out1_reset   ( vio_reset             ),
        .probe_out2_switch  ( vio_switch            )
    );

endmodule
