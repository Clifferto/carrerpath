`include "dut_if.sv"

module tb_top;
    import uvm_pkg::*;
    import tb_pkg::*;

    logic i_clock = 0;
    always #10 i_clock <= ~i_clock;

    dut_if #()
    vif (
        .i_clock ( i_clock )
    );

    accumulator # (
        .NB_DATA        ( NB_DATA           ),
        .NB_SEL         ( NB_SEL            )
    )
    dut(
        .o_data         ( vif.o_data        ),
        .o_overflow     ( vif.o_overflow    ),
        .i_data1        ( vif.i_data1       ),
        .i_data2        ( vif.i_data2       ),
        .i_sel          ( vif.i_sel         ),
        .i_reset_n      ( vif.i_reset_n     ),
        .i_clock        ( vif.i_clock       )
    );

    initial begin
        uvm_config_db#(virtual dut_if)::set(null, "uvm_test_top", "vif", vif);
        run_test("tb_test");
    end

    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end

endmodule