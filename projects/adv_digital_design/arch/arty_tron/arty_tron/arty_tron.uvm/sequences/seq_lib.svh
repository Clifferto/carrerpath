class switch_count_sequence extends uvm_sequence;
    `uvm_object_utils(switch_count_sequence)

    function new(string name="switch_count_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s = seq_item::type_id::create("item_s");

        for (int i=0; i<2**NB_SWITCH; ++i) begin
            start_item(item_s);
            {item_s.switch_led_g_b, item_s.switch_limit, item_s.switch_enable} = i;
            finish_item(item_s);
            #(WAIT_CYCLES*PERIOD);
        end
    endtask
endclass
