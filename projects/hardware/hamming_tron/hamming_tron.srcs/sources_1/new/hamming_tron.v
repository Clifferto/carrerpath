`timescale 1ns / 1ps

module hamming_tron
#(
    parameter                                       NB_CODEWORD     = 8 
)(
    output  wire    [$clog2(NB_CODEWORD+1)  -1:0]   o_metric            ,
    output  wire    [$clog2(NB_CODEWORD+1)  -1:0]   o_weight_0          ,
    output  wire    [$clog2(NB_CODEWORD+1)  -1:0]   o_weight_1          ,
    output  wire                                    o_valid             ,
    input   wire    [NB_CODEWORD*2          -1:0]   i_codeword          ,
    input   wire                                    i_valid             
);
    // SIGNALS/VARIABLES
    localparam                      NB_METRIC   = $clog2(NB_CODEWORD+1) ;
    localparam                      NB_WEIGHT   = NB_METRIC             ;
    wire        [NB_WEIGHT  -1:0]   weight_1                            ;
    wire        [NB_WEIGHT  -1:0]   weight_0                            ;
    wire        [NB_METRIC  -1:0]   metric                              ;
    
    hamming_weight #(
        .NB_CODEWORD    ( NB_CODEWORD                                   ))
    u_weight_1(
        .i_codeword     ( i_codeword[NB_CODEWORD*2  -1-:NB_CODEWORD]    ),
        .i_valid        ( i_valid                                       ),
        .o_weight       ( weight_1                                      ),
        .o_valid        (                                               )
    );

    hamming_weight #(
        .NB_CODEWORD    ( NB_CODEWORD                                   ))
    u_weight_0(
        .i_codeword     ( i_codeword[NB_CODEWORD    -1-:NB_CODEWORD]    ),
        .i_valid        ( i_valid                                       ),
        .o_weight       ( weight_0                                      ),
        .o_valid        (                                               )
    );

    hamming_metric #(
        .NB_CODEWORD    ( NB_CODEWORD                                   ))
    u_metric
    (
        .i_codeword_0   ( i_codeword[NB_CODEWORD    -1-:NB_CODEWORD]    ),
        .i_codeword_1   ( i_codeword[NB_CODEWORD*2  -1-:NB_CODEWORD]    ),
        .i_valid        ( i_valid                                       ),
        .o_metric       ( metric                                        ),
        .o_valid        (                                               )
    );

    // OUTPUT ASSIGNS
    assign  o_metric    = metric    ;
    assign  o_weight_0  = weight_0  ;
    assign  o_weight_1  = weight_1  ;
    assign  o_valid     = i_valid   ;

endmodule
