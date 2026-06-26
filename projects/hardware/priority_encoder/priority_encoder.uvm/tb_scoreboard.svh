// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    priority_encoder_model                      model;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        model               = priority_encoder_model::type_id::create("model");
        scb_analysis_imp    = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        seq_item model_output = seq_item::type_id::create("model_output");
        
        if (item.request == 0) begin
            if (item.valid || item.response != 0) begin
                `uvm_error("SCBD", $sformatf("ERROR! Valid request=0b%0b response=%0d", item.request, item.response))
            end
        end

        model_output.copy(item);
        model.get_output(model_output.request, model_output.response, model_output.valid);

        if (!item.compare(model_output)) begin
            `uvm_error("SCBD", $sformatf("ERROR! Mismatch request=0b%0b response=%0d", item.request, item.response))

            item.print();
            model_output.print();
        end
        else begin
            `uvm_info("SCBD", $sformatf("PASS! Match request=0b%0b response=%0d", item.request, item.response), UVM_LOW)
        end
        
    endfunction

endclass