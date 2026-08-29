`timescale 1ns / 1ps

module arty_tron
#(
    parameter                           NB_LED      = 4 ,
    parameter                           NB_SWITCH   = 4 
)(
    output  logic   [NB_LED     -1:0]   o_led           ,
    output  logic   [NB_LED     -1:0]   o_led_g         ,
    output  logic   [NB_LED     -1:0]   o_led_b         ,
    input   logic   [NB_SWITCH  -1:0]   i_switch        ,
    input   logic                       i_reset         ,
    input   logic                       i_clock         
);
    // LOCALPARAM/VARIABLES
    

    counter # (
        .NB_SWITCH  ( NB_SWITCH )
    )
    counter_inst (
        .o_valid    ( o_valid   ),
        .i_switch   ( i_switch[2:0] ),
        .i_reset    ( i_reset   ),
        .i_clock    ( i_clock   )
    );

    shift_register # (
        .NB_LED     ( NB_LED    )
    )
    shift_register_inst (
        .o_led      ( o_led     ),
        .i_valid    ( i_valid   ),
        .i_reset    ( i_reset   ),
        .i_clock    ( i_clock   )
    );

    // OUTPUT ASSIGNATION
    assign  o_syndrome          = syndrome      ;
    assign  o_no_error_detected = ~|syndrome    ;
    assign  o_valid             = i_valid       ;

endmodule
