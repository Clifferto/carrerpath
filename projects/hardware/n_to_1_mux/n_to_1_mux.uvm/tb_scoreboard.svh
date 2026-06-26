// The scoreboard receives a data object through its uvm_analysis_imp port from the monitor.
// As soon as the scoreboard receives an item, its write method will be executed which in turn runs the checker and generate reports.
class tb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard)

    function new(string name="tb_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    tb_config                                   cfg;
    uvm_analysis_imp#(seq_item, tb_scoreboard)  scb_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(tb_config)::get(this, "", "cfg", cfg))
            `uvm_fatal("SCB", "Did not get cfg")

        scb_analysis_imp = new("scb_analysis_imp", this);
    endfunction

    virtual function write(seq_item item);
        if (item.sel >= cfg.N_INPUTS) begin
            if (item.sel_error != 1) begin
                `uvm_error("SCBD", $sformatf("[SEL ERROR FAIL] sel=%0d sel_error=%0b", item.sel, item.sel_error))
                item.print();
            end
            if (item.output_data != 0) begin
                `uvm_error("SCBD", $sformatf("[OUTPUT NOT ZERO] sel=%0d sel_error=%0b output_data=0x%0h", item.sel, item.sel_error, item.output_data))
                item.print();
            end
        end
        else if (item.sel_error) begin
            `uvm_error("SCBD", $sformatf("[SEL ERROR FAIL] sel=%0d sel_error=%0b", item.sel, item.sel_error))
            item.print();
        end
        else if (item.output_data != item.input_data[item.sel]) begin
            `uvm_error("SCBD", $sformatf("[DATA ERROR] input_data[%0d]=0x%0h output_data=0x%0h", item.sel, item.input_data[item.sel], item.output_data))
            item.print();
        end
        else begin
            `uvm_info("SCBD", $sformatf("PASS! sel=%0d input_data[%0d]=0x%0h output_data=0x%0h", item.sel, item.sel, item.input_data[item.sel], item.output_data), UVM_LOW)
        end
    endfunction
    
endclass