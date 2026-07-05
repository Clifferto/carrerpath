// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;
    
    randc codeword_t    codeword    [2]                 ;
    weight_t            weight      [2] = '{default:0}  ;
    metric_t            metric          = '0            ;

    rand bit            input_valid                     ;
    bit                 output_valid                    ;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_sarray_int(codeword  , UVM_DEFAULT | UVM_BIN)
        `uvm_field_sarray_int(weight    , UVM_DEFAULT | UVM_DEC)
        `uvm_field_int(metric           , UVM_DEFAULT | UVM_DEC)
        `uvm_field_int(input_valid      , UVM_DEFAULT)
        `uvm_field_int(output_valid     , UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass