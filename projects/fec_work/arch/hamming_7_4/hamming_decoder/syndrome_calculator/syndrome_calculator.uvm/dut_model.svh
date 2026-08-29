class syndrome_calculator_model#(NB_WORD, NB_CODEWORD) extends uvm_object;
    `uvm_object_param_utils(syndrome_calculator_model#(NB_WORD, NB_CODEWORD))

    function new(string name="syndrome_calculator_model");
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

    function void get_output(bit [NB_CODEWORD-1:0] input_data, ref bit [NB_CODEWORD-NB_WORD-1:0] syndrome, ref bit no_error_detected);
        syndrome = '0;
        
        get_syndrome(input_data, syndrome);
        no_error_detected = syndrome == 0;
    endfunction

    function void get_syndrome(bit [NB_CODEWORD-1:0] input_data, ref bit [NB_CODEWORD-NB_WORD-1:0] syndrome);
        bit [0:NB_CODEWORD-1] r = input_data;

        foreach (r[i]) begin
            if (r[i] == 1) begin
                syndrome ^= this.HT[i];
            end
        end
    endfunction

endclass