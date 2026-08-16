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
            item_s.input_valid  = 1;
            finish_item(item_s);
        end
    endtask
endclass
