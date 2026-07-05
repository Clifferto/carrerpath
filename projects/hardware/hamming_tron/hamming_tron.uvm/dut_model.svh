`include "../../hamming_metric/hamming_metric.uvm/dut_model.svh"
`include "../../hamming_weight/hamming_weight.uvm/dut_model.svh"

class hamming_tron_model extends uvm_object;
    `uvm_object_utils(hamming_tron_model)

    function new(string name="hamming_tron_model");
        super.new(name);
        weight_model    = hamming_weight_model::type_id::create("weight_model");
        metric_model    = hamming_metric_model::type_id::create("metric_model");
    endfunction

    hamming_weight_model    weight_model;
    hamming_metric_model    metric_model;

    function void get_output(codeword_t codeword [2], ref metric_t metric, ref weight_t weight [2]);
        metric_model.get_output(codeword, metric);

        foreach (codeword[i]) begin
            weight_model.get_output(codeword[i], weight[i]);
        end
    endfunction

endclass
