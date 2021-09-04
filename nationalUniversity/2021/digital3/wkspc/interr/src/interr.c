/*
===============================================================================
 Name        : interr.c
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

/*
 * Prototipos
 */
void EINT1_IRQHandler();

int main(void) {

    /*
     * Core init
     */
	SystemInit();

	//P2.11 a EINT1n, pullup
	LPC_PINCON->PINSEL4|=(1<<22);
	LPC_PINCON->PINSEL4&=~(1<<23);
	LPC_PINCON->PINMODE4&=~(3<<22);

	//P3.25 digital, output
	LPC_PINCON->PINSEL7&=~(3<<18);
	LPC_GPIO3->FIODIR|=(1<<25);


	//configurar EINT1n, flanco de bajada
	//xxx SIEMPRE LIMPIAR BANDERA ANTES DE CONFIGURAR,
	LPC_SC->EXTINT|=(1<<1);
	LPC_SC->EXTMODE|=(1<<1);
	LPC_SC->EXTPOLAR&=~(1<<1);

	//xxx UNICAMENTE DESPUES DE CONFIGURAR HABILITAR LAS EINTS EN EL NVIC
	//habilitar EINT1n, prioridad 1
	NVIC_EnableIRQ(EINT1_IRQn);
	NVIC_SetPriority(EINT1_IRQn, 1);

    while(1) {
    	// XXX
        __asm volatile ("nop");
    }

    return 0 ;
}

void EINT1_IRQHandler(){

	//xxx SIEMPRE LIMPIAR FLAG (con 1) DE LAS EINTS
	LPC_SC->EXTINT|=(1<<1);

	//delay
	for(int i=0;i<1024*2;i++){}

	//toggle led verde
	LPC_GPIO3->FIOPIN^=(1<<25);

	return;
}


