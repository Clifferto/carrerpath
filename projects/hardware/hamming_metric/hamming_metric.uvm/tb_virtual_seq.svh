// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)    sequencer;
    random_sequence             random_seq;

    task pre_body();
        random_seq          = random_sequence::type_id::create ("random_seq");
    endtask

    task body();
        `uvm_info(get_name(), $sformatf("Lauching random_sequence..."), UVM_NONE)
        repeat (1000) random_seq.start(sequencer);
    endtask

endclass