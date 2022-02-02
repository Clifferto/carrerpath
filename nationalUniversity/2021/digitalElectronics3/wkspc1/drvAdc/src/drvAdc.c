/*
===============================================================================
 Name        : drvAdc.c
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

#include <lpc17xx_adc.h>
#include <lpc17xx_pinsel.h>

//resultados de conversion
volatile unsigned short int res0=0;
volatile unsigned short int res1=0;

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
	//bloque adc operativo, adc on, sample-rate a 200KHz (clk del ADC a 13MHz "ponele", cmsis se equivoca)
	ADC_Init(LPC_ADC, (unsigned int)(12.5E6/65));

	//habilitar ch0 y ch1
	ADC_ChannelCmd(LPC_ADC, 0, ENABLE);
	ADC_ChannelCmd(LPC_ADC, 1, ENABLE);

	//disparo por hw, burst entre ch0 y ch1, burst off en configuracion

	//p0.23 al AD0.0, pull-mode off
	PINSEL_CFG_Type cfgP023024={
		.Funcnum=1,
		.Pinmode=PINSEL_PINMODE_TRISTATE,
		.Pinnum=23,
		.Portnum=0,
		.OpenDrain=PINSEL_PINMODE_NORMAL
	};
	PINSEL_ConfigPin(&cfgP023024);

	//p0.24 al AD0.1, pull-mode off
	cfgP023024.Pinnum=24;
	PINSEL_ConfigPin(&cfgP023024);

	/*
	 * Activar interrupcion por canal (IMPORTANTE: para burst interrumpir por ultimo ch de conversion)
	 */
	//activar interrupcion por canales, ch1
	//LPC_ADC->ADINTEN&=~(1<<8);
	ADC_IntConfig(LPC_ADC, ADC_ADINTEN1, ENABLE);

	//bajar banderas y cargar en NVIC
	NVIC_ClearPendingIRQ(ADC_IRQn);
	NVIC_EnableIRQ(ADC_IRQn);

	return;
}

/*
 * Handlers
 */
void ADC_IRQHandler(){
	//burst stop (debug)
	LPC_ADC->ADCR&=~(1<<16);

	//status
	//volatile unsigned int stt=LPC_ADC->ADSTAT;

	//leer valor de conversiones y bajar banderas
	res0=ADC_ChannelGetData(LPC_ADC, 0);
	res1=ADC_ChannelGetData(LPC_ADC, 1);

	//burst start (debug)
	LPC_ADC->ADCR|=(1<<16);

	return;
}

int main(void) {
    /*
     * Core init
     */
	SystemInit();

	/*
	 * Config ADC: Orden: pwr, clk, pins, interrupt
	 */
	cfgAdc();

	//iniciar modo burst ahora
	ADC_BurstCmd(LPC_ADC, SET);

	while(1) {
		//proximamente: nada...
	}

    return 0 ;
}
