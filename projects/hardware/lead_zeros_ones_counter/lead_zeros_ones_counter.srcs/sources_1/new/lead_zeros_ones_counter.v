`timescale 1ns / 1ps

module lead_zeros_ones_counter
#(
    parameter                                   NB_DATA             = 4
)(
    output  wire    [$clog2(NB_DATA+1)  -1:0]   o_ones_count                ,
    output  wire    [$clog2(NB_DATA+1)  -1:0]   o_lead_zeros_count          ,
    input   wire    [NB_DATA            -1:0]   i_data                      
);
    // SIGNALS/VARIABLES
    localparam                  NB_COUNT            = $clog2(NB_DATA+1) ;
    wire     [NB_COUNT  -1:0]   ones_count                              ;
    wire     [NB_COUNT  -1:0]   lead_zeros_count                        ;

    // INSTANCES
    ones_counter #(
        .NB_DATA        ( NB_DATA       ),
        .NB_COUNT       ( NB_COUNT      )
    )
    u_ones_counter (
        .i_data         ( i_data        ),
        .o_ones_count   ( ones_count    )
    );

    lead_zeros_counter #(
        .NB_DATA            ( NB_DATA           ),
        .NB_COUNT           ( NB_COUNT          )
    )
    u_lead_zeros_counter (
        .i_data             ( i_data            ),
        .o_lead_zeros_count ( lead_zeros_count  )
    );

    // OUTPUT ASSIGNATION
    assign o_ones_count         = ones_count        ;
    assign o_lead_zeros_count   = lead_zeros_count  ;

endmodule
