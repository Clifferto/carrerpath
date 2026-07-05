`timescale 1ns / 1ps

module hamming_weight
#(
    parameter                                       NB_CODEWORD = 32    
)(
    output  wire    [$clog2(NB_CODEWORD+1)  -1:0]   o_weight            ,
    output  wire                                    o_valid             ,
    input   wire    [NB_CODEWORD            -1:0]   i_codeword          ,
    input   wire                                    i_valid             
);
    // SIGNALS/VARIABLES
    localparam                  NB_WEIGHT   = $clog2(NB_CODEWORD+1) ;
    reg     [NB_WEIGHT  -1:0]   weight                              ;
    integer                     ii                                  ;

    // ONES COUNTER LOGIC
    always @(*) begin
        weight      = {NB_WEIGHT{1'b0}} ;

        for (ii=0; ii<NB_CODEWORD; ii=ii+1) begin
            weight  = weight + i_codeword[ii]   ;
        end
    end

    // OUTPUT ASSIGNS
    assign  o_weight    = weight    ;
    assign  o_valid     = i_valid   ;

endmodule
