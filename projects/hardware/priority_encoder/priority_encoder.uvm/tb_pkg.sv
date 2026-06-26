package priority_encoder_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter NB_REQUEST    = 4;

    parameter NB_RESPONSE   = $clog2(NB_REQUEST);
    
    typedef bit [NB_REQUEST     -1:0] pe_request_t;
    typedef bit [NB_RESPONSE    -1:0] pe_response_t;
    
    `include "seq_item.svh"

    `include "tb_config.svh"
    `include "tb_sequence.svh"
    `include "priority_encoder_model.svh"
    `include "tb_scoreboard.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_environment.svh"
    `include "tb_test.svh"

endpackage
