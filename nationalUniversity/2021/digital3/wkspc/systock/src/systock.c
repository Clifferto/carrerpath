/*
===============================================================================
 Name        : systock.c
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
void SysTick_Handler();

int main(void) {

    /*
     * Core init
     */
	SystemInit();

	//P3.25 a gpio, salida digital, pulloff
	LPC_PINCON->PINMODE7|=(10<<18);
	LPC_GPIO3->FIODIR|=(1<<25);

	//systick, interrupcion cada: (0xFFFFFF + 1)/100MHz = 167ms aprox (LA FUNCION YA RESTA 1 AL VALOR DE CARGA)
	//SysTick_Config(0xFFFFFF);
	//inicializar bandera
	unsigned int tmp=SysTick->CTRL;

	//prioridad de interrupcion
	NVIC_SetPriority(SysTick_IRQn, 1);
	//configurar recarga, limpiar timer, coreclock, habilitar int y activar timer
	SysTick->LOAD=0xFFFFFF-1;
	SysTick->CTRL|=0b111;

    while(1) {
    	//nada
    	__asm volatile ("nop");
    }
    return 0 ;
}

void SysTick_Handler(){

	//bajar banderas, recargar systick

	//toggle al led BLUE
	LPC_GPIO3->FIOPIN^=(1<<25);

	return;
}

