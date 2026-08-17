package priority_encoder_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter NB_REQUEST    = 4;

    parameter NB_RESPONSE   = $clog2(NB_REQUEST);
    
    `include "seq_item.svh"

    `include "priority_encoder_model.svh"
    typedef priority_encoder_model#(NB_REQUEST, NB_RESPONSE) dut_model_t;

    `include "tb_sequence.svh"
    `include "tb_scoreboard.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_environment.svh"
    `include "tb_test.svh"

endpackage
