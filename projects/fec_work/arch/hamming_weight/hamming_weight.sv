`timescale 1ns / 1ps

module hamming_weight
#(
    parameter                                       NB_CODEWORD = 7    
)(
    output  logic   [$clog2(NB_CODEWORD+1)  -1:0]   o_weight            ,
    output  logic                                   o_valid             ,
    input   logic   [NB_CODEWORD            -1:0]   i_codeword          ,
    input   logic                                   i_valid             
);
    // SIGNALS/VARIABLES
    localparam                      NB_WEIGHT   = $clog2(NB_CODEWORD+1) ;
    logic       [NB_WEIGHT  -1:0]   weight                              ;

    // ONES COUNTER LOGIC
    always_comb begin
        weight  = '0    ;
        
        for (int i=0; i<NB_CODEWORD; i++) begin
            weight  = weight + i_codeword[i]    ;
        end
    end

    // OUTPUT ASSIGNS
    assign  o_weight    = weight    ;
    assign  o_valid     = i_valid   ;

endmodule
