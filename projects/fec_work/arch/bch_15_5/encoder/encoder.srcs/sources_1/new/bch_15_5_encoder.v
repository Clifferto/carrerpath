`timescale 1ns / 1ps

module bch_15_5_encoder
#(
    parameter   NB_WORD = 5 ,
    parameter   NB_CODEWORD = 15 
)(
    output  logic   [NB_CODEWORD    -1:0]   o_codeword  ,
    input   logic   [NB_WORD        -1:0]   i_word      ,
    input   logic                           i_reset     ,
    input   logic                           i_clock     
);

    bch_15_5_lfsr #(
        .NB_PARITY ( 10 ))
    u_lfsr (
        .i_bit      ( i_word[NB_WORD-1]      ),
        .i_reset    ( i_reset        ),
        .i_clock    ( i_clock       ),
        .o_parity   ( o_codeword   )
    );

endmodule
