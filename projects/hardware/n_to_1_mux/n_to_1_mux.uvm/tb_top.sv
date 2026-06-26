
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import n_to_1_mux_pkg::NB_DATA;
    import n_to_1_mux_pkg::N_INPUTS;
    import n_to_1_mux_pkg::tb_config;

    // Complex testbenches will have multiple clocks and hence multiple clock
    // generator modules that will be instantiated elsewhere
    // For simple designs, it can be put into testbench top
    logic       i_clock   = 0 ;
    // Config to avoid RTL-UVM coupling
    tb_config   cfg;

    always #10 i_clock <= ~i_clock;

    // Instantiate the Interface and pass it to Design
    dut_if #()
    vif (
        .i_clock        ( i_clock           )
    );

    n_to_1_mux #(
        .NB_DATA        ( NB_DATA               ),
        .N_INPUTS       ( N_INPUTS              )
    )
    dut (
        .i_data         ( vif.i_data                ),
        .i_sel          ( vif.i_sel                 ),
        .o_data         ( vif.o_data                ),
        .o_sel_error    ( vif.o_sel_error           )
    );

    initial begin
        cfg = tb_config::type_id::create("cfg");
        cfg.NB_DATA     = NB_DATA;
        cfg.N_INPUTS    = N_INPUTS;

        uvm_config_db#(virtual dut_if#())::set (null, "*", "vif", vif);
        uvm_config_db#(tb_config)::set (null, "*", "cfg", cfg);
        run_test ("tb_test");
    end

    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end

endmodule