`timescale 1ns / 1ps

module alu1
#(
    parameter                           NB_DATA     = 32    ,
    parameter                           NB_OPCODE   = 4     ,
    parameter                           NB_FLAGS    = 4 
)(
    output  wire    [NB_DATA    -1:0]   o_data          ,
    output  wire    [NB_FLAGS   -1:0]   o_flags         ,
    input   wire    [NB_DATA*2  -1:0]   i_data          ,
    input   wire    [NB_OPCODE  -1:0]   i_opcode        
);
    // SIGNALS/VARIABLES
    localparam                  SIGN_BIT    = NB_DATA-1 ;
    wire    [NB_DATA    -1:0]   a_number                ;
    wire    [NB_DATA    -1:0]   b_number                ;
    wire                        sign_same               ;
    reg     [NB_DATA+1  -1:0]   result                  ;
    reg                         sign_flip               ;
    reg                         zero                    ;
    reg                         carry                   ;
    reg                         overflow                ;
    reg                         negative                ;

    assign  a_number    = i_data[NB_DATA    -1-:NB_DATA]            ;
    assign  b_number    = i_data[NB_DATA*2  -1-:NB_DATA]            ;
    assign  sign_same   = a_number[SIGN_BIT] == b_number[SIGN_BIT]  ;

    always@(*) begin
        // default/invalid opcode logic
        result      = {NB_DATA+1{1'b0}} ;
        sign_flip   = 1'b0              ;
        zero        = 1'b0              ;
        carry       = 1'b0              ;
        overflow    = 1'b0              ;
        negative    = 1'b0              ;
        
        case (i_opcode)
            // a_add_b operation logic
            0   :   begin
                result      = a_number + b_number                       ;
                sign_flip   = a_number[SIGN_BIT] != result[SIGN_BIT]    ;
                zero        = result[SIGN_BIT:0] == 0                   ;
                carry       = result[NB_DATA]                           ;
                overflow    = sign_same && sign_flip                    ;
                negative    = result[SIGN_BIT]                          ;
            end
            // a_sub_b operation logic
            1   :   begin
                result      = a_number - b_number                       ;
                sign_flip   = a_number[SIGN_BIT] != result[SIGN_BIT]    ;
                zero        = result[SIGN_BIT:0] == 0                   ;
                carry       = !result[NB_DATA]                          ;
                overflow    = !sign_same && sign_flip                   ;
                negative    = result[SIGN_BIT]                          ;
            end
            // a_and_b operation logic
            2   :   begin
                result      = a_number & b_number       ;
                zero        = result[SIGN_BIT:0] == 0   ;
                negative    = result[SIGN_BIT]          ;
            end
            // a_or_b operation logic
            3   :   begin
                result      = a_number | b_number       ;
                zero        = result[SIGN_BIT:0] == 0   ;
                negative    = result[SIGN_BIT]          ;
            end
            // a_xor_b operation logic
            4   :   begin
                result      = a_number ^ b_number       ;
                zero        = result[SIGN_BIT:0] == 0   ;
                negative    = result[SIGN_BIT]          ;
            end
            // a_not operation logic
            5   :   begin
                result      = ~a_number                 ;
                zero        = result[SIGN_BIT:0] == 0   ;
                negative    = result[SIGN_BIT]          ;
            end
            // a_lls_b operation logic
            6   :   begin
                result      = a_number << b_number      ;
                zero        = result[SIGN_BIT:0] == 0   ;
                negative    = result[SIGN_BIT]          ;
            end
            // a_lrs_b operation logic
            7   :   begin
                result      = a_number >> b_number      ;
                zero        = result[SIGN_BIT:0] == 0   ;
                negative    = result[SIGN_BIT]          ;
            end
            // a_slt_b operation logic
            8   :   begin
                if (sign_same) begin
                    result  = a_number[SIGN_BIT-1:0] < b_number[SIGN_BIT-1:0]   ;
                end
                else begin
                    result  = a_number[SIGN_BIT]                                ;
                end
                zero    = result[SIGN_BIT:0] == 0   ;
            end
            // a_ult_b operation logic
            9   :   begin
                result  = a_number < b_number       ;
                zero    = result[SIGN_BIT:0] == 0   ;
            end
            // a_eq_b operation logic
            10  :   begin
                result  = a_number == b_number      ;
                zero    = result[SIGN_BIT:0] == 0   ;
            end
        endcase
    end

    // OUTPUT ASSIGNATION
    assign  o_data  = result[SIGN_BIT:0]                ;
    assign  o_flags = {negative, overflow, carry, zero} ;

endmodule
