
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import tb_pkg::*;
    
    // Complex testbenches will have multiple clocks and hence multiple clock
    // generator modules that will be instantiated elsewhere
    // For simple designs, it can be put into testbench top
    logic i_clock   = 0 ;

    always #10 i_clock <= ~i_clock;

    // Instantiate the Interface and pass it to Design
    dut_if #()
    vif (
        .i_clock    ( i_clock       )
    );

    hamming_tron #(
        .NB_CODEWORD    ( NB_CODEWORD       ))
    u_hamming_tron
    (
        .i_codeword     ( vif.i_codeword    ),
        .i_valid        ( vif.i_valid       ),
        .o_metric       ( vif.o_metric      ),
        .o_weight_0     ( vif.o_weight_0    ),
        .o_weight_1     ( vif.o_weight_1    ),
        .o_valid        ( vif.o_valid       )
    );

    initial begin
        uvm_config_db#(virtual dut_if)::set(null, "*", "vif", vif);
        run_test ("tb_test");
    end

    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end

endmodule