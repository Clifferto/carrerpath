// The configuration object can be set into the database at the test top level,
// which can be retrieved by the environment and passed to other agents and components in the same way
// avoiding to share global-parameters
class tb_config extends uvm_object;

    int NB_DATA     = 32 ;
    int N_INPUTS    = 16 ;
    
    // Use utility macros to implement standard functions
    // like print, copy, clone, etc
    `uvm_object_utils_begin(tb_config)
        `uvm_field_int(NB_DATA  , UVM_DEFAULT)
        `uvm_field_int(N_INPUTS , UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "tb_config");
        super.new(name);
    endfunction

endclass