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
        vif.i_data1     <= '0   ;
        vif.i_data2     <= '0   ;
        vif.i_sel       <= '0   ;
        vif.i_reset_n   <= '0   ;
        
        repeat(2) @(posedge vif.i_clock);
        vif.i_reset_n <= 1;
        
        `uvm_info(get_name(), $sformatf("\nLauching max_data_sequence..."), UVM_NONE)
        for (int i = 0; i <= 2**NB_SEL; i++) begin
            repeat(10) begin
                seq_item item = seq_item::type_id::create("item");
                item.data   = '{'1,'1};
                item.sel    = i;
                env.agent.sequencer.execute_item(item);
            end
        end

        `uvm_info(get_name(), $sformatf("\nReseting DUT"), UVM_LOW)
        @(posedge vif.i_clock);
        vif.i_reset_n <= '0;
        @(posedge vif.i_clock);
        vif.i_reset_n <= 1;

        `uvm_info(get_name(), $sformatf("\nLauching random_data_sequence..."), UVM_NONE)
        for (int i = 0; i <= 2**NB_SEL; i++) begin
            repeat(10) begin
                seq_item item = seq_item::type_id::create("item");
                item.randomize();
                item.sel = i;
                env.agent.sequencer.execute_item(item);
            end
        end
        
        `uvm_info(get_name(), $sformatf("\nReseting DUT"), UVM_LOW)
        @(posedge vif.i_clock);
        vif.i_reset_n   <= '0;
        vif.i_data1     <= '0;
        vif.i_data2     <= '0;
        @(posedge vif.i_clock);
        vif.i_reset_n   <= 1;

        // Cuantos ciclos de reloj son necesarios para que el registro o data produzca overflow
        // cuando i sel, i data1 e i data2 son iguales a 1?.
        `uvm_info(get_name(), $sformatf("\nLauching all_one sequence..."), UVM_NONE)
        repeat(40) begin
            seq_item item = seq_item::type_id::create("item");
            item.data    = '{1,1};
            item.sel     = 1;
            env.agent.sequencer.execute_item(item);
        end

        // ! 31 OR 32 CYCLES
        
        repeat(2) @(posedge vif.i_clock);

        phase.drop_objection(this);
    endtask

endclass