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
        model.get_output(model_output.word, model_output.codeword);

        `uvm_info(get_name(), $sformatf("word %05b --- codeword %015b", model_output.word, model_output.codeword), UVM_NONE)
        model_output.print();
        
        // if (!item.compare(model_output)) begin
        //     `uvm_error(get_name(), $sformatf(   "[ENCODE ERROR] word = %04b: DUT = %07b, model = %07b"  ,
        //                                         item.word, item.codeword, model_output.codeword         ))
        //     model_output.print();
        //     item.print();
        // end

    endfunction
    
endclass