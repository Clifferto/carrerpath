/*
===============================================================================
 Name        : uart.c
 Author      : $(author)
 Version     :
 Copyright   : $(copyright)
 Description : main definition
===============================================================================
*/

#ifdef __USE_CMSIS
#include "LPC17xx.h"
#endif

#include <cr_section_macros.h>

// TODO: insert other include files here

void cfgUart(){
	/*
	 * UART Secuencia de inicializacion:
	 * * pwr (PCONP),
	 * * clk (PCLKSEL),
	 * * baud,formato (DLL,DLM,FDR,LCR,LCS),
	 * * habilitar fifos (FCR),
	 * * pines: p0.2/p0.3 como TXD0/RXD0 (PINSEL,PINMODE),
	 * * interrupts (UIER,UIIR)
	 */
	//habilitar bloque (por def habilitado)
	LPC_SC->PCONP|=1<<3;

	//clk del bloque a 25MHz (por def cclk/4)
	LPC_SC->PCLKSEL0&=~(0b11<<6);

	/*
	 * Baud rate 9600 (siguiendo metodo):
	 * DLM=0, DLL=108, DIVADDVAL=1, MULVAL=2
	 */
	//habilitar acceso a los divisor latch, 1byte, stop bit, sin paridad
	LPC_UART0->LCR|=(0b11 | 1<<7);
	//set fractional divider y divisor latch
	LPC_UART0->FDR=(1 | 2<<4);
	LPC_UART0->DLM=0;
	LPC_UART0->DLL=(108&0xFF);

	//limpiar y habilitar fifos
	LPC_UART0->FCR|=0b111;

	//habilitar pines, pull-up (por def)
	LPC_PINCON->PINSEL0|=(0b01<<4 | 0b01<<6);

	return;
}

int main(void) {

    /*
     * Core init
     */
	SystemInit();

	//config uart
	cfgUart();

	//fijar divisor latch
	LPC_UART0->LCR&=~(1<<7);

    volatile static char i = 0;

    while(1) {

        //mandar varios datos, si hay lugar en FIFO
        if((LPC_UART0->LSR>>5)&1){
        	LPC_UART0->THR=(i&0xFF);
        	i++;
        }

        __asm volatile ("nop");
    }
    return 0 ;
}
