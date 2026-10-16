class random_data_sequence extends uvm_sequence;
    `uvm_object_utils(random_data_sequence)

    function new(string name="random_data_sequence");
        super.new(name);
    endfunction

    virtual task body();
        for (int i = 0; i <= 2**NB_SEL; i++) begin
            repeat(10) begin
                seq_item item = seq_item::type_id::create("item");
                start_item(item);
                item.randomize();
                item.sel = i;
                finish_item(item);
            end
        end
    endtask
endclass
