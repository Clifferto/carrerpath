`include "../syndrome_calculator/syndrome_calculator.uvm/dut_model.svh"
`include "../decoder_corrector/decoder_corrector.uvm/dut_model.svh"

typedef syndrome_calculator_model#(NB_WORD, NB_CODEWORD) syn_cal_model_t;
typedef decoder_corrector_model#(NB_WORD, NB_CODEWORD) dec_cor_model_t;

class decoder_model#(NB_WORD, NB_CODEWORD) extends uvm_object;
    `uvm_object_param_utils(decoder_model#(NB_WORD, NB_CODEWORD))

    function new(string name="decoder_model");
        super.new(name);
        syn_cal_model   = syn_cal_model_t::type_id::create("syn_cal_model_t");
        dec_cor_model   = dec_cor_model_t::type_id::create("dec_cor_model_t");
    endfunction

    typedef bit [NB_CODEWORD-1:0]   r_data_t;
    typedef bit [NB_WORD    -1:0]   data_t;

    syn_cal_model_t syn_cal_model;
    dec_cor_model_t dec_cor_model;

    function void get_output(r_data_t input_data, ref data_t output_data, ref bit corrected);
        output_data = '0;
        corrected   = '0;
        
        decode(input_data, output_data, corrected);
    endfunction

    function void error_correction(data_t input_data, syndrome_t syndrome, ref data_t output_data, ref bit corrected);

        bit [0:NB_WORD-1]   u_data;
        int                 error_position [$];
        // get syndrome
        syn_cal_model.get_output(input_data, syndrome, no_error_detected);

        // decode and correct
        // todo fix decoder_corrector_model, change NB_WORD
        dec_cor_model.get_output(input_data, )

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