
class lead_zeros_ones_counter_model extends uvm_object;
    `uvm_object_utils(lead_zeros_ones_counter_model)

    function new(string name="lead_zeros_ones_counter_model");
        super.new(name);
    endfunction

    function void get_output(lzoc_data_t data, ref lzoc_count_t ones_count, ref lzoc_count_t lead_zeros_count);
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
