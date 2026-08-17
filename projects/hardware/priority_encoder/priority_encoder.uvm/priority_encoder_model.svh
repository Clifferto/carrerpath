
class priority_encoder_model#(NB_REQUEST, NB_RESPONSE) extends uvm_object;
    `uvm_object_param_utils(priority_encoder_model#(NB_REQUEST, NB_RESPONSE))

    function new(string name="priority_encoder_model");
        super.new(name);
    endfunction

    function void get_output(bit [NB_REQUEST-1:0] request, ref bit [NB_RESPONSE-1:0] response, ref bit valid);
        response    = '0;
        valid       = 0;

        // The foreach remember defined bit order 
        foreach (request[i]) begin
            if (request[i]) begin
                response    = i;
                valid       = 1;
                break;
            end
        end
    endfunction

endclass
