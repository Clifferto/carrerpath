// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)    sequencer;
    valid_zero_sequence         valid_zero_seq;
    all_codewords_sequence      all_codewords_seq;
    added_error_sequence        added_error_seq;

    task body();
        valid_zero_seq      = valid_zero_sequence::type_id::create("valid_zero_seq");
        all_codewords_seq   = all_codewords_sequence::type_id::create("all_codewords_seq");
        added_error_seq     = added_error_sequence::type_id::create("added_error_seq");

        `uvm_info(get_name(), $sformatf("Lauching valid_zero_sequence..."), UVM_NONE)
        repeat (10) valid_zero_seq.start(sequencer);
        `uvm_info(get_name(), $sformatf("Lauching all_codewords_seq..."), UVM_NONE)
        repeat (100) all_codewords_seq.start(sequencer);
        
        `uvm_info(get_name(), $sformatf("Lauching added_error_seq (sweep error)..."), UVM_NONE)
        for (int i=0; i<NB_CODEWORD; ++i) begin
            `uvm_info(get_name(), $sformatf("\nInserted Error In Bit %0d", i), UVM_NONE)
            added_error_seq.error_position = i;
            added_error_seq.start(sequencer);
        end
        
        `uvm_info(get_name(), $sformatf("Lauching added_error_seq (random error)..."), UVM_NONE)
        repeat (50) begin
            added_error_seq.randomize() with {
                error_position inside {[0:NB_CODEWORD-1]};
            };
            `uvm_info(get_name(), $sformatf("\nInserted Error In Bit %0d", added_error_seq.error_position), UVM_NONE)
            added_error_seq.start(sequencer);
        end

    endtask

endclass