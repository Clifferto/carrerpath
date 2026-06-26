// The test instantiates an environment, sets up virtual interface handles to sub components and starts a top level sequence
class tb_test extends uvm_test;
    `uvm_component_utils(tb_test)

    tb_environment  env;
    virtual dut_if  vif;

    function new(string name = "tb_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = tb_environment::type_id::create("env", this);
        
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
            `uvm_fatal("TEST", "Did not get vif")

        uvm_config_db#(virtual dut_if)::set(this, "env.agent.*", "vif", vif);
    endfunction
    
    virtual function void end_of_elaboration_phase (uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        tb_sequence seq = tb_sequence::type_id::create("seq");
        phase.raise_objection(this);
        
        `uvm_info("TEST", $sformatf("Reseting DUT"), UVM_LOW)
        vif.i_request   = '0    ;
        repeat(2) @(posedge vif.i_clock);

        seq.randomize();
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask

endclass