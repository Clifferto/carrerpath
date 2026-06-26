`timescale 1ns / 1ps

module comb_arch
#(
    parameter                       N_DATA_INPUTS   = 4             ,
    parameter                       NB_DATA         = 8             ,
    parameter                       NB_FLAGS        = 4             ,
    parameter                       NB_OPCODE       = 4             
)(
    output  wire [NB_DATA               -1:0]   o_data  ,
    output  wire [NB_FLAGS              -1:0]   o_flags  ,
    input   wire [NB_DATA*N_DATA_INPUTS -1:0]   i_a_data  ,
    input   wire [NB_DATA*N_DATA_INPUTS -1:0]   i_b_data  ,
    input   wire [N_DATA_INPUTS         -1:0]   i_incode  ,
    input   wire [NB_OPCODE             -1:0]   i_opcode  
);

    assign o_data = i_a_data;

endmodule
