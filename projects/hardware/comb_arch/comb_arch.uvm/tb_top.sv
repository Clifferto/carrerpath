
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import comb_arch_pkg::*;
    
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

    comb_arch #(
        .N_DATA_INPUTS ( N_DATA_INPUTS ),
        .NB_DATA       ( NB_DATA ),
        .NB_FLAGS      ( NB_FLAGS ),
        .NB_OPCODE     ( NB_OPCODE ))
    dut (
        .i_a_data                  ( vif.i_a_data     ),
        .i_b_data                  ( vif.i_b_data     ),
        .i_incode                ( vif.i_incode   ),
        .i_opcode                ( vif.i_opcode   ),
        .o_data                  ( vif.o_data     ),
        .o_flags                 ( vif.o_flags    )
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