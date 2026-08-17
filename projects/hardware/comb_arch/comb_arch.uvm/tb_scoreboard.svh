// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    dut_model_t                                 model;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        model               = dut_model_t::type_id::create("model");
        scb_analysis_imp    = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        seq_item model_output = seq_item::type_id::create("model_output");
        
        model_output.copy(item);
        model.get_output(model_output.input_a_data, model_output.input_b_data, model_output.incode, model_output.opcode, model_output.output_data, model_output.flags);
        model_output.print();

        // if (!item.compare(model_output)) begin
        //     if (item.ones_count != model_output.ones_count) begin
        //         `uvm_error("SCBD", $sformatf(   "[ONES ERROR] data = %0b | ones_count = %0d != %0d"     ,
        //                                         item.data                                               ,
        //                                         item.ones_count                                         ,
        //                                         model_output.ones_count                                 ))
        //     end
        //     if (item.lead_zeros_count != model_output.lead_zeros_count) begin
        //         `uvm_error("SCBD", $sformatf(   "[LEAD ZEROS ERROR] data = %0b | lead_zeros_count = %0d != %0d" ,
        //                                         item.data                                                       ,
        //                                         item.lead_zeros_count                                           ,
        //                                         model_output.lead_zeros_count                                   ))
        //     end
        //     item.print();
        //     model_output.print();
        // end

    endfunction
    
endclass