package lead_zeros_ones_counter_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter   NB_DATA     = 8                 ;
    parameter   NB_COUNT    = $clog2(NB_DATA+1) ;

    typedef bit [NB_DATA    -1:0] lzoc_data_t;
    typedef bit [NB_COUNT   -1:0] lzoc_count_t;

    `include "sequences/seq_item.svh"
    `include "sequences/seq_lib.svh"
    `include "lead_zeros_ones_counter_model.svh"
    `include "tb_scoreboard.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_coverage.svh"
    `include "tb_environment.svh"
    `include "tb_virtual_seq.svh"
    `include "tb_test.svh"

endpackage
