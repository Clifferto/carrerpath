class decoder_corrector_model#(NB_WORD, NB_CODEWORD) extends uvm_object;
    `uvm_object_param_utils(decoder_corrector_model#(NB_WORD, NB_CODEWORD))

    function new(string name="decoder_corrector_model");
        super.new(name);
    endfunction

    //         | 1 1 0 |
    //         | 0 1 1 |
    //         | 1 1 1 |
    // H^T =   | 1 0 1 |
    //         | 1 0 0 |
    //         | 0 1 0 |
    //         | 0 0 1 |
    bit [NB_CODEWORD-NB_WORD-1:0] HT [NB_CODEWORD] = '{
        'b110   ,
        'b011   ,
        'b111   ,
        'b101   ,
        'b100   ,
        'b010   ,
        'b001   
    };

    function void get_output(bit [NB_WORD-1:0] input_data, bit [NB_CODEWORD-NB_WORD-1:0] syndrome, ref bit [NB_WORD-1:0] output_data, ref bit corrected);
        output_data = '0;
        corrected   = '0;
        
        error_correction(input_data, syndrome, output_data, corrected);
    endfunction

    function void error_correction(bit [NB_WORD-1:0] input_data, bit [NB_CODEWORD-NB_WORD-1:0] syndrome, ref bit [NB_WORD-1:0] output_data, ref bit corrected);
        bit [0:NB_WORD-1]   u_data;
        int                 error_position [$];

        if (syndrome == 'b0) begin
            output_data = input_data;
            corrected   = 0;
        end
        else begin
            error_position = HT.find_index(row) with (row == syndrome);
            u_data                      = input_data;
            u_data[error_position[0]]   ^= 1;
            output_data                 = u_data;
            corrected                   = 1;
        end
    endfunction

endclass