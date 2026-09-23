`timescale 1ns / 1ps

module accumulator
#(
    parameter                           NB_DATA     = 3 ,
    parameter                           NB_SEL      = 2 
)(
    output  logic   [NB_DATA*2  -1:0]   o_data          ,
    output  logic                       o_overflow      ,
    input   logic   [NB_DATA    -1:0]   i_data1         ,
    input   logic   [NB_DATA    -1:0]   i_data2         ,
    input   logic   [NB_SEL     -1:0]   i_sel           ,
    input   logic                       i_reset_n       ,
    input   logic                       i_clock         
);
    // LOCALPARAM/VARIABLES
    localparam                          NB_SUM      = 7 ;
    logic       [NB_DATA+1      -1:0]   mux_data        ;
    logic       [(NB_DATA*2)+1  -1:0]   sum             ;
    logic       [(NB_DATA*2)+1  -1:0]   sum_d           ;
    logic       [NB_DATA*2      -1:0]   out_data        ;
    logic                               overflow        ;

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
    
    assign sum  = mux_data + out_data;

    always_ff @(posedge i_clock or negedge i_reset_n) begin
        if (!i_reset_n) begin
            sum_d   <= '0;
        end
        else begin
            sum_d   <= sum;
        end
    end

    assign {overflow, out_data} = sum_d;

    // OUTPUT ASSIGNATION
    assign  o_data      = out_data  ;
    assign  o_overflow  = overflow  ;

endmodule
