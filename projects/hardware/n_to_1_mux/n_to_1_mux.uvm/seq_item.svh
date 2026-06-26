// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;
    
    rand bit    [NB_DATA    -1:0]   input_data  [N_INPUTS-1:0];
    rand bit    [NB_SEL     -1:0]   sel;
    bit         [NB_DATA    -1:0]   output_data;
    bit                             sel_error;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_sarray_int(input_data    , UVM_DEFAULT)
        `uvm_field_int(sel                  , UVM_DEFAULT)
        `uvm_field_int(output_data          , UVM_DEFAULT)
        `uvm_field_int(sel_error            , UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass