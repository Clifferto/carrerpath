// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    hamming_metric_model                        model;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        model               = hamming_metric_model::type_id::create("model");
        scb_analysis_imp    = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        seq_item model_output = seq_item::type_id::create("model_output");
        
        if (item.metric > NB_CODEWORD) begin
            `uvm_error("SCBD", $sformatf(   "[WEIGHT OUT OF BOUND] codeword_0 = %0b, codeword_1 = %0b | metric = %0d != %0d (model)"    ,
                                            item.codeword[0]                                                                            ,
                                            item.codeword[1]                                                                            ,
                                            item.metric                                                                                 ,
                                            model_output.metric                                                                         ))
        end

        model_output.copy(item);
        model.get_output(model_output.codeword, model_output.metric);
        // model_output.print();

        if (!item.compare(model_output)) begin
            `uvm_error("SCBD", $sformatf(   "[METRIC ERROR] codeword_0 = %0b, codeword_1 = %0b | metric = %0d != %0d (model)"   ,
                                            item.codeword[0]                                                                    ,
                                            item.codeword[1]                                                                    ,
                                            item.metric                                                                         ,
                                            model_output.metric                                                                 ))
            item.print();
            model_output.print();
        end

    endfunction
    
endclass