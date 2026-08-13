import cocotb
from cocotb.triggers import Timer
import random

HAMMING_WEIGHT__NB_CODEWORD = 7


@cocotb.test()
async def test_hamming_weight(dut):
    # arrancamos el tiempo antes de imprimir, asi el aviso del VCD no parte la tabla
    await Timer(1, "ns")

    # RESET DUT.PORTS
    dut.i_codeword.value    = 0
    dut.i_valid.value       = 0
    await Timer(1, "ns")

    for cw in range(2**HAMMING_WEIGHT__NB_CODEWORD):
        # DRIVE DUT.PORTS
        # el encoder es combinacional: aplicamos y esperamos que propague
        # dut.i_codeword.value    = cw
        dut.i_codeword.value    = random.randint(0, 2**HAMMING_WEIGHT__NB_CODEWORD-1)
        dut.i_valid.value       = 1
        await Timer(2, "ns")

        # MONITOR DUT.PORTS
        if int(dut.o_valid.value) == 1:
            # w = dut.o_weight.value.integer
            w = int(dut.o_weight.value)

            # w ^= random.randint(0,1)

            # GET IDEAL MODEL.DATA
            w_mod = 0
            for b in [cw>>i & 1 for i in range(HAMMING_WEIGHT__NB_CODEWORD)]:
                if b == 1:
                    w_mod += 1

            # VALIDATE DUT.PORTS == MODEL.DATA
            assert w == w_mod, f"cw={cw:0{HAMMING_WEIGHT__NB_CODEWORD}b}: DUT={w}, model={w_mod}"
            # print(f"cw={cw:0{HAMMING_WEIGHT__NB_CODEWORD}b}: DUT={w}, model={w_mod} (OK)")
