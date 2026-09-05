class decoder_corrector_model#(NB_WORD, NB_CODEWORD) extends uvm_object;
    `uvm_object_param_utils(decoder_corrector_model#(NB_WORD, NB_CODEWORD))

    function new(string name="decoder_corrector_model");
        super.new(name);
    endfunction

    // todo change NB_WORD
    typedef bit [NB_WORD                -1:0] data_t;
    typedef bit [NB_CODEWORD-NB_WORD    -1:0] syndrome_t;

    //         | 1 1 0 |
    //         | 0 1 1 |
    //         | 1 1 1 |
    // H^T =   | 1 0 1 |
    //         | 1 0 0 |
    //         | 0 1 0 |
    //         | 0 0 1 |
    syndrome_t HT [NB_CODEWORD] = '{
        'b110   ,
        'b011   ,
        'b111   ,
        'b101   ,
        'b100   ,
        'b010   ,
        'b001   
    };

    function void get_output(data_t input_data, syndrome_t syndrome, ref data_t output_data, ref bit corrected);
        output_data = '0;
        corrected   = '0;
        
        error_correction(input_data, syndrome, output_data, corrected);
    endfunction

    function void error_correction(data_t input_data, syndrome_t syndrome, ref data_t output_data, ref bit corrected);
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