/*
 * Filter Coefficients (C Source) generated by the Filter Design and Analysis Tool
 * Generated by MATLAB(R) 8.3 and the DSP System Toolbox 8.6.
 * Generated on: 24-Oct-2020 19:39:31
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
       29,     31,     11,     52,      0,     60,      5,     49,     25,
       27,     50,      5,     66,     -3,     62,      8,     38,     33,
        6,     56,    -17,     61,    -19,     41,      0,      4,     28,
      -34,     44,    -52,     35,    -44,     -1,    -16,    -48,     13,
      -83,     20,    -90,     -5,    -66,    -53,    -27,   -101,      0,
     -125,     -4,   -110,    -43,    -67,    -97,    -19,   -136,      4,
     -137,    -14,    -96,    -63,    -32,   -115,     20,   -135,     33,
     -106,      0,    -35,    -57,     43,    -98,     91,    -91,     84,
      -29,     32,     65,    -29,    146,    -54,    174,    -16,    137,
       76,     62,    181,      0,    246,     -4,    236,     65,    158,
      178,     59,    275,      0,    301,     22,    235,    120,    108,
      240,    -11,    307,    -56,    272,      0,    136,    124,    -39,
      235,   -166,    251,   -178,    135,    -75,    -78,     74,   -290,
      161,   -398,    102,   -348,   -113,   -177,   -401,      0,   -628,
       46,   -673,   -118,   -511,   -457,   -234,   -824,    -23,  -1028,
      -52,   -936,   -386,   -561,   -924,    -89,  -1412,    189,  -1549,
        0,  -1125,   -773,   -135,  -2011,   1183,  -3376,   2427,  -4439,
     3180,  27969,   3180,  -4439,   2427,  -3376,   1183,  -2011,   -135,
     -773,  -1125,      0,  -1549,    189,  -1412,    -89,   -924,   -561,
     -386,   -936,    -52,  -1028,    -23,   -824,   -234,   -457,   -511,
     -118,   -673,     46,   -628,      0,   -401,   -177,   -113,   -348,
      102,   -398,    161,   -290,     74,    -78,    -75,    135,   -178,
      251,   -166,    235,    -39,    124,    136,      0,    272,    -56,
      307,    -11,    240,    108,    120,    235,     22,    301,      0,
      275,     59,    178,    158,     65,    236,     -4,    246,      0,
      181,     62,     76,    137,    -16,    174,    -54,    146,    -29,
       65,     32,    -29,     84,    -91,     91,    -98,     43,    -57,
      -35,      0,   -106,     33,   -135,     20,   -115,    -32,    -63,
      -96,    -14,   -137,      4,   -136,    -19,    -97,    -67,    -43,
     -110,     -4,   -125,      0,   -101,    -27,    -53,    -66,     -5,
      -90,     20,    -83,     13,    -48,    -16,     -1,    -44,     35,
      -52,     44,    -34,     28,      4,      0,     41,    -19,     61,
      -17,     56,      6,     33,     38,      8,     62,     -3,     66,
        5,     50,     27,     25,     49,      5,     60,      0,     52,
       11,     31,     29
};