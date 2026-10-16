`timescale 1ns / 1ps

module accumulator
#(
    parameter                           NB_DATA     = 3 ,
    parameter                           NB_RESULT   = 6 ,
    parameter                           NB_SEL      = 2 
)(
    output  logic   [NB_RESULT  -1:0]   o_data          ,
    output  logic                       o_overflow      ,
    input   logic   [NB_DATA    -1:0]   i_data1         ,
    input   logic   [NB_DATA    -1:0]   i_data2         ,
    input   logic   [NB_SEL     -1:0]   i_sel           ,
    input   logic                       i_reset_n       ,
    input   logic                       i_clock         
);
    // LOCALPARAM/VARIABLES
    logic       [NB_DATA+1      -1:0]   mux_data                    ;
    logic       [NB_RESULT+1    -1:0]   sum                         ;
    logic       [NB_RESULT      -1:0]   result                      ;
    logic                               overflow                    ;

    always_comb begin
        case (i_sel)
            'd0    : mux_data = {1'b0, i_data2}     ;
            'd1    : mux_data = i_data1 + i_data2   ;
            'd2    : mux_data = {1'b0, i_data1}     ;
            default begin
                mux_data = '0;
            end
        endcase
    end
    
    // align bits before sum
    assign sum  = {{NB_DATA+1 - NB_RESULT{'b0}}, mux_data} + result;

    always_ff @(posedge i_clock or negedge i_reset_n) begin
        if (!i_reset_n) begin
            result   <= '0;
        end
        else begin
            result   <= sum[NB_RESULT-1:0];
        end
    end

    // OUTPUT ASSIGNATION
    assign  o_data      = result            ;
    assign  o_overflow  = sum[NB_RESULT]    ;

endmodule
