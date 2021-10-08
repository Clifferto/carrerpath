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
	//bloque adc operativo, adc on, sample-rate a 200KHz (clk del ADC a 13MHz "ponele")
	ADC_Init(LPC_ADC, (unsigned int)(12.5E6/65));

	//habilitar ch0
	ADC_ChannelCmd(LPC_ADC, 0, ENABLE);

	//disparo por software
	//burst entre ch0 y ch1, prescaler=2 (adclk a 12.5MHz), burst off

	//p0.23 al AD0.0, pull-mode off
	PINSEL_CFG_Type cfgP023;
	PINSEL_GetDefaultCfg(&cfgP023);

	cfgP023.Funcnum=1;
	cfgP023.Pinmode=PINSEL_PINMODE_TRISTATE;
	cfgP023.Pinnum=23;
	cfgP023.Portnum=0;

	//cargar configuracion
	PINSEL_ConfigPin(&cfgP023);

	//activar interrupcion por canal (para burst), por ch ultimo de la conversion

	//activar interrupcion por canales, ch0
	LPC_ADC->ADINTEN&=~(1<<8);
	ADC_IntConfig(LPC_ADC, ADC_ADINTEN0, SET);

	//bajar banderas y cargar en NVIC
	NVIC_ClearPendingIRQ(ADC_IRQn);
	NVIC_EnableIRQ(ADC_IRQn);

	return;
}

/*
 * Handlers
 */
void ADC_IRQHandler(){
	//burst stop
	//LPC_ADC->ADCR&=~(1<<16);

	//status
	//volatile unsigned int stt=LPC_ADC->ADSTAT;

	//leer valor de conversion y bajar banderas
	res0=ADC_ChannelGetData(LPC_ADC, 0);

	//burst start
	//LPC_ADC->ADCR|=(1<<16);

	//iniciar conversion
	ADC_StartCmd(LPC_ADC, ADC_START_NOW);

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

	//iniciar conversion
	ADC_StartCmd(LPC_ADC, ADC_START_NOW);

	//burst start
	//LPC_ADC->ADCR|=(1<<16);

	while(1) {
		//proximamente: nada...
	}

    return 0 ;
}
