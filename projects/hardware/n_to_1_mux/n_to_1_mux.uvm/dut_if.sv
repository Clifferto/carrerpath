interface dut_if
(
    input   logic   i_clock
);
    import n_to_1_mux_pkg::NB_DATA;
    import n_to_1_mux_pkg::N_INPUTS;
    import n_to_1_mux_pkg::NB_SEL;
    
    logic   [NB_DATA            -1:0]   o_data      ;
    logic                               o_sel_error ;
    logic   [NB_DATA*N_INPUTS   -1:0]   i_data      ;
    logic   [NB_SEL             -1:0]   i_sel       ;

endinterface