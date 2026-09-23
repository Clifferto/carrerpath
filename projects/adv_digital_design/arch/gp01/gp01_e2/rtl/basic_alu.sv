`timescale 1ns / 1ps

module basic_alu
#(
    parameter                           NB_DATA     = 16 ,
    parameter                           NB_SEL      = 2 
)(
    output  logic   [NB_DATA    -1:0]   o_dataC          ,
    input   logic   [NB_DATA    -1:0]   i_dataA         ,
    input   logic   [NB_DATA    -1:0]   i_dataB         ,
    input   logic   [NB_SEL     -1:0]   i_sel           
);
    // LOCALPARAM/VARIABLES
    logic       [NB_DATA    -1:0]   dataC        ;

    always_comb begin
        case (i_sel)
            'd0 : dataC = $signed(i_dataA) + $signed(i_dataB)   ;
            'd1 : dataC = $signed(i_dataA) - $signed(i_dataB)   ;
            'd2 : dataC = i_dataA & i_dataB                     ;
            'd3 : dataC = i_dataA | i_dataB                     ;
        endcase
    end

    // OUTPUT ASSIGNATION
    assign  o_dataC = dataC ;

endmodule
