// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;
    
    randc bit   [NB_DATA    -1:0]   data;
    bit         [NB_COUNT   -1:0]   ones_count          = '0;
    bit         [NB_COUNT   -1:0]   lead_zeros_count    = '0;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(data             , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(ones_count       , UVM_DEFAULT | UVM_DEC)
        `uvm_field_int(lead_zeros_count , UVM_DEFAULT | UVM_DEC)
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass