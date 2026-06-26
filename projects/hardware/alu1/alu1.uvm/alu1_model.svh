// | op  | Operation | Description           |
// | --- | --------- | --------------------- |
// | 0x0 | ADD       | `a + b`               |
// | 0x1 | SUB       | `a - b`               |
// | 0x2 | AND       | Bitwise AND           |
// | 0x3 | OR        | Bitwise OR            |
// | 0x4 | XOR       | Bitwise XOR           |
// | 0x5 | NOT       | Bitwise invert of `a` |
// | 0x6 | SLL       | Logical left shift    |
// | 0x7 | SRL       | Logical right shift   |
// | 0x8 | SLT       | Signed less-than      |
// | 0x9 | ULT       | Unsigned less-than    |
// | 0xA | EQ        | Equality compare      |
// 
// Outputs
// result, Width: WIDTH, Operation result
// zero     , 1 bit, Asserted when output_data == 0
// carry    , 1 bit, Meaning depends on operation: 
//     * Arithmetic ops: carry/borrow (unsigned overflow/underflow)
//     * Logical ops: 0
// overflow , 1 bit, Valid only for signed arithmetic operations Otherwise 0 (signed wrap-around)
// negative , 1 bit, Mirrors MSB of result (for quick access, instead of reading the full result)

// ALU ONLY MANIPULATES INPUT BITS, FOR FLAG CALCULATIONS IS IMPORTANT TO SEE IF THOSE INPUTS ARE SIGNED OR UNSIGNED

class alu1_model extends uvm_object;
    `uvm_object_utils(alu1_model)

    // Only to define the SIGN_BIT, not for model
    alu1_data_t x;

    localparam SIGN_BIT = $bits(x)-1;

    function new(string name="alu1_model");
        super.new(name);
    endfunction

    function void get_output(alu1_data_t input_data[1:0], alu1_opcode_t opcode, ref alu1_data_t output_data, ref alu1_flags_t flags);
        case (opcode)
            'h0     : a_add_b   (input_data, output_data, flags);
            'h1     : a_sub_b   (input_data, output_data, flags);
            'h2     : a_and_b   (input_data, output_data, flags);
            'h3     : a_or_b    (input_data, output_data, flags);
            'h4     : a_xor_b   (input_data, output_data, flags);
            'h5     : a_not     (input_data, output_data, flags);
            'h6     : a_lls_b   (input_data, output_data, flags);
            'h7     : a_lrs_b   (input_data, output_data, flags);
            'h8     : a_slt_b   (input_data, output_data, flags);
            'h9     : a_ult_b   (input_data, output_data, flags);
            'hA     : a_eq_b    (input_data, output_data, flags);
            default : begin
                output_data    = '0;
                flags          = '0;
            end
        endcase
        `uvm_info(get_name(), $sformatf("flags = %0b", flags), UVM_NONE)
    endfunction

    // ARITHMETIC OPERATIONS
    function void a_add_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        longint unsigned    result;
        bit                 unsigned_overflow;
        bit                 sign_same;
        bit                 sign_flip;

        result              = data[0] + data[1];
        output_data         = result;
        
        unsigned_overflow           = result >= 2**$bits(data[0]); 
        sign_same                   = data[0][SIGN_BIT] == data[1][SIGN_BIT];
        sign_flip                   = result[SIGN_BIT] != data[0][SIGN_BIT];
        flags[FLAG_ZERO]            = output_data == 0;
        // in addition, if all ok carry bit always = 0
        flags[FLAG_CARRY_BORROW]    = unsigned_overflow;
        flags[FLAG_OVERFLOW]        = sign_same && sign_flip;
        flags[FLAG_NEGATIVE]        = $signed(output_data) < 0;
    endfunction

    function void a_sub_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        longint unsigned    result;
        bit                 unsigned_underflow;
        bit                 sign_same;
        bit                 sign_flip;

        result              = data[0] - data[1];
        output_data         = result;
        
        unsigned_underflow          = data[0] < data[1];
        sign_same                   = data[0][SIGN_BIT] == data[1][SIGN_BIT];
        sign_flip                   = result[SIGN_BIT] != data[0][SIGN_BIT];
        flags[FLAG_ZERO]            = output_data == 0;
        // in substraction, if all ok carry bit always = 1
        flags[FLAG_CARRY_BORROW]    = !unsigned_underflow;
        flags[FLAG_OVERFLOW]        = !sign_same && sign_flip;
        flags[FLAG_NEGATIVE]        = $signed(output_data) < 0;

        `uvm_info(get_name(), $sformatf("flags = %0b", flags), UVM_NONE)

    endfunction

    // LOGICAL OPERATIONS
    function void a_and_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] & data[1];

        flags[FLAG_ZERO]        = output_data == 0;
        flags[FLAG_NEGATIVE]    = $signed(output_data) < 0;
    endfunction

    function void a_or_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] | data[1];

        flags[FLAG_ZERO]        = output_data == 0;
        flags[FLAG_NEGATIVE]    = $signed(output_data) < 0;
    endfunction

    function void a_xor_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] ^ data[1];

        flags[FLAG_ZERO]        = output_data == 0;
        flags[FLAG_NEGATIVE]    = $signed(output_data) < 0;
    endfunction

    function void a_not(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = ~data[0];

        flags[FLAG_ZERO]        = output_data == 0;
        flags[FLAG_NEGATIVE]    = $signed(output_data) < 0;
    endfunction

    // SHIFTING OPERATIONS
    function void a_lls_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] << data[1];

        flags[FLAG_ZERO]        = output_data == 0;
        flags[FLAG_NEGATIVE]    = $signed(output_data) < 0;
    endfunction

    function void a_lrs_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] >> data[1];

        flags[FLAG_ZERO]        = output_data == 0;
        flags[FLAG_NEGATIVE]    = $signed(output_data) < 0;
    endfunction

    // COMPARISON OPERATIONS
    function void a_eq_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] == data[1];

        flags[FLAG_ZERO]    = output_data == 0;
    endfunction

    function void a_ult_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = data[0] < data[1];

        flags[FLAG_ZERO]    = output_data == 0;
    endfunction

    function void a_slt_b(alu1_data_t data[1:0], ref alu1_data_t output_data, ref alu1_flags_t flags);
        output_data = $signed(data[0]) < $signed(data[1]);

        flags[FLAG_ZERO]    = output_data == 0;
    endfunction

endclass