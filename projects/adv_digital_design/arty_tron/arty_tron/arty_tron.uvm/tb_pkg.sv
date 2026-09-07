package tb_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter   NB_LED      = 4;
    parameter   NB_SWITCH   = 4;
    parameter   NB_COUNTER  = 11;
    parameter   PERIOD      = 10;
    parameter   WAIT_CYCLES = 2**(NB_COUNTER-4)-1;
    
    `include "sequences/seq_item.svh"
    `include "sequences/seq_lib.svh"
    
    `include "tb_scoreboard.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    // `include "tb_coverage.svh"
    `include "tb_environment.svh"
    `include "tb_virtual_seq.svh"
    `include "tb_test.svh"

endpackage
