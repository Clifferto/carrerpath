class tb_coverage extends uvm_subscriber#(seq_item);
    `uvm_component_utils(tb_coverage)

    covergroup cov_dut;
        ones_count : coverpoint c_item.ones_count {
            bins limits = {0, NB_DATA};
            bins range  = {[0:NB_DATA]};
        }
        lead_zeros_count : coverpoint c_item.lead_zeros_count {
            bins limits = {0, NB_DATA};
            bins range  = {[0:NB_DATA]};
        }
        cross ones_count, lead_zeros_count;
    endgroup

    covergroup cov_sequences;
        coverpoint c_item.data;
    endgroup

    function new(string name="tb_coverage", uvm_component parent=null);
        super.new(name, parent);
        cov_dut         = new();
        cov_sequences   = new();
    endfunction

    seq_item c_item;

    virtual function void write (seq_item item);
        c_item = item;
        cov_dut.sample();
        cov_sequences.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("DUT Coverage = %.2f%%", cov_dut.get_inst_coverage()), UVM_NONE)
        `uvm_info(get_name(), $sformatf("Sequences Coverage = %.2f%%", cov_sequences.get_inst_coverage()), UVM_NONE)
    endfunction

endclass

// GENERATE REPORTS (from proj_dir)
// xcrg -dir ./MODULE.sim/sim_1/behav/xsim/xsim.covdb -report_dir ./MODULE.coverage
