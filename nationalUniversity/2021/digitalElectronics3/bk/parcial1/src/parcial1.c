/*
===============================================================================
 Name        : parcial1.c
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

#include <stdbool.h>

/*
 * Prototipos
 */
void cfgGpio();
void cfgSystick();
void EINT3_IRQHandler();
void SysTick_Handler();

//flag para cuando se este generando la secuencia
bool ffRunning=false;
//cuenta de ciclos de la secuencia
unsigned char cycle=0;

int main(void) {
	/*
	 * Core init
	 */
	SystemInit();

    /*
     * Configurar gpio, EINT3 y systick
     */
	cfgGpio();
	cfgSystick();

    while(1) {
    	/*
    	 * Nada en el main
    	 */
    }
    return 0 ;
}

/*
 * Funciones
 */
void cfgGpio(){
	/*
	 * p2.4 a GPIO, pullup, digital out
	 * p2.13 a EINT3, pullup, interrupcion por flanco de bajada
	 */
	//en reset: PINSEL4=0 todos a gpio, PINMODE=0 todos los pines con pullup
	LPC_PINCON->PINSEL4|=(0b01<<26);

	//limpiar puerto y setear p2.4 como salida digital
	LPC_GPIO2->FIODIR|=(1<<4);

	//inicializar banderas y setear interrupcion por flanco de bajada
	LPC_SC->EXTINT|=(1<<3);
	LPC_SC->EXTMODE|=(1<<3);

	//en reset: EXTPOLAR=0 eint por flanco de bajada

	//habilitar EINT3 en NVIC
	LPC_SC->EXTINT|=(1<<3);
	NVIC_EnableIRQ(EINT3_IRQn);

	//en reposo p2.4 en alto
	LPC_GPIO2->FIOPIN|=(1<<4);

	return;
}

void cfgSystick(){
	/*
	 * Systick configurado para 10ms, interrupciones habilitadas
	 */
	//activar systick, interrupciones, core clk 100Mhz
	SysTick->CTRL|=0b111;

	//recarga para 10ms
	SysTick->LOAD=SysTick->CALIB;

	//limpiar banderas y cargar el RELOAD en el siguiente ciclo
	SysTick->VAL=0xFF;

	//en reposo el systick esta apagado
	SysTick->CTRL&=~1;

	return;
}

/*
 * Handlers
 */
void EINT3_IRQHandler(){
	//bajar bandera
	LPC_SC->EXTINT|=1<<3;

	//si se esta generando la secuencia
	if(ffRunning){
		//p2.4 en alto
		LPC_GPIO2->FIOPIN|=(1<<4);

		//limpiar, recargar y apagar systick
		SysTick->VAL=0xFF;
		SysTick->CTRL&=~1;

		//reinicializar variables
		ffRunning=false;
		cycle=0;
	}

	//sino
	else{
		//p2.4 en bajo durante los 40ms siguientes
		LPC_GPIO2->FIOPIN&=~(1<<4);

		//activar systick
		SysTick->CTRL|=1;

		//subir flag de secuencia
		ffRunning=true;
	}

	return;
}

void SysTick_Handler(){
	//para los primeros 40ms, p2.4 en bajo
	if(cycle<4) LPC_GPIO2->FIOPIN&=~(1<<4);

	//para los siguientes 70ms, toggle al p2.4
	else if(cycle<13) LPC_GPIO2->FIOPIN^=(1<<4);

	//para los ultimos 40ms, p2.4 en bajo
	else if(cycle<17) LPC_GPIO2->FIOPIN&=~(1<<4);

	//completada la secuencia, limpiar, recargar, apagar systick y reinicializar las variables
	else{
		SysTick->VAL=0xFF;
		SysTick->CTRL&=~1;

		cycle=0;
		ffRunning=false;

		return;
	}

	//aumentar un ciclo de 10ms
	cycle++;

	//bajar bandera, limpiar y recargar systick en prox ciclo de clk
	SysTick->VAL=0xFF;

	return;
}
