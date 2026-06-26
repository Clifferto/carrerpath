class opcode_sweep_sequence extends uvm_sequence;
    `uvm_object_utils(opcode_sweep_sequence)

    function new(string name="opcode_sweep_sequence");
        super.new(name);
    endfunction

    virtual task body();
        int n_items_per_opcode = $urandom_range(10, 50);

        for (int i = 0; i <= MAX_OPCODE; i++) begin
            seq_item item_s   = seq_item::type_id::create("item_s");

            repeat(10) begin
                start_item(item_s);
                item_s.randomize();
                item_s.opcode = i;
                finish_item(item_s);
            end
        end
    endtask
endclass

class random_sequence extends uvm_sequence;
    `uvm_object_utils(random_sequence)

    function new(string name="random_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s   = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize();
        finish_item(item_s);
    endtask
endclass

class max_min_sequence extends uvm_sequence;
    `uvm_object_utils(max_min_sequence)

    function new(string name="max_min_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s   = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize() with {
            foreach (input_data[i]) {input_data[i] inside {{NB_DATA{1'b0}}, {NB_DATA{1'b1}}};}
        };
        finish_item(item_s);
    endtask
endclass

class one_hot_sequence extends uvm_sequence;
    `uvm_object_utils(one_hot_sequence)

    function new(string name="one_hot_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s   = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize();
        foreach (item_s.input_data[i]) item_s.input_data[i] = 1<<$urandom_range(0,NB_DATA-1);
        finish_item(item_s);
    endtask
endclass

class alternate_bit_sequence extends uvm_sequence;
    `uvm_object_utils(alternate_bit_sequence)

    function new(string name="alternate_bit_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s   = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize();
        foreach (item_s.input_data[i]) begin
            item_s.input_data[i]    = {NB_DATA{4'h5}};
            item_s.input_data[i]    <<= $urandom_range(0,1);
        end
        finish_item(item_s);
    endtask
endclass
