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
