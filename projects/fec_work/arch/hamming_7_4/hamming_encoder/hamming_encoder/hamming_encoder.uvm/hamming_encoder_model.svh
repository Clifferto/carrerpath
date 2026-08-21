class hamming_encoder_model#(NB_WORD, NB_CODEWORD) extends uvm_object;
    `uvm_object_param_utils(hamming_encoder_model#(NB_WORD, NB_CODEWORD))

    function new(string name="hamming_encoder_model");
        super.new(name);
    endfunction

    //     | 1 0 0 0 1 1 0 |
    // G = | 0 1 0 0 0 1 1 |
    //     | 0 0 1 0 1 1 1 |
    //     | 0 0 0 1 1 0 1 |
    bit [NB_CODEWORD-1:0] G [NB_WORD] = '{
        'b1000110   ,
        'b0100011   ,
        'b0010111   ,
        'b0001101
    };

    function void get_output(bit [NB_WORD-1:0] word, ref bit [NB_CODEWORD-1:0] codeword);
        codeword = '0;
        encode74(word, codeword);
    endfunction

    function void encode74(bit [NB_WORD-1:0] word, ref bit [NB_CODEWORD-1:0] codeword);
        bit [0:NB_WORD-1] u = word;

        foreach (u[i]) begin
            if (u[i] == 1) begin
                codeword ^= this.G[i];
                `uvm_info(get_name(), $sformatf("%07b ^= %07b [%0d];", codeword, this.G[i], i), UVM_DEBUG)
            end
        end
        `uvm_info(get_name(), $sformatf("word %04b codeword %07b", word, codeword), UVM_DEBUG)
    endfunction

    // reporter [model] word 0000 codeword 0000000
    // reporter [model] word 0001 codeword 0001101
    // reporter [model] word 0010 codeword 0010111
    // reporter [model] word 0011 codeword 0011010
    // reporter [model] word 0100 codeword 0100011
    // reporter [model] word 0101 codeword 0101110
    // reporter [model] word 0110 codeword 0110100
    // reporter [model] word 0111 codeword 0111001
    // reporter [model] word 1000 codeword 1000110
    // reporter [model] word 1001 codeword 1001011
    // reporter [model] word 1010 codeword 1010001
    // reporter [model] word 1011 codeword 1011100
    // reporter [model] word 1100 codeword 1100101
    // reporter [model] word 1101 codeword 1101000
    // reporter [model] word 1110 codeword 1110010
    // reporter [model] word 1111 codeword 1111111

endclass