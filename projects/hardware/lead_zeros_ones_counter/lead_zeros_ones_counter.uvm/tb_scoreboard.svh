// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    lead_zeros_ones_counter_model               model;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        model               = lead_zeros_ones_counter_model::type_id::create("model");
        scb_analysis_imp    = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        seq_item model_output = seq_item::type_id::create("model_output");
        
        if (item.data == 0) begin
            if (item.lead_zeros_count != NB_DATA | item.ones_count != 0) begin
                `uvm_error("SCBD", $sformatf(   "[ALL ZEROS FAIL] data = %0b | ones_count = %0d lead_zeros_count = %0d" ,
                                                item.data                                                               ,
                                                item.ones_count                                                         ,
                                                item.lead_zeros_count                                                   ))
            end
        end
        else if (item.data == '1) begin
            if (item.lead_zeros_count != 0 | item.ones_count != NB_DATA) begin
                `uvm_error("SCBD", $sformatf(   "[ALL ONES FAIL] data = %0b | ones_count = %0d lead_zeros_count = %0d"  ,
                                                item.data                                                               ,
                                                item.ones_count                                                         ,
                                                item.lead_zeros_count                                                   ))
            end
        end
        
        model_output.copy(item);
        model.get_output(model_output.data, model_output.ones_count, model_output.lead_zeros_count);

        `uvm_info(get_name(), $sformatf(   "data = %0b | ones_count = %0d, lead_zeros_count = %0d"                      ,
                                            model_output.data, model_output.ones_count, model_output.lead_zeros_count   ), UVM_DEBUG)

        if (!item.compare(model_output)) begin
            if (item.ones_count != model_output.ones_count) begin
                `uvm_error("SCBD", $sformatf(   "[ONES ERROR] data = %0b | ones_count = %0d != %0d"     ,
                                                item.data                                               ,
                                                item.ones_count                                         ,
                                                model_output.ones_count                                 ))
            end
            if (item.lead_zeros_count != model_output.lead_zeros_count) begin
                `uvm_error("SCBD", $sformatf(   "[LEAD ZEROS ERROR] data = %0b | lead_zeros_count = %0d != %0d" ,
                                                item.data                                                       ,
                                                item.lead_zeros_count                                           ,
                                                model_output.lead_zeros_count                                   ))
            end
            item.print();
            model_output.print();
        end

    endfunction
    
endclass