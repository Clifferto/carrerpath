class word_count_sequence extends uvm_sequence;
    `uvm_object_utils(word_count_sequence)

    function new(string name="word_count_sequence");
        super.new(name);
    endfunction

    virtual task body();
        for (int i = 0; i < 2**NB_WORD; i++) begin
            seq_item item_s   = seq_item::type_id::create("item_s");

            start_item(item_s);
            item_s.word         = i;
            finish_item(item_s);
        end
    endtask
endclass

class full_one_zero_sequence extends uvm_sequence;
    `uvm_object_utils(full_one_zero_sequence)

    function new(string name="full_one_zero_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.word         = '1;
        finish_item(item_s);
        
        item_s = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.word         = '0;
        finish_item(item_s);
    endtask
endclass
