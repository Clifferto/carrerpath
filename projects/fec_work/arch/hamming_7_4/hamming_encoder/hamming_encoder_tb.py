import cocotb
from cocotb.triggers import Timer
import numpy as np
import random

HAMMING_ENCODER__NB_WORD     = 4
HAMMING_ENCODER__NB_CODEWORD = 7

G = np.array([  [1, 0, 0, 0, 1, 1, 0]   ,
                [0, 1, 0, 0, 0, 1, 1]   ,
                [0, 0, 1, 0, 1, 1, 1]   ,
                [0, 0, 0, 1, 1, 0, 1]   ])

@cocotb.test()
async def test_hamming_encoder(dut):
    # arrancamos el tiempo antes de imprimir, asi el aviso del VCD no parte la tabla
    await Timer(1, "ns")

    # RESET DUT.PORTS
    dut.i_word.value    = 0
    dut.i_valid.value   = 0
    await Timer(1, "ns")

    for w in range(2**HAMMING_ENCODER__NB_WORD):
        # DRIVE DUT.PORTS
        # el encoder es combinacional: aplicamos y esperamos que propague
        dut.i_word.value    = w
        dut.i_valid.value   = 1
        # dut.i_word.value    = random.randint(0, 2**HAMMING_WEIGHT__NB_CODEWORD-1)
        await Timer(2, "ns")

        # MONITOR DUT.PORTS
        if int(dut.o_valid.value) == 1:
            # w = dut.o_weight.value.integer
            cw = int(dut.o_codeword.value)

            # GET IDEAL MODEL.DATA
            cw_mod = dut_model(w)

            # VALIDATE DUT.PORTS == MODEL.DATA
            assert cw == cw_mod, f"word={w:0{HAMMING_ENCODER__NB_WORD}b}: DUT={cw:0{HAMMING_ENCODER__NB_CODEWORD}b}, model={cw_mod:0{HAMMING_ENCODER__NB_CODEWORD}b}"
        
            # print(f"word={w:0{HAMMING_ENCODER__NB_WORD}b}: DUT={cw:0{HAMMING_ENCODER__NB_CODEWORD}b}, model={cw_mod:0{HAMMING_ENCODER__NB_CODEWORD}b}")

def dut_model(word):
    word_array  = np.array([(word>>b) & 1 for b in range(HAMMING_ENCODER__NB_WORD)][::-1])
    codeword    = word_array @ G
    codeword    = [cw % 2 for cw in codeword]

    return int("".join(map(str, codeword)), 2)
    
