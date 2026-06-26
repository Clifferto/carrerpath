package n_to_1_mux_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter   NB_DATA     = 32                ;
    parameter   N_INPUTS    = 17                ;
    parameter   NB_SEL      = $clog2(N_INPUTS)  ;

    `include "seq_item.svh"

    `include "tb_config.svh"
    `include "tb_sequence.svh"
    `include "tb_scoreboard.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_environment.svh"
    `include "tb_test.svh"

endpackage
