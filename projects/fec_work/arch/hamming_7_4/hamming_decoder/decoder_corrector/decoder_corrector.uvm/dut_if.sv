interface dut_if#()
(
    input logic i_clock
);
    logic   [tb_pkg::NB_CODEWORD-tb_pkg::NB_WORD    -1:0]   i_syndrome          ;
    logic   [tb_pkg::NB_CODEWORD                    -1:0]   i_data              ;
    logic                                                   i_no_error_detected ;
    logic                                                   i_valid             ;
    logic   [tb_pkg::NB_WORD                        -1:0]   o_data              ;
    logic                                                   o_corrected         ;
    logic                                                   o_valid             ;

endinterface