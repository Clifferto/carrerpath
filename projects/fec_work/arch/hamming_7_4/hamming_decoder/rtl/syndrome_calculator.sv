`timescale 1ns / 1ps

module syndrome_calculator
#(
    parameter                                       NB_WORD             = 4 ,
    parameter                                       NB_CODEWORD         = 7 
)(
    output  logic   [NB_CODEWORD-NB_WORD    -1:0]   o_syndrome              ,
    output  logic                                   o_no_error_detected     ,
    output  logic                                   o_valid                 ,
    input   logic   [NB_CODEWORD            -1:0]   i_data                  ,
    input   logic                                   i_valid                 
);
    // LOCALPARAM/VARIABLES
    logic [0:NB_CODEWORD            -1  ]   r_data      ;
    logic [0:NB_CODEWORD-NB_WORD    -1  ]   syndrome    ;

    // BIT INDEX RENAME
    // r_data == [r0 r1 r2 r3 r4 r5 r6] == [d6 d5 d4 d3 d2 d1 d0]
    assign r_data = i_data;

    //      | 1 0 1 1 1 0 0 |
    // H =  | 1 1 1 0 0 1 0 |
    //      | 0 1 1 1 0 0 1 |
    // 
    //         | 1 1 0 |
    //         | 0 1 1 |
    //         | 1 1 1 |
    // H^T =   | 1 0 1 |
    //         | 1 0 0 |
    //         | 0 1 0 |
    //         | 0 0 1 |
    // 
    // s (syndrome) = r (received) * HT (parity check matrix)
    // s    = [s0 s1 s2]
    // s0   = r0 + r2 + r3 + r4
    // s1   = r0 + r1 + r2 + r5
    // s2   = r1 + r2 + r3 + r6
    always_comb begin
        syndrome = '0;
        
        if (i_valid) begin
            syndrome[0] = r_data[0] ^ r_data[2] ^ r_data[3] ^ r_data[4] ;
            syndrome[1] = r_data[0] ^ r_data[1] ^ r_data[2] ^ r_data[5] ;
            syndrome[2] = r_data[1] ^ r_data[2] ^ r_data[3] ^ r_data[6] ;
        end
    end

    // OUTPUT ASSIGNATION
    assign  o_syndrome          = syndrome      ;
    assign  o_no_error_detected = ~|syndrome    ;
    assign  o_valid             = i_valid       ;

endmodule
