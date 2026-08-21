// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;

    rand bit    [NB_WORD        -1:0]   word                    ;
    rand bit                            input_valid             ;
    bit         [NB_CODEWORD    -1:0]   codeword        = '0    ;
    bit                                 output_valid    = 1'b0  ;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(word         , UVM_DEFAULT | UVM_BIN )
        `uvm_field_int(codeword     , UVM_DEFAULT | UVM_BIN )
        `uvm_field_int(input_valid  , UVM_DEFAULT           )
        `uvm_field_int(output_valid , UVM_DEFAULT           )
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass