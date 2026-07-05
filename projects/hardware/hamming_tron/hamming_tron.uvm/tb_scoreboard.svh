// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    hamming_tron_model                          model;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        model               = hamming_tron_model::type_id::create("model");
        scb_analysis_imp    = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        seq_item model_output = seq_item::type_id::create("model_output");
        
        if (item.input_valid) begin
            model_output.copy(item);
            model.get_output(model_output.codeword, model_output.metric, model_output.weight);
            // model_output.print();

            if (!item.compare(model_output)) begin
                if (model_output.metric != item.metric) begin
                    `uvm_error(this.get_name(), $sformatf(  "[METRIC_ERROR] metric = %0d != %0d (model)"    ,
                                                            item.metric                                     ,
                                                            model_output.metric                             ))
                    
                end
                if (model_output.weight != item.weight) begin
                    `uvm_error(this.get_name(), $sformatf(  "[WEIGHT_ERROR] weight = %0p != %0p (model)"    ,
                                                            item.weight                                     ,
                                                            model_output.weight                             ))
                end
                item.print();
                model_output.print();
            end
        end
        else begin
            `uvm_info(this.get_name(), $sformatf("Invalid input data"), UVM_DEBUG)
        end
    endfunction
    
endclass