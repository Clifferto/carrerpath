// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)    sequencer;
    full_one_zero_sequence      full_one_zero_seq;
    word_count_sequence         word_count_seq;

    task body();
        full_one_zero_seq   = full_one_zero_sequence::type_id::create("full_one_zero_seq");
        word_count_seq      = word_count_sequence::type_id::create("word_count_seq");
        
        `uvm_info(get_name(), $sformatf("Lauching full_one_zero_sequence..."), UVM_NONE)
        repeat (10) full_one_zero_seq.start(sequencer);
        `uvm_info(get_name(), $sformatf("Lauching word_count_sequence..."), UVM_NONE)
        repeat (100) word_count_seq.start(sequencer);
    endtask

endclass