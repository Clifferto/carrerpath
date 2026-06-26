`timescale 1ns / 1ps

module n_to_1_mux
#(
    parameter                                   NB_DATA     = 32 ,
    parameter                                   N_INPUTS    = 16 
)(
    output  reg     [NB_DATA            -1:0]   o_data          ,
    output  reg                                 o_sel_error     ,
    input   wire    [NB_DATA*N_INPUTS   -1:0]   i_data          ,
    input   wire    [$clog2(N_INPUTS)   -1:0]   i_sel           
);
    // PARAMETERS/SIGNALS
    wire    [NB_DATA    -1:0]   data_array  [0:N_INPUTS -1] ;

    // INPUT DATA SLICE
    generate
        genvar  i;

        for (i=0; i<N_INPUTS; i=i+1) begin
            assign data_array[i]    = i_data[NB_DATA*(i+1)  -1-:NB_DATA]    ;
        end
    endgenerate

    // MUX LOGIC
    always @(*) begin
        o_data      = {NB_DATA{1'b0}}   ;
        o_sel_error = 1'b0              ;

        if (i_sel >= N_INPUTS) begin
            o_sel_error = 1'b1              ;
        end
        else begin
            o_data      = data_array[i_sel] ;
        end
    end

endmodule
