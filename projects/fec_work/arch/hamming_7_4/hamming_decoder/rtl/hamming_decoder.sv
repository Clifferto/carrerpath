`timescale 1ns / 1ps

module hamming_decoder
#(
    parameter                               NB_WORD     = 4 ,
    parameter                               NB_CODEWORD = 7 
)(
    output  logic   [NB_WORD        -1:0]   o_data          ,
    output  logic                           o_corrected     ,
    output  logic                           o_valid         ,
    input   logic   [NB_CODEWORD    -1:0]   i_data          ,
    input   logic                           i_valid         ,
    input   logic                           i_reset         ,
    input   logic                           i_clock          
);
    // LOCALPARAM/VARIABLES
    logic   [NB_CODEWORD-NB_WORD    -1:0]   syndrome                        ;
    logic   [NB_WORD                -1:0]   decoder_corrector_data          ;
    logic   [NB_WORD                -1:0]   decoder_corrector_data_d        ;
    logic                                   no_error_detected               ;
    logic                                   syndrome_calculator_valid       ;
    logic                                   decoder_corrector_corrected     ;
    logic                                   decoder_corrector_corrected_d   ;
    logic                                   decoder_corrector_valid         ;
    logic                                   decoder_corrector_valid_d       ;

    syndrome_calculator # (
        .NB_WORD(NB_WORD),
        .NB_CODEWORD(NB_CODEWORD)
    )
    syndrome_calculator_inst (
        .o_syndrome(syndrome),
        .o_no_error_detected(no_error_detected),
        .o_valid(syndrome_calculator_valid),
        .i_data(i_data),
        .i_valid(i_valid)
    );

    decoder_corrector # (
        .NB_WORD(NB_WORD),
        .NB_CODEWORD(NB_CODEWORD)
    )
    decoder_corrector_inst (
        .o_data(decoder_corrector_data),
        .o_corrected(decoder_corrector_corrected),
        .o_valid(decoder_corrector_valid),
        .i_syndrome(syndrome),
        .i_data(i_data),
        .i_no_error_detected(no_error_detected),
        .i_valid(syndrome_calculator_valid),
        .i_reset(i_reset),
        .i_clock(i_clock)
    );

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            decoder_corrector_data_d        <= 'b0;
            decoder_corrector_corrected_d   <= 'b0;
        end
        else if (decoder_corrector_valid) begin
            decoder_corrector_data_d        <= decoder_corrector_data;
            decoder_corrector_corrected_d   <= decoder_corrector_corrected;
        end
    end

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            decoder_corrector_valid_d   <= 'b0;
        end
        else begin
            decoder_corrector_valid_d   <= decoder_corrector_valid;
        end
    end

    // OUTPUT ASSIGNATION
    assign o_data   = decoder_corrector_data_d;
    assign o_corrected   = decoder_corrector_corrected_d;
    assign o_valid   = decoder_corrector_valid_d;

endmodule
