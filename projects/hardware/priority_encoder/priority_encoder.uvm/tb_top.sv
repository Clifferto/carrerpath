
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import priority_encoder_pkg::*;
    
    // Complex testbenches will have multiple clocks and hence multiple clock
    // generator modules that will be instantiated elsewhere
    // For simple designs, it can be put into testbench top
    logic       i_clock   = 0 ;

    always #10 i_clock <= ~i_clock;

    // Instantiate the Interface and pass it to Design
    dut_if #()
    vif (
        .i_clock    ( i_clock       )
    );

    priority_encoder #(
        .NB_REQUEST ( NB_REQUEST        )
    )
    dut (
        .i_request  ( vif.i_request  ),
        .o_response ( vif.o_response ),
        .o_valid    ( vif.o_valid    )
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