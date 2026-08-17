package comb_arch_pkg;
    // defs, classes and configs shared in common scope
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `timescale 1ns/1ps

    parameter N_DATA_INPUTS = 4     ;
    parameter NB_DATA       = 4     ;
    parameter NB_FLAGS      = 4     ;
    parameter NB_OPCODE     = 10+1  ;
    
    // alu operates selected data with selected opcode
    parameter ALU1__MAX_OPCODE  = 'hA;
    parameter ALU1__NB_DATA     = NB_DATA;
    parameter ALU1__NB_OPCODE   = 4;
    parameter ALU1__NB_FLAGS    = NB_FLAGS;
    // input selection is encoded as lead-zeros / ones count
    parameter LZOC__NB_DATA     = N_DATA_INPUTS;
    parameter LZOC__NB_COUNT    = $clog2(N_DATA_INPUTS);
    // opcode is encoded as priority ones
    parameter PE__NB_REQUEST    = NB_OPCODE;
    parameter PE__NB_RESPONSE   = ALU1__NB_OPCODE;

    typedef enum {
        FLAG_ZERO           = 0 ,
        FLAG_CARRY_BORROW       ,
        FLAG_OVERFLOW           ,
        FLAG_NEGATIVE
    } alu1_flags_e;

    `include "../../priority_encoder/priority_encoder.uvm/priority_encoder_model.svh"
    `include "../../lead_zeros_ones_counter/lead_zeros_ones_counter.uvm/lead_zeros_ones_counter_model.svh"
    `include "../../alu1/alu1.uvm/alu1_model.svh"
    typedef priority_encoder_model#(PE__NB_REQUEST, PE__NB_RESPONSE) pe_model_t;
    typedef lead_zeros_ones_counter_model#(LZOC__NB_DATA, LZOC__NB_COUNT) lzoc_model_t;
    typedef alu1_model#(ALU1__NB_DATA, ALU1__NB_OPCODE, ALU1__NB_FLAGS) alu1_model_t;
    
    `include "comb_arch_model.svh"
    typedef comb_arch_model#(NB_DATA, N_DATA_INPUTS, NB_OPCODE, NB_FLAGS) dut_model_t;
    
    `include "sequences/seq_item.svh"
    `include "sequences/seq_lib.svh"
    
    `include "tb_scoreboard.svh"
    // `include "tb_coverage.svh"
    `include "tb_driver.svh"
    `include "tb_monitor.svh"
    `include "tb_agent.svh"
    `include "tb_environment.svh"
    `include "tb_virtual_seq.svh"
    `include "tb_test.svh"

endpackage
