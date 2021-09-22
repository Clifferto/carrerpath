/*
===============================================================================
 Name        : firstAdc.c
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

bool trigger=true;
unsigned int res0=0;
unsigned int res1=0;

/*
 * Funciones auxiliares
 */
void cfgAdc(){
	/*
	 * Orden de configuracion ADC:
	 * * pwr(PCONP), clk(PCLKSEL, prescaler),
	 * * pins(PINSEL, PINMODE),
	 * * interrupt(ADINTEN, NVIC)
	 */
	//bloque adc operativo, adc on, clk del bloque a 25MHz
	LPC_SC->PCONP|=(1<<12);
	LPC_ADC->ADCR|=(1<<21);
	LPC_SC->PCLKSEL0&=~(0b11<<24);

	//ch0, prescaler=2 (adclk a 12.5MHz), no start
	//LPC_ADC->ADCR|=(1 | 0b10<<8);

	//ch1, prescaler=2 (adclk a 12.5MHz), no start
	//LPC_ADC->ADCR|=(2 | 0b10<<8);

	//ch0, ch1, prescaler=2 (adclk a 12.5MHz), burst mode
	LPC_ADC->ADCR|=(0b11 | 0b10<<8 | 1<<16);

	//p0.23 al ch0, pull-mode off
	//LPC_PINCON->PINSEL1|=(0b01<<14);
	//LPC_PINCON->PINMODE1|=(0b10<<14);

	//p0.24 al ch1, pull-mode off
	//LPC_PINCON->PINSEL1|=(0b01<<16);
	//LPC_PINCON->PINMODE1|=(0b10<<16);

	//p0.23 al ch0, p0.24 al ch1, pull-mode off
	LPC_PINCON->PINSEL1|=(0b01<<16 | 0b01<<14);
	LPC_PINCON->PINMODE1|=(0b10<<16 | 0b10<<14);

	//activar interrupcion por canal (para burst), por ch0 y ch1, y cargar en NVIC
	LPC_ADC->ADINTEN&=~(1<<8);
	//LPC_ADC->ADINTEN|=1;
	//LPC_ADC->ADINTEN|=(1<<1);
	LPC_ADC->ADINTEN|=(0b11);
	NVIC_EnableIRQ(ADC_IRQn);

	return;
}

/*
 * Handlers
 */
void ADC_IRQHandler(){
	trigger=true;

	unsigned int val0,ch;

	//leer valor de conversion y bajar banderas
	val0=LPC_ADC->ADGDR;

	//canal en parte alta (b24:26)
	ch=val0>>24;

	//resultado en parte baja (b15:4)
	if(ch==0) res0=(val0&0xFFF0)>>4;
	else if(ch==1) res1=(val0&0xFFF0)>>4;

	return;
}

int main(void) {

    /*
     * Core init
     */
	SystemInit();

	/*
	 * ADC: Orden de configuracion pwr, clk, pins, interrupt
	 */
	cfgAdc();

	while(1) {
//		if(trigger){
//			trigger=false;
//
//			//start conversion
//			LPC_ADC->ADCR|=(1<<24);
//		}
    }

    return 0 ;
}
