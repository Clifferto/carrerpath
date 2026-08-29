`timescale 1ns / 1ps

module decoder_corrector
#(
    parameter                                       NB_WORD         = 4 ,
    parameter                                       NB_CODEWORD     = 7 
)(
    output  logic   [NB_WORD                -1:0]   o_data              ,
    output  logic                                   o_corrected         ,
    output  logic                                   o_valid             ,
    input   logic   [NB_CODEWORD-NB_WORD    -1:0]   i_syndrome          ,
    input   logic   [NB_WORD                -1:0]   i_data              ,
    input   logic                                   i_no_error_detected ,
    input   logic                                   i_valid             
);
    // LOCALPARAM/VARIABLES
    logic [NB_WORD  -1:0]   error_pattern   ;
    logic [NB_WORD  -1:0]   u_data          ;
    logic                   corrected       ;

    //         | 1 1 0 |
    //         | 0 1 1 |
    //         | 1 1 1 |
    // H^T =   | 1 0 1 |
    //         | 1 0 0 |
    //         | 0 1 0 |
    //         | 0 0 1 |
    // ROW_i{H^T}           = s (syndrome)
    // e (error pattern)    = i
    // v                    = r + e
    // v    = [u | p]
    always_comb begin
        case (i_syndrome)
            'b110:  error_pattern   = 1<<3 ;
            'b011:  error_pattern   = 1<<2 ;
            'b111:  error_pattern   = 1<<1 ;
            'b101:  error_pattern   = 1<<0 ;
            // do not correct parity errors
            default: begin
                error_pattern   = 'b0 ;
            end
        endcase
    end

    always_comb begin
        u_data      = 'b0;
        corrected   = 1'b0;

        if (i_valid) begin
            u_data  = i_data;

            if (!i_no_error_detected) begin
                u_data      ^= error_pattern;
                corrected   = 1'b1;
            end
        end
    end

    // OUTPUT ASSIGNATION
    assign  o_data      = u_data    ;
    assign  o_corrected = corrected ;
    assign  o_valid     = i_valid   ;

endmodule
