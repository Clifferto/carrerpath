package alu1_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter   NB_DATA     = 16    ;
    parameter   NB_OPCODE   = 4     ;
    parameter   NB_FLAGS    = 4     ;

    parameter   MAX_OPCODE  = 'hA;

    typedef bit [NB_DATA    -1:0] alu1_data_t;
    typedef bit [NB_OPCODE  -1:0] alu1_opcode_t;
    typedef bit [NB_FLAGS   -1:0] alu1_flags_t;
    
    typedef enum {
        FLAG_ZERO           = 0 ,
        FLAG_CARRY_BORROW       ,
        FLAG_OVERFLOW           ,
        FLAG_NEGATIVE
    } alu1_flags_e;

    `include "sequences/seq_item.svh"
    `include "sequences/seq_lib.svh"

    `include "tb_config.svh"
    `include "alu1_model.svh"
    `include "tb_scoreboard.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_coverage.svh"
    `include "tb_environment.svh"
    `include "tb_virtual_seq.svh"
    `include "tb_test.svh"

endpackage
