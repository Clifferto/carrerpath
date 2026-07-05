`timescale 1ns / 1ps

module hamming_metric
#(
    parameter                                       NB_CODEWORD     = 8     
)(
    output  wire    [$clog2(NB_CODEWORD+1)  -1:0]   o_metric                ,
    output  wire                                    o_valid                 ,
    input   wire    [NB_CODEWORD            -1:0]   i_codeword_0            ,
    input   wire    [NB_CODEWORD            -1:0]   i_codeword_1            ,
    input   wire                                    i_valid                 
);
    // SIGNALS/VARIABLES
    localparam                      NB_METRIC   = $clog2(NB_CODEWORD+1) ;
    reg         [NB_METRIC  -1:0]   metric                              ;
    integer                         ii                                  ;

    // DIFFERENCES COUNTER LOGIC
    always @(*) begin
        metric  = {NB_METRIC{1'b0}} ;

        for (ii=0; ii<NB_CODEWORD; ii=ii+1) begin
            metric  = metric + (i_codeword_0[ii] ^ i_codeword_1[ii])    ;
        end
    end

    // OUTPUT ASSIGNS
    assign  o_metric    = metric    ;
    assign  o_valid     = i_valid   ;

endmodule
