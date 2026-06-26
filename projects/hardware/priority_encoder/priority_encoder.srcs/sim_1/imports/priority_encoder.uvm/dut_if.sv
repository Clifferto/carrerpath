interface dut_if
#(
    parameter   NB_REQUEST  = 8 
)(
    input       i_reset         ,
    input       i_clock         
);

    logic   [$clog2(NB_REQUEST) -1:0]   o_response  ;
    logic                               o_valid     ;
    logic   [NB_REQUEST         -1:0]   i_request   ;

endinterface