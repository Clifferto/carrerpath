
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import lead_zeros_ones_counter_pkg::*;
    
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

    lead_zeros_ones_counter #(
        .NB_DATA            ( NB_DATA                   )
    )
    dut
    (
        .i_data             ( vif.i_data                ),
        .o_ones_count       ( vif.o_ones_count          ),
        .o_lead_zeros_count ( vif.o_lead_zeros_count    )
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