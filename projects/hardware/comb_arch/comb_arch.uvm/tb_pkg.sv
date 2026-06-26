package comb_arch_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps
    
    parameter   ALU1_MAX_OPCODE = 'hA               ;
    parameter   ALU1_NB_OPCODE  = 4                 ;

    parameter   N_DATA_INPUTS   = 4                 ;
    parameter   NB_DATA         = 4                 ;
    parameter   NB_FLAGS        = 4                 ;
    parameter   NB_OPCODE       = ALU1_MAX_OPCODE+1 ;
    
    // alu operates selected data with selected opcode
    typedef bit [NB_DATA                -1:0]   alu1_data_t;
    typedef bit [ALU1_NB_OPCODE         -1:0]   alu1_opcode_t;
    typedef bit [NB_FLAGS               -1:0]   alu1_flags_t;
    // input selection is encoded as lead-zeros / ones count
    typedef bit [N_DATA_INPUTS          -1:0]   lzoc_data_t;
    typedef bit [$clog2(N_DATA_INPUTS)  -1:0]   lzoc_count_t;
    // opcode is encoded as priority ones
    typedef bit [NB_OPCODE              -1:0]   pe_request_t;
    typedef bit [ALU1_NB_OPCODE         -1:0]   pe_response_t;

    typedef enum {
        FLAG_ZERO           = 0 ,
        FLAG_CARRY_BORROW       ,
        FLAG_OVERFLOW           ,
        FLAG_NEGATIVE
    } alu1_flags_e;
    
    `include "sequences/seq_item.svh"
    `include "sequences/seq_lib.svh"
    
    `include "comb_arch_model.svh"
    `include "tb_scoreboard.svh"
    // `include "tb_coverage.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_environment.svh"
    `include "tb_virtual_seq.svh"
    `include "tb_test.svh"

endpackage
