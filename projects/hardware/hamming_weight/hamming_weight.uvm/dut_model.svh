class hamming_weight_model extends uvm_object;
    `uvm_object_utils(hamming_weight_model)

    function new(string name="hamming_weight_model");
        super.new(name);
    endfunction

    function void get_output(codeword_t codeword, ref weight_t weight);
        weight  = $countones(codeword);
    endfunction

endclass
