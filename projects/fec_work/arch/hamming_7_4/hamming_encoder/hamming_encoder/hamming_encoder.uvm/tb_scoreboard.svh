// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    hamming_encoder_model                       model;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        model               = hamming_encoder_model::type_id::create("model");
        scb_analysis_imp    = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        seq_item model_output = seq_item::type_id::create("model_output");
        
        // model_output.copy(item);
        // model.get_output(model_output.input_data, model_output.opcode, model_output.output_data, model_output.flags);

        // `uvm_info(get_name(), $sformatf(   "opcode = %0d | A ? B = %0d ; %0d == %0d (%0d ? %0d == %0b = %0d) | flags = %0b"                                                         ,
        //                                     model_output.opcode                                                                                                                     ,
        //                                     model_output.input_data[0], model_output.input_data[1], model_output.output_data                                                        , 
        //                                     $signed(model_output.input_data[0]), $signed(model_output.input_data[1]), model_output.output_data, $signed(model_output.output_data)   ,
        //                                     model_output.flags                                                                                                                      ), UVM_DEBUG)

        item.print();

        // if (!item.compare(model_output)) begin
        //     if (item.output_data != model_output.output_data) begin
        //         `uvm_error(get_name(), $sformatf(   "[DATA ERROR] A = %0d (%0d) B = %0d (%0d) | output_data = %0d != %0d (%0d != %0d)"  ,
        //                                         item.input_data[0], $signed(item.input_data[0])                                     ,
        //                                         item.input_data[1], $signed(item.input_data[1])                                     ,
        //                                         item.output_data, model_output.output_data                                          ,
        //                                         $signed(item.output_data), $signed(model_output.output_data)                        ))
        //     end
        //     if (item.flags != model_output.flags) begin
        //         `uvm_error(get_name(), $sformatf(   "[FLAG ERROR] output_data = %0d (%0d) | flags = %0b != %0b" ,
        //                                         item.output_data, $signed(item.output_data)                 ,
        //                                         item.flags, model_output.flags                              ))
        //     end
        //     item.print();
        //     model_output.print();
        // end

    endfunction
    
endclass