`timescale 1ns / 1ps

module hamming_encoder
#(
    parameter                               NB_WORD     = 4     ,
    parameter                               NB_CODEWORD = 7     
)(
    output  logic   [NB_CODEWORD    -1:0]   o_codeword          ,
    output  logic                           o_valid             ,
    input   logic   [NB_WORD        -1:0]   i_word              ,
    input   logic                           i_valid             
);
    // LOCALPARAM/VARIABLES
    logic [NB_CODEWORD              -1:0]   v_data  ;
    logic [0:NB_WORD                -1  ]   u_data  ;
    logic [0:NB_CODEWORD-NB_WORD    -1  ]   parity  ;

    // BIT INDEX RENAME
    // u_data == [u0 u1 u2 u3] == [w3 w2 w1 w0]
    assign u_data = i_word;

    //     | 1 0 0 0 1 1 0 |
    // G = | 0 1 0 0 0 1 1 |
    //     | 0 0 1 0 1 1 1 |
    //     | 0 0 0 1 1 0 1 |

    // v (message) = u (info) * G (generator matrix)
    // v    = [u0 u1 u2 u3 ; p0 p1 p2]
    // p0   = u0 + u2 + u3
    // p1   = u0 + u1 + u2
    // p2   = u1 + u2 + u3
    always_comb begin
        parity  = '0    ;
        v_data  = '0    ;
        
        if (i_valid) begin
            parity[0]   = u_data[0] ^ u_data[2] ^ u_data[3] ;
            parity[1]   = u_data[0] ^ u_data[1] ^ u_data[2] ;
            parity[2]   = u_data[1] ^ u_data[2] ^ u_data[3] ;
            // v_data == [v0 v1 v2 v3 v4 v5 v6] == [u0 u1 u2 u3 | p0 p1 p2]
            v_data      = {u_data, parity}                  ;
        end
    end

    // OUTPUT ASSIGNATION
    assign  o_codeword  = v_data    ;
    assign  o_valid     = i_valid   ;

endmodule