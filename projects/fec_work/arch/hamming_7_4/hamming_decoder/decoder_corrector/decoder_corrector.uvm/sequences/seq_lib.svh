// class added_error_sequence extends uvm_sequence;
//     `uvm_object_utils(added_error_sequence)

//     function new(string name="added_error_sequence");
//         super.new(name);
//     endfunction

//     rand int error_position = 0;

//     virtual task body();
//         seq_item item_s                     = seq_item::type_id::create("item_s");
//         bit [0:NB_CODEWORD-1] error_mask    = 0;

//         start_item(item_s);
//         item_s.randomize() with {input_data inside {
//             7'b0000000  ,
//             7'b0001101  ,
//             7'b0010111  ,
//             7'b0011010  ,
//             7'b0100011  ,
//             7'b0101110  ,
//             7'b0110100  ,
//             7'b0111001  ,
//             7'b1000110  ,
//             7'b1001011  ,
//             7'b1010001  ,
//             7'b1011100  ,
//             7'b1100101  ,
//             7'b1101000  ,
//             7'b1110010  ,
//             7'b1111111  };
//         };
//         error_mask[error_position] = 1;
//         item_s.input_data ^= error_mask;
//         item_s.input_valid  = 1;
//         finish_item(item_s);
//     endtask
// endclass

class syndrome_count_sequence extends uvm_sequence;
    `uvm_object_utils(syndrome_count_sequence)

    function new(string name="syndrome_count_sequence");
        super.new(name);
    endfunction

    localparam NB_SYN = NB_CODEWORD-NB_WORD;

    virtual task body();
        for (int i = 1; i < 2**NB_SYN; i++) begin
            seq_item item_s   = seq_item::type_id::create("item_s");

            start_item(item_s);
            item_s.input_data           = 'b0;
            item_s.syndrome             = i;
            item_s.no_error_detected    = 0;
            item_s.input_valid          = 1;
            finish_item(item_s);
        end
    endtask
endclass

class valid_zero_sequence extends uvm_sequence;
    `uvm_object_utils(valid_zero_sequence)

    function new(string name="valid_zero_sequence");
        super.new(name);
    endfunction

    virtual task body();
        seq_item item_s = seq_item::type_id::create("item_s");
        start_item(item_s);
        item_s.randomize();
        item_s.input_valid = 0;
        finish_item(item_s);
    endtask
endclass
