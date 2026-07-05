package tb_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter   NB_CODEWORD = 4                     ;
    parameter   NB_METRIC   = $clog2(NB_CODEWORD+1) ;
    parameter   NB_WEIGHT   = NB_METRIC             ;

    typedef bit [NB_CODEWORD    -1:0]   codeword_t;
    typedef bit [NB_WEIGHT      -1:0]   weight_t;
    typedef bit [NB_METRIC      -1:0]   metric_t;

    `include "sequences/seq_item.svh"
    `include "sequences/seq_lib.svh"
    
    `include "dut_model.svh"
    `include "tb_scoreboard.svh"
    // `include "tb_coverage.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_environment.svh"
    `include "tb_virtual_seq.svh"
    `include "tb_test.svh"

endpackage
