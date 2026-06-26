`timescale 1ns / 1ps

module lead_zeros_counter
#(
    parameter                           NB_DATA             = 32    ,
    parameter                           NB_COUNT            = 32    
)(
    output  reg     [NB_COUNT   -1:0]   o_lead_zeros_count          ,
    input   wire    [NB_DATA    -1:0]   i_data                      
);
    // SIGNALS/VARIABLES
    reg     [NB_COUNT   -1:0]   lead_zeros_count    ;
    reg                         all_zeros           ;
    integer                     jj                  ;

    always @(*) begin
        o_lead_zeros_count  = {NB_COUNT{1'b0}}  ;
        lead_zeros_count    = {NB_COUNT{1'b0}}  ;
        all_zeros           = 1'b1              ;

        for (jj=0; jj<NB_DATA; jj=jj+1) begin
            if (all_zeros) begin
                if (i_data[NB_DATA-jj-1] == 1'b0) begin
                    lead_zeros_count    = lead_zeros_count + 1  ;
                end
                else begin
                    all_zeros           = 1'b0                  ;
                end
            end
            else begin
                lead_zeros_count = lead_zeros_count ;
            end
        end

        o_lead_zeros_count  = lead_zeros_count  ;
    end


endmodule
