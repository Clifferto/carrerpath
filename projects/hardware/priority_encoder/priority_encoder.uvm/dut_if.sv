interface dut_if #()
(
    input   logic   i_clock
);

    logic   [priority_encoder_pkg::NB_RESPONSE  -1:0]   o_response  ;
    logic                                               o_valid     ;
    logic   [priority_encoder_pkg::NB_REQUEST   -1:0]   i_request   ;

endinterface