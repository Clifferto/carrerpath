
class priority_encoder_model extends uvm_object;
    `uvm_object_utils(priority_encoder_model)

    function new(string name="priority_encoder_model");
        super.new(name);
    endfunction

    function void get_output(pe_request_t request, ref pe_response_t response, ref bit valid);
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
