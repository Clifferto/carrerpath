`timescale 1ns / 1ps

module priority_encoder
#(
    parameter                                   NB_REQUEST  = 8 
)(
    output  reg     [$clog2(NB_REQUEST) -1:0]   o_response      ,
    output  reg                                 o_valid         ,
    input   wire    [NB_REQUEST         -1:0]   i_request       
);
    // SIGNALS
    integer i   ;

    // ENCODER LOGIC
    always @(*) begin
        o_response  = 0     ;
        o_valid     = 1'b0  ;

        for (i=0; i<NB_REQUEST; i=i+1) begin
            if (i_request[i] == 1'b1) begin
                o_response  = i     ;
                o_valid     = 1'b1  ;
            end
        end
    end

endmodule
