`timescale 1ns / 1ps

module ones_counter
#(
    parameter                           NB_DATA         = 32    ,
    parameter                           NB_COUNT        = 32    
)(
    output  reg     [NB_COUNT   -1:0]   o_ones_count            ,
    input   wire    [NB_DATA    -1:0]   i_data                  
);
    // SIGNALS/VARIABLES
    reg     [NB_COUNT   -1:0]   ones_count  ;
    integer                     ii          ;

    always @(*) begin
        o_ones_count    = {NB_COUNT{1'b0}}  ;
        ones_count      = {NB_COUNT{1'b0}}  ;

        for (ii=0; ii<NB_DATA; ii=ii+1) begin
            ones_count  = ones_count + i_data[NB_DATA-ii-1] ;
        end

        o_ones_count    = ones_count    ;
    end

endmodule
