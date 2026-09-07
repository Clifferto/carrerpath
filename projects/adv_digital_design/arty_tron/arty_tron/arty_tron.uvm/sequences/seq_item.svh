// A class called seq_item is defined to hold random input stimul.
// It also has variables to hold output status so that they can be compared easily in a scoreboard.
class seq_item extends uvm_sequence_item;

    rand bit    [tb_pkg::NB_SWITCH-2    -1:0]   switch_limit    ;
    rand bit                                    switch_enable   ;
    rand bit                                    switch_led_g_b  ;
    bit         [tb_pkg::NB_LED         -1:0]   led             ;
    bit         [tb_pkg::NB_LED         -1:0]   led_g           ;
    bit         [tb_pkg::NB_LED         -1:0]   led_b           ;
    
    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(switch_limit     , UVM_DEFAULT           )
        `uvm_field_int(switch_enable    , UVM_DEFAULT           )
        `uvm_field_int(switch_led_g_b   , UVM_DEFAULT           )
        `uvm_field_int(led              , UVM_DEFAULT | UVM_BIN )
        `uvm_field_int(led_g            , UVM_DEFAULT | UVM_BIN )
        `uvm_field_int(led_b            , UVM_DEFAULT | UVM_BIN )
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction

endclass