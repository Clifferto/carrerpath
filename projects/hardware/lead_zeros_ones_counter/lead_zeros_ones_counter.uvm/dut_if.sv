interface dut_if#()
(
    input   logic   i_clock
);

    logic   [lead_zeros_ones_counter_pkg::NB_COUNT  -1:0]   o_ones_count;
    logic   [lead_zeros_ones_counter_pkg::NB_COUNT  -1:0]   o_lead_zeros_count;
    logic   [lead_zeros_ones_counter_pkg::NB_DATA   -1:0]   i_data;

endinterface