interface dut_if#()
(
    input logic i_clock
);
    logic   [tb_pkg::NB_CODEWORD-tb_pkg::NB_WORD    -1:0]   o_syndrome          ;
    logic                                                   o_no_error_detected ;
    logic                                                   o_valid             ;
    logic   [tb_pkg::NB_CODEWORD                    -1:0]   i_data              ;
    logic                                                   i_valid             ;

endinterface