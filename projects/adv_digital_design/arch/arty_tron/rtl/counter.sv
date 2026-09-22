`timescale 1ns / 1ps

module counter
#(
    parameter                           NB_SWITCH   = 3     , 
    parameter                           NB_COUNTER  = 32    
)(
    output  logic                       o_valid             ,
    input   logic   [NB_SWITCH  -1:0]   i_switch            ,
    input   logic                       i_reset             ,
    input   logic                       i_clock             
);
    // LOCALPARAM/VARIABLES
    localparam                          R0                  = 2**(NB_COUNTER-10 )-1 ;
    localparam                          R1                  = 2**(NB_COUNTER-9  )-1 ;
    localparam                          R2                  = 2**(NB_COUNTER-8  )-1 ;
    localparam                          R3                  = 2**(NB_COUNTER-7  )-1 ;
    logic       [NB_COUNTER     -1:0]   limit                                       ;
    logic       [NB_COUNTER     -1:0]   counter                                     ;
    logic       [NB_COUNTER     -1:0]   counter_next                                ;
    logic       [NB_SWITCH-1    -1:0]   limit_control                               ;
    logic                               enable                                      ;
    logic                               clear                                       ;
    logic                               counter_done                                ;
    logic                               counter_done_next                           ;

    assign {limit_control, enable}  = i_switch  ;

    always_comb begin
        case (limit_control)
            'd0:    limit   = R0    ;
            'd1:    limit   = R1    ;
            'd2:    limit   = R2    ;
            default: begin
                limit   = R3    ;
            end
        endcase
    end

    assign clear                = i_reset | ~enable                         ;
    assign counter_next         = (counter >= limit) ? '0   : counter + 'b1 ;
    assign counter_done_next    = (counter >= limit) ? 'b1  : 'b0           ;

    always_ff @(posedge i_clock) begin
        if (clear) begin
            counter         <= '0   ;
            counter_done    <= 'b0  ;
        end
        else if (enable) begin
            counter         <= counter_next         ;
            counter_done    <= counter_done_next    ;
        end
    end

    // OUTPUT ASSIGNATION
    assign o_valid  = counter_done  ;

endmodule
