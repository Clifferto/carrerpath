interface dut_if#()
(
    input   logic   i_clock
);
    logic   [hamming_encoder_pkg::NB_CODEWORD   -1:0]   o_codeword  ;
    logic                                               o_valid     ;
    logic   [hamming_encoder_pkg::NB_WORD       -1:0]   i_word      ;
    logic                                               i_valid     ;

endinterface