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
        
        if (!item.input_valid) begin
            valid_zero: assert (!item.output_valid && item.codeword == '0)
                else `uvm_fatal(get_name(), $sformatf("Assertion valid_zero failed!: !%0b && %0b == '0", item.output_valid, item.codeword))
        end
        else begin
            model_output.copy(item);
            model.get_output(model_output.word, model_output.codeword);

            if (!item.compare(model_output)) begin
                `uvm_error(get_name(), $sformatf(   "[ENCODE ERROR] word = %04b: DUT = %07b, model = %07b"  ,
                                                    item.word, item.codeword, model_output.codeword         ))
                model_output.print();
                item.print();
            end
        end

    endfunction
    
endclass