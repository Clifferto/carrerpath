// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;
    
    randc bit   [NB_DATA    -1:0]   input_data  [1:0]       ;
    rand bit    [NB_OPCODE  -1:0]   opcode                  ;
    bit         [NB_DATA    -1:0]   output_data         = '0;
    bit         [NB_FLAGS   -1:0]   flags               = '0;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_sarray_int(input_data    , UVM_DEFAULT)
        `uvm_field_int(opcode               , UVM_DEFAULT)
        `uvm_field_int(output_data          , UVM_DEFAULT | UVM_DEC)
        `uvm_field_int(flags                , UVM_DEFAULT | UVM_BIN)
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass