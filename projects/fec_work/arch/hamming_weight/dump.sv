module dump;

initial begin
    $dumpfile("hamming_weight.vcd");
    $dumpvars(0, hamming_weight);
end

endmodule