// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)    sequencer;
    word_count_sequence         word_count_seq;

    task body();
        word_count_seq  = word_count_sequence::type_id::create("word_count_seq");

        `uvm_info(get_name(), $sformatf("Lauching word_count_sequence..."), UVM_NONE)
        repeat (100) word_count_seq.start(sequencer);
    endtask

endclass