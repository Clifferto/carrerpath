`timescale 1ns / 1ps

module bch_15_5_lfsr
#(
    parameter                           NB_PARITY   = 10    
)(
    output  logic   [NB_PARITY  -1:0]   o_parity            ,
    input   logic                       i_bit               ,
    input   logic                       i_reset             ,
    input   logic                       i_clock             
);
    // LOCALPARAM AND SIGNAL DEFINITIONS
    localparam  [NB_PARITY+1    -1:0]   GEN_POLY    = 'b101_0011_0111   ;
    logic       [NB_PARITY      -1:0]   remainder                       ;
    logic                               feedback                        ;

    assign feedback = remainder[NB_PARITY-1] ^ i_bit    ;

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            remainder <= '0;
        end
        else begin
            for (int i=0; i<NB_PARITY; i++) begin
                if (i == 0) begin
                    remainder[0]    <= feedback                     ;
                end
                else if (GEN_POLY[i]) begin
                    remainder[i]    <= remainder[i-1] ^ feedback    ;
                end
                else begin
                    remainder[i]    <= remainder[i-1]               ;
                end
            end
        end
    end

    // OUTPUT PORT ASSIGNATION
    assign o_parity = remainder;

endmodule