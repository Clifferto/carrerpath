//! @title FPGA Files List
//! @author Advance Digital Design - Ariel Pola
//! @date 10-10-2021
//! @version Unit03 - Mapeo de Arquitecturas Dedicadas
//! @brief Transmitter filter 
//! - PRBS generator with polyphase filters and block memory for save samples
//! - PRBS generator generates a bit per 8 clock cycles

`include "../include/artyc_include.v"

`include "../parallel_prbs_gen/prbsx.v"

`include "../debug/bram.v"
`include "../debug/ram_fsm.v"
`include "../debug/ram_save.v"

`include "../srrc/tx_fcsg.v"
`include "../srrc/tx_srrc.v"
