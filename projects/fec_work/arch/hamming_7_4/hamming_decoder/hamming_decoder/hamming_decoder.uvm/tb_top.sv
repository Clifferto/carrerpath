
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import tb_pkg::*;
    
    // Complex testbenches will have multiple clocks and hence multiple clock
    // generator modules that will be instantiated elsewhere
    // For simple designs, it can be put into testbench top
    logic i_clock = 0;

    always #10 i_clock <= ~i_clock;

    // Instantiate the Interface and pass it to Design
    dut_if #()
    vif (
        .i_clock    ( i_clock       )
    );

    hamming_decoder # (
        .NB_WORD        ( NB_WORD           ),
        .NB_CODEWORD    ( NB_CODEWORD       )
    )
    dut (
        .o_data         ( vif.o_data        ),
        .o_corrected    ( vif.o_corrected   ),
        .o_valid        ( vif.o_valid       ),
        .i_data         ( vif.i_data        ),
        .i_valid        ( vif.i_valid       ),
        .i_reset        ( vif.i_reset       ),
        .i_clock        ( vif.i_clock       )
    );

    initial begin
        uvm_config_db#(virtual dut_if)::set (null, "uvm_test_top", "vif", vif);
        run_test ("tb_test");
    end

    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end

endmodule