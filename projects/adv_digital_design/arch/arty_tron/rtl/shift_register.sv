`timescale 1ns / 1ps

module shift_register
#(
    parameter                           NB_LED      = 4 
)(
    output  logic   [NB_LED     -1:0]   o_led           ,
    input   logic                       i_valid         ,
    input   logic                       i_reset         ,
    input   logic                       i_clock         
);
    // LOCALPARAM/VARIABLES
    logic [NB_LED   -1:0]   shift_reg       ;
    logic [NB_LED   -1:0]   shift_reg_next  ;

    assign shift_reg_next   = {shift_reg[NB_LED-1  -1:0], shift_reg[NB_LED-1]}  ;

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            shift_reg   <= 'b1              ;
        end
        else if (i_valid) begin
            shift_reg   <=  shift_reg_next  ;
        end
    end

    // OUTPUT ASSIGNATION
    assign o_led    = shift_reg ;

endmodule
