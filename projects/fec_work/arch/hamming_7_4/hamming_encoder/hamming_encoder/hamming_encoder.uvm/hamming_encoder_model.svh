class hamming_encoder_model extends uvm_object;
    `uvm_object_utils(hamming_encoder_model)

    function new(string name="hamming_encoder_model");
        super.new(name);
    endfunction

    function void get_output(bit [NB_WORD-1:0] word);
        // IMPLEMENT MATRIX MULTIPLICATION
        
        // codeword    = word_array @ G
        // codeword    = [cw % 2 for cw in codeword]
        // return int("".join(map(str, codeword)), 2)
    endfunction

endclass