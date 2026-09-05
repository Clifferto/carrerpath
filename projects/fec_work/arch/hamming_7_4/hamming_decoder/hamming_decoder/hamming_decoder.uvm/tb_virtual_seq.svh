// A virtual sequence is a container to start multiple sequences on different sequencers in the environment.
// The best way to start and control different sequences would be from a virtual sequence.
// It becomes virtual because it is not associated with any particular data type.
class tb_virtual_seq extends uvm_sequence;
    `uvm_object_utils(tb_virtual_seq)

    function new(string name="tb_virtual_seq");
        super.new(name);
    endfunction

    uvm_sequencer#(seq_item)        sequencer;
    set_valid_sequence              set_valid_seq;
    codeword_with_error_sequence    codeword_with_error_seq;

    task body();
        set_valid_seq           = set_valid_sequence::type_id::create("set_valid_seq");
        codeword_with_error_seq = codeword_with_error_sequence::type_id::create("codeword_with_error_seq");

        `uvm_info(get_name(), $sformatf("\nLauching set_valid_sequence (zero valid)...\n"), UVM_NONE)
        repeat (10) set_valid_seq.start(sequencer);
        
        `uvm_info(get_name(), $sformatf("\nLauching codeword_with_error_seq (no errors)...\n"), UVM_NONE)
        repeat (10) codeword_with_error_seq.start(sequencer);
        
        `uvm_info(get_name(), $sformatf("\nLauching codeword_with_error_seq (random error)...\n"), UVM_NONE)
        repeat (20) begin
            codeword_with_error_seq.randomize() with {
                error_position inside {[0:NB_CODEWORD-1]};
            };
            codeword_with_error_seq.insert_error = 1;
            `uvm_info(get_name(), $sformatf("\nError in bit: %0d", codeword_with_error_seq.error_position), UVM_NONE)
            codeword_with_error_seq.start(sequencer);
        end

        `uvm_info(get_name(), $sformatf("\nLauching codeword_with_error_seq (random insertion)...\n"), UVM_NONE)
        repeat (50) begin
            codeword_with_error_seq.randomize() with {
                error_position inside {[0:NB_CODEWORD-1]};
            };
            if (codeword_with_error_seq.insert_error) begin
                `uvm_info(get_name(), $sformatf("\nIserted Error in bit: %0d", codeword_with_error_seq.error_position), UVM_NONE)
            end
            codeword_with_error_seq.start(sequencer);
        end

        `uvm_info(get_name(), $sformatf("\nLauching codeword_with_error_seq (random insertion, random valid)...\n"), UVM_NONE)
        repeat (50) begin
            codeword_with_error_seq.randomize() with {
                error_position inside {[0:NB_CODEWORD-1]};
            };
            if (codeword_with_error_seq.insert_error) begin
                `uvm_info(get_name(), $sformatf("\nIserted Error in bit: %0d", codeword_with_error_seq.error_position), UVM_NONE)
            end

            codeword_with_error_seq.start(sequencer);
        end
        
    endtask

endclass