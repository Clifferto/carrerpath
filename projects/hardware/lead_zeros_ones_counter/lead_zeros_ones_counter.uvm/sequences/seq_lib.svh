// The main sequence that forms the stimulus and randomizer aspect of the testbench.
// The sequence when started on a sequencer gets the body method executed wich create/randomize seq_item objects and send them to the driver.
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

class all_zero_one_sequence extends uvm_sequence;
    `uvm_object_utils(all_zero_one_sequence)

    function new(string name="all_zero_one_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s   = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize() with {
            data inside {0, 2**NB_DATA-1};
        };
        finish_item(item_s);
    endtask
endclass

class moving_zero_one_sequence extends uvm_sequence;
    `uvm_object_utils(moving_zero_one_sequence)

    function new(string name="moving_zero_one_sequence");
        super.new(name);
    endfunction

    bit moving_zero = 1;

    virtual task body();
        seq_item item_s   = seq_item::type_id::create("item_s");
        
        if (moving_zero) begin
            foreach (item_s.data[i]) begin
                start_item(item_s);
                item_s.data = ~(1<<i);
                finish_item(item_s);
            end
        end
        else begin
            foreach (item_s.data[i]) begin
                start_item(item_s);
                item_s.data = 1<<i;
                finish_item(item_s);
            end
        end
    endtask
endclass