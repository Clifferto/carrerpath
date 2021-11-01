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
#include <lpc17xx_timer.h>
#include <lpc17xx_dac.h>
#include <lpc17xx_gpio.h>

//resultados de conversion
volatile unsigned short int res0=0;
volatile unsigned short int dacval=0;

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
	//bloque adc operativo, adc on, sample-rate a 8KHz
	ADC_Init(LPC_ADC, 8E3);

	//p0.23 al AD0.0, pull-mode off
	PINSEL_CFG_Type cfgP023={
			.Funcnum=1,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_TRISTATE,
			.Pinnum=23,
			.Portnum=0
	};
	PINSEL_ConfigPin(&cfgP023);

	//habilitar AD0.0
	ADC_ChannelCmd(LPC_ADC, 0, ENABLE);

	//disparo por hw, modo burst

	//activar interrupcion por canales, ch0
	//LPC_ADC->ADINTEN&=~(1<<8);
	ADC_IntConfig(LPC_ADC, ADC_ADINTEN0, ENABLE);

	//bajar banderas y cargar en NVIC
	NVIC_ClearPendingIRQ(ADC_IRQn);
	NVIC_EnableIRQ(ADC_IRQn);

	//AD0.1-AD0.7 a GPIO, pull-down, salida digital, estado bajo
	//tener en cuenta: AD0.3 DACOUT, AD0.6 y AD0.7 UART0
	unsigned char nullCh[6]={2,3,24,25,30,31};

	PINSEL_CFG_Type cfgNullCh={
		.Funcnum=0,
		.OpenDrain=PINSEL_PINMODE_NORMAL,
		.Pinmode=PINSEL_PINMODE_PULLDOWN,
	};

	for(unsigned char ch=0;ch<sizeof(nullCh);ch++){
		//ch del puerto 0
		if(ch<4){
			//pull-down, pin como salida
			cfgNullCh.Portnum=0;
			cfgNullCh.Pinnum=*(nullCh+ch);
			PINSEL_ConfigPin(&cfgNullCh);
			GPIO_SetDir(0, 1<<(*(nullCh+ch)), 1);
			//estado bajo
			GPIO_ClearValue(0, 1<<(*(nullCh+ch)));
		}

		//ch del puerto 1
		else{
			//pull-down, pin como salida
			cfgNullCh.Portnum=1;
			cfgNullCh.Pinnum=*(nullCh+ch);
			PINSEL_ConfigPin(&cfgNullCh);
			GPIO_SetDir(1, 1<<(*(nullCh+ch)), 1);
			//estado bajo
			GPIO_ClearValue(1, 1<<(*(nullCh+ch)));
		}
	}

	return;
}

//void cfgTmr0(){
//	/**
//	 * TIMER Secuencia de inicializacion:
//	 * * pwr (PCONP),
//	 * * clk (PCLKSEL),
//	 * * pines para capture/match externo (PINSEL,PINMODE),
//	 * * config timer (TCR,MRx)
//	 * * interrupts (IR,MCR,CCR)
//	 */
//	//TMR0 a 25MHz, PS=0 (control por TC), toggle en MAT0.1 a 20KHz (cada 50us)(cuadrada de 10KHz, muestreo a 10K)
//	TIM_TIMERCFG_Type cfgtim;
//
//	TIM_GetDefaultCfg(&cfgtim);
//	//cmsis resta 1 al PS
//	cfgtim.PrescaleValue=1;
//
//	//cargar config al modulo
//	TIM_Init(LPC_TIM0, TIM_TIMER_MODE, &cfgtim);
//
//	//match externo, toggle en MAT0.1
//	TIM_MATCHCFG_Type cfgmatch;
//
//	TIM_GetDefaultMatch(&cfgmatch);
//	cfgmatch.ExtMatchOutputType=TIM_EXTMATCH_TOGGLE;
//	cfgmatch.MatchChannel=1;
//	cfgmatch.MatchValue=1250-1;
//
//	//cargar config de match
//	TIM_ConfigMatch(LPC_TIM0, &cfgmatch);
//
//	//p1.29 a MAT0.1, pull-off
//	PINSEL_CFG_Type cfgp129;
//
//	PINSEL_GetDefaultCfg(&cfgp129);
//	cfgp129.Funcnum=3;
//	cfgp129.Pinmode=PINSEL_PINMODE_TRISTATE;
//	cfgp129.Pinnum=29;
//	cfgp129.Portnum=1;
//
//	//cargar config del pin
//	PINSEL_ConfigPin(&cfgp129);
//
//	return;
//}

void cfgDac(){
	//habilitar bloque
	DAC_Init(LPC_DAC);

	//max setup rate 1MHz
	DAC_SetBias(LPC_DAC, 0);

	return;
}

/*
 * Handlers
 */
void ADC_IRQHandler(){
	//leer valor de conversion y bajar banderas
	res0=ADC_ChannelGetData(LPC_ADC, 0);

	//pasar valor al DAC
	DAC_UpdateValue(LPC_DAC, (res0>>2)&0x3FF);

	return;
}

int main(void) {
    /*
     * Core init
     */
	SystemInit();

	/*
	 * Config ADC
	 */
	cfgAdc();

	/*
	 * Config DAC
	 */
	cfgDac();

	/*
	 * Config TMR0
	 */
	//cfgTmr0();

	//iniciar conversion en burst mode
	//ADC_StartCmd(LPC_ADC, ADC_START_NOW);
	//xxx
	//disparo por hw, burst mode a 8KHz, LA FUNCION HACE EL DISPARO
	ADC_BurstCmd(LPC_ADC, ENABLE);

	while(1) {
		//dacval=((LPC_DAC->DACR)>>6)&0x3FF;
		//proximamente: nada...
	}

    return 0 ;
}
