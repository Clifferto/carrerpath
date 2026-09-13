`timescale 1ns / 1ps

module bch_15_5_encoder
#(
    parameter   NB_WORD = 5 ,
    parameter   NB_CODEWORD = 15 
)(
    output  logic   [NB_CODEWORD    -1:0]   o_codeword  ,
    output  logic                           o_valid     ,
    input   logic   [NB_WORD        -1:0]   i_word      ,
    input   logic                           i_valid     ,
    input   logic                           i_reset     ,
    input   logic                           i_clock     
);
    // LOCALPARAM AND SIGNAL DEFINITIONS
    logic                           control_load    ;
    logic                           control_flush    ;
    logic                           control_clear    ;
    logic       [NB_WORD    -1:0]   word_buffer     ;

    bch_15_5_control # (
        .NB_WORD    ( NB_WORD       )
    )
    control_inst (
        .o_load     ( control_load  ),
        .o_flush    ( control_flush ),
        .o_clear    ( control_clear ),
        .i_valid    ( i_valid       ),
        .i_reset    ( i_reset       ),
        .i_clock    ( i_clock       )
    );
    
    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            word_buffer <= '0;
        end
        else if (control_load) begin
            word_buffer <= i_word;
        end
        else if (control_flush) begin
            word_buffer <= {word_buffer[(NB_WORD-1)-1:0], 1'b0};
        end
    end

    localparam  NB_PARITY   = NB_CODEWORD-NB_WORD   ;
    logic                           lfsr_reset    ;
    logic       [NB_PARITY  -1:0]   lfsr_parity    ;

    assign lfsr_reset = i_reset | control_clear;

    bch_15_5_lfsr #(
        .NB_PARITY ( NB_PARITY ))
    lfsr_inst (
        .i_bit      ( word_buffer[NB_WORD-1]      ),
        .i_reset    ( lfsr_reset        ),
        .i_clock    ( i_clock       ),
        .o_parity   ( lfsr_parity   )
    );

    logic   [NB_CODEWORD    -1:0]   codeword;
    logic                           control_clear_d;

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            codeword    <= '0;
        end
        else if (control_clear) begin
            codeword    <= {i_word, lfsr_parity};
        end
    end

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            control_clear_d <= 0;
        end
        else begin
            control_clear_d <= control_clear;
        end
    end

    // OUTPUT PORT ASSIGNATION
    assign o_codeword   = codeword          ;
    assign o_valid      = control_clear_d   ;

endmodule
