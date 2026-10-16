// The test instantiates an environment, sets up virtual interface handles to sub components and starts a top level sequence
class tb_test extends uvm_test;
    `uvm_component_utils(tb_test)

    function new(string name = "tb_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    tb_environment  env;
    virtual dut_if  vif;

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
        phase.raise_objection(this);

        `uvm_info(get_name(), $sformatf("\nReseting DUT"), UVM_LOW)
        vif.i_dataA     <= '0   ;
        vif.i_dataB     <= '0   ;
        vif.i_sel       <= '0   ;
        
        repeat(2) @(posedge vif.i_clock);
        
        `uvm_info(get_name(), $sformatf("\nLauching max_data_sequence..."), UVM_NONE)
        for (int i = 0; i <= 2**NB_SEL; i++) begin
            repeat(5) begin
                seq_item item = seq_item::type_id::create("item");
                item.data   = '{'1,'1};
                item.sel    = i;
                env.agent.sequencer.execute_item(item);
            end
        end

        `uvm_info(get_name(), $sformatf("\nLauching random_data_sequence..."), UVM_NONE)
        for (int i = 0; i <= 2**NB_SEL; i++) begin
            repeat(5) begin
                seq_item item = seq_item::type_id::create("item");
                item.randomize();
                item.sel    = i;
                env.agent.sequencer.execute_item(item);
            end
        end

        `uvm_info(get_name(), $sformatf("\nLauching random_sequence..."), UVM_NONE)
        repeat(50) begin
            seq_item item = seq_item::type_id::create("item");
            item.randomize();
            env.agent.sequencer.execute_item(item);
        end
    
        repeat(2) @(posedge vif.i_clock);

        phase.drop_objection(this);
    endtask

endclass