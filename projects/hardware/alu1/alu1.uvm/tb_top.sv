
module tb_top;
    // Used classes must be imported inside a package
    import uvm_pkg::*;
    import alu1_pkg::*;
    
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
        .i_clock    ( i_clock       )
    );

    alu1 #(
        .NB_DATA    ( NB_DATA       ),
        .NB_OPCODE  ( NB_OPCODE     ),
        .NB_FLAGS   ( NB_FLAGS      )
    )
    dut (
        .i_data     ( vif.i_data    ),
        .i_opcode   ( vif.i_opcode  ),
        .o_data     ( vif.o_data    ),
        .o_flags    ( vif.o_flags   )
    );

    initial begin
        cfg = tb_config::type_id::create("cfg");
        cfg.NB_DATA     = NB_DATA;
        cfg.NB_OPCODE   = NB_OPCODE;
        cfg.NB_FLAGS    = NB_FLAGS;
        cfg.MAX_OPCODE  = MAX_OPCODE;

        uvm_config_db#(virtual dut_if)::set (null, "uvm_test_top", "vif", vif);
        uvm_config_db#(tb_config)::set (null, "*", "cfg", cfg);
        run_test ("tb_test");
    end

    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end

endmodule