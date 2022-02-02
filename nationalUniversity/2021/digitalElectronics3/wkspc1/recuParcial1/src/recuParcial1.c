/*
===============================================================================
 Name        : recuParcial1.c
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

#define gp2 LPC_GPIO2

unsigned int winCout=0;
unsigned int valTick=0;

void SysTick_Handler(){
	//bajan banderas y recarga systick

	//aumentar contador
	winCout++;

	//cada 4 habilitar la interrucion por P2.2
	if(winCout%4==0){
		//habilitar y cargar en NVIC
		LPC_GPIOINT->IO2IntEnR|=(1<<2);
		NVIC_EnableIRQ(EINT3_IRQn);
	}

	//sino mantener desactivada la interrupcion
	else{
		//desabilitar y sacar de NVIC
		LPC_GPIOINT->IO2IntEnR&=~(1<<2);
		NVIC_DisableIRQ(EINT3_IRQn);
	}

	return;
}

void EINT3_IRQHandler(){
	//bajar bandera de GPIO2INT
	LPC_GPIOINT->IO2IntClr|=(1<<2);

	//desabilitar la interrupciones por puerto y systick
	LPC_GPIOINT->IO2IntEnR&=~(1<<2);
	SysTick->CTRL&=~(1<<1);

	//guardar valor del systick
	valTick=SysTick->VAL;

	//esperar hasta que el pin vuelva a cero y salir
	while(((gp2->FIOPIN>>2)&0b1) != 0);

	return;
}

int main(void) {
	/*
	 * Core init
	 */
	SystemInit();

	//config systick para 35ms, cclk, interrupcion en cero
	//SECUENCIA: config reload, habilitar sin interrupcion, cargar el valor a timer, habilitar la interrupcion
	SysTick->LOAD=2.1E6-1;
	SysTick->CTRL|=0b101;
	SysTick->VAL=0xFF;

	SysTick->CTRL|=(1<<1);
	//NVIC_ClearPendingIRQ(SysTick_IRQn);
	//NVIC_EnableIRQ(SysTick_IRQn);

	//P2.2 por defecto a GPIO, pull-down
	LPC_PINCON->PINMODE4|=0b11;

    while(1) {
    	//proximamente.. nada...
    }

    return 0 ;
}
