
class lead_zeros_ones_counter_model#(NB_DATA, NB_COUNT) extends uvm_object;
    `uvm_object_param_utils(lead_zeros_ones_counter_model#(NB_DATA, NB_COUNT))

    function new(string name="lead_zeros_ones_counter_model");
        super.new(name);
    endfunction

    function void get_output(bit [NB_DATA-1:0] data, ref bit [NB_COUNT-1:0] ones_count, ref bit [NB_COUNT-1:0] lead_zeros_count);
        ones_count          = $countones(data);
        lead_zeros_count    = '0;
        
        // The foreach remember defined bit order 
        foreach (data[i]) begin
            if (data[i] == 0) begin
                lead_zeros_count++;
            end
            else begin
                break;
            end
        end
    endfunction

endclass
