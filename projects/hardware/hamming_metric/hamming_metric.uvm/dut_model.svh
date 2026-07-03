class hamming_metric_model extends uvm_object;
    `uvm_object_utils(hamming_metric_model)

    function new(string name="hamming_metric_model");
        super.new(name);
    endfunction

    function void get_output(codeword_t codeword [2], ref metric_t metric);
        metric  = $countones(codeword[0] ^ codeword[1]);
    endfunction

endclass
