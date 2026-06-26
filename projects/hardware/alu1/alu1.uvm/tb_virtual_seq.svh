// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)    sequencer;
    opcode_sweep_sequence       opcode_sweep_seq;
    max_min_sequence            max_min_seq;
    one_hot_sequence            one_hot_seq;
    alternate_bit_sequence      alternate_bit_seq;
    random_sequence             random_seq;

    task body();
        opcode_sweep_seq    = opcode_sweep_sequence::type_id::create("opcode_sweep_seq");
        max_min_seq         = max_min_sequence::type_id::create("max_min_seq");
        one_hot_seq         = one_hot_sequence::type_id::create("one_hot_seq");
        alternate_bit_seq   = alternate_bit_sequence::type_id::create("alternate_bit_seq");
        random_seq          = random_sequence::type_id::create("random_seq");

        `uvm_info(get_name(), $sformatf("Lauching opcode_sweep_sequence..."), UVM_NONE)
        repeat (100) opcode_sweep_seq.start(sequencer);
        `uvm_info(get_name(), $sformatf("Lauching max_min_seq..."), UVM_NONE)
        repeat (100) max_min_seq.start(sequencer);
        `uvm_info(get_name(), $sformatf("Lauching one_hot_seq..."), UVM_NONE)
        repeat (100) one_hot_seq.start(sequencer);
        `uvm_info(get_name(), $sformatf("Lauching alternate_bit_seq..."), UVM_NONE)
        repeat (100) alternate_bit_seq.start(sequencer);
        `uvm_info(get_name(), $sformatf("Lauching random_sequence..."), UVM_NONE)
        repeat (1000) random_seq.start(sequencer);
    endtask

endclass