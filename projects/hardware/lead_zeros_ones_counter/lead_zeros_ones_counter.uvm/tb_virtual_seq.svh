// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)    sequencer;
    all_zero_one_sequence       all_zero_one_seq;
    moving_zero_one_sequence    moving_zero_one_seq;
    random_sequence             random_seq;

    task pre_body();
        random_seq          = random_sequence::type_id::create ("random_seq");
        all_zero_one_seq    = all_zero_one_sequence::type_id::create ("all_zero_one_seq");
        moving_zero_one_seq = moving_zero_one_sequence::type_id::create ("moving_zero_one_seq");
    endtask

    task body();
        `uvm_info(get_name(), $sformatf("Lauching all_zero_one_sequence..."), UVM_NONE)
        repeat (100) all_zero_one_seq.start(sequencer);

        `uvm_info(get_name(), $sformatf("Lauching moving_zero_one_sequence..."), UVM_NONE)
        repeat (200) moving_zero_one_seq.start(sequencer);
        moving_zero_one_seq.moving_zero = 0;
        repeat (200) moving_zero_one_seq.start(sequencer);

        `uvm_info(get_name(), $sformatf("Lauching random_sequence..."), UVM_NONE)
        repeat (1000) random_seq.start(sequencer);
    endtask

endclass