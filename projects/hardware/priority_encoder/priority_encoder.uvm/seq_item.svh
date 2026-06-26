// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;
    rand bit    [NB_REQUEST     -1:0]   request;
    bit         [NB_RESPONSE    -1:0]   response    = '0;
    bit                                 valid       = 0;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(request  , UVM_DEFAULT)
        `uvm_field_int(response , UVM_DEFAULT)
        `uvm_field_int(valid    , UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass