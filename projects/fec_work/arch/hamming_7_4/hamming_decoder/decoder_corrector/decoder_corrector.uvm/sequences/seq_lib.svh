class syndrome_count_sequence extends uvm_sequence;
    `uvm_object_utils(syndrome_count_sequence)

    function new(string name="syndrome_count_sequence");
        super.new(name);
    endfunction

    localparam NB_SYN = NB_CODEWORD-NB_WORD;

    virtual task body();
        for (int i = 1; i < 2**NB_SYN; i++) begin
            seq_item item_s   = seq_item::type_id::create("item_s");

            start_item(item_s);
            item_s.input_data           = 'b0;
            item_s.syndrome             = i;
            item_s.no_error_detected    = 0;
            item_s.input_valid          = 1;
            finish_item(item_s);
        end
    endtask
endclass

class valid_zero_sequence extends uvm_sequence;
    `uvm_object_utils(valid_zero_sequence)

    function new(string name="valid_zero_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize();
        item_s.input_valid = 0;
        finish_item(item_s);
    endtask
endclass
