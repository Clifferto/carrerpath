`timescale 1ns / 1ps

module bch_15_5_control
#(
    parameter   NB_WORD = 5 
)(
    output  logic                           o_load  ,
    output  logic                           o_flush     ,
    output  logic                           o_clear      ,
    input   logic                           i_valid     ,
    input   logic                           i_reset     ,
    input   logic                           i_clock     
);
    // LOCALPARAM AND SIGNAL DEFINITIONS
    localparam      NB_COUNT    = $clog2(NB_WORD)   ;
    logic       [NB_COUNT   -1:0]   counter ;
    logic       [NB_COUNT   -1:0]   counter_next ;
    logic                           counter_limit ;
    logic                           load    ;
    logic                           flush    ;
    logic                           clear    ;

    assign counter_limit    = counter >= NB_WORD+1;

    always_comb begin
        counter_next = counter + 1;
        if (counter_limit) begin
            counter_next = '0;
        end
    end

    always_ff @(posedge i_clock) begin
        if (i_reset) begin
            counter <= '0;
        end
        else if (i_valid) begin
            counter <= counter_next;
        end
    end

    always_comb begin
        load    = 0;
        flush   = 0;
        clear   = 0;
        
        if (i_valid && counter == 0) begin
            load    = 1;
        end
        else if (counter_limit) begin
            clear   = 1;
        end
        else if (counter > 0) begin
            flush   = 1;
        end
    end

    // OUTPUT PORT ASSIGNATION
    assign o_load   = load  ;
    assign o_flush  = flush ;
    assign o_clear  = clear ;

endmodule
