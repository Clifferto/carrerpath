/*
 * Filter Coefficients (C Source) generated by the Filter Design and Analysis Tool
 * Generated by MATLAB(R) 8.3 and the DSP System Toolbox 8.6.
 * Generated on: 24-Oct-2020 19:46:18
 */

/*
 * Discrete-Time FIR Filter (real)
 * -------------------------------
 * Filter Structure  : Direct-Form FIR
 * Filter Length     : 309
 * Stable            : Yes
 * Linear Phase      : Yes (Type 1)
 * Arithmetic        : fixed
 * Numerator         : s16,15 -> [-1 1)
 * Input             : s16,15 -> [-1 1)
 * Filter Internals  : Full Precision
 *   Output          : s33,30 -> [-4 4)  (auto determined)
 *   Product         : s31,30 -> [-1 1)  (auto determined)
 *   Accumulator     : s33,30 -> [-4 4)  (auto determined)
 *   Round Mode      : No rounding
 *   Overflow Mode   : No overflow
 */

/* General type conversion for MATLAB generated C-code  */
#include "tmwtypes.h"
/* 
 * Expected path to tmwtypes.h 
 * C:\Program Files\MATLAB\R2014a\extern\include\tmwtypes.h 
 */
const int BL = 309;
const int16_T B[309] = {
       24,     25,     27,     28,     29,     30,     31,     32,     32,
       32,     32,     32,     32,     32,     31,     30,     29,     27,
       26,     24,     22,     20,     17,     15,     12,      9,      6,
        2,     -1,     -5,     -8,    -12,    -16,    -20,    -24,    -28,
      -32,    -35,    -39,    -43,    -46,    -50,    -53,    -56,    -58,
      -61,    -63,    -65,    -67,    -68,    -69,    -69,    -69,    -69,
      -68,    -67,    -66,    -64,    -61,    -58,    -55,    -51,    -47,
      -42,    -37,    -31,    -25,    -19,    -13,     -6,      2,      9,
       17,     25,     33,     41,     49,     57,     65,     73,     81,
       89,     96,    104,    111,    117,    123,    129,    134,    138,
      142,    145,    148,    149,    150,    150,    149,    147,    145,
      141,    136,    130,    124,    116,    107,     97,     86,     74,
       61,     46,     31,     15,     -2,    -20,    -39,    -58,    -79,
     -100,   -122,   -145,   -168,   -192,   -216,   -240,   -265,   -290,
     -315,   -341,   -366,   -391,   -416,   -441,   -465,   -489,   -513,
     -536,   -558,   -580,   -601,   -621,   -640,   -658,   -675,   -691,
     -705,   -719,   -731,   -742,   -751,   -759,   -766,   -771,   -775,
     -777,  31967,   -777,   -775,   -771,   -766,   -759,   -751,   -742,
     -731,   -719,   -705,   -691,   -675,   -658,   -640,   -621,   -601,
     -580,   -558,   -536,   -513,   -489,   -465,   -441,   -416,   -391,
     -366,   -341,   -315,   -290,   -265,   -240,   -216,   -192,   -168,
     -145,   -122,   -100,    -79,    -58,    -39,    -20,     -2,     15,
       31,     46,     61,     74,     86,     97,    107,    116,    124,
      130,    136,    141,    145,    147,    149,    150,    150,    149,
      148,    145,    142,    138,    134,    129,    123,    117,    111,
      104,     96,     89,     81,     73,     65,     57,     49,     41,
       33,     25,     17,      9,      2,     -6,    -13,    -19,    -25,
      -31,    -37,    -42,    -47,    -51,    -55,    -58,    -61,    -64,
      -66,    -67,    -68,    -69,    -69,    -69,    -69,    -68,    -67,
      -65,    -63,    -61,    -58,    -56,    -53,    -50,    -46,    -43,
      -39,    -35,    -32,    -28,    -24,    -20,    -16,    -12,     -8,
       -5,     -1,      2,      6,      9,     12,     15,     17,     20,
       22,     24,     26,     27,     29,     30,     31,     32,     32,
       32,     32,     32,     32,     32,     31,     30,     29,     28,
       27,     25,     24
};
