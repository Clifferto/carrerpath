// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;

    bit         [tb_pkg::NB_DATA*2  -1:0]   output_data     ;
    bit                                     overflow        ;
    rand bit    [tb_pkg::NB_DATA    -1:0]   data        [2] ;
    rand bit    [tb_pkg::NB_SEL     -1:0]   sel             ;

    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(output_data  , UVM_DEFAULT   )
        `uvm_field_int(overflow     , UVM_DEFAULT   )
        `uvm_field_sarray_int(data        , UVM_DEFAULT   )
        `uvm_field_int(sel          , UVM_DEFAULT   )
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass