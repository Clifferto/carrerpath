/*
===============================================================================
 Name        : parcial2.c
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

#include <lpc17xx_pinsel.h>
#include <lpc17xx_adc.h>
#include <lpc17xx_clkpwr.h>
#include <lpc17xx_timer.h>

void cfgCap1ch0(){
	//p1.18 a CAP1.0, pull-off, open drain off
	PINSEL_CFG_Type cfgP118={
			.Funcnum=3,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_TRISTATE,
			.Pinnum=18,
			.Portnum=1
	};
	PINSEL_ConfigPin(&cfgP118);

	return;
}

void cfgAdc(){
	//configurar el clk de del bloque a 90MHz
	CLKPWR_SetPCLKDiv(CLKPWR_PCLKSEL_ADC, CLKPWR_PCLKSEL_CCLK_DIV_1);

	//iniciar adc a 197K muestras por segundo (pclk=90MHz, max clk(posible)=cclk/7=12.8MHz, rate=clk(posible)/64)
	ADC_Init(LPC_ADC, 197E3);

	//p0.23 a AD0.0, pull-off
	PINSEL_CFG_Type cfgP023={
			.Funcnum=1,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_TRISTATE,
			.Pinnum=23,
			.Portnum=0
	};
	PINSEL_ConfigPin(&cfgP023);

	//canal 0, habilitar interrupciones
	ADC_ChannelCmd(LPC_ADC, 0, ENABLE);
	ADC_IntConfig(LPC_ADC, ADC_ADINTEN0, ENABLE);

	//bajar banderas y cargar en NVIC
	NVIC_ClearPendingIRQ(ADC_IRQn);
	NVIC_EnableIRQ(ADC_IRQn);

	//disparar modo burst
	ADC_BurstCmd(LPC_ADC, ENABLE);

	return;
}

void cfgTmr2(){
	//timer a cclk/2=45MHz
	CLKPWR_SetPCLKDiv(CLKPWR_PCLKSEL_TIMER2, CLKPWR_PCLKSEL_CCLK_DIV_2);

	//iniciar tmr2, prescaler 450E6 (cmsis resta 1)
	TIM_TIMERCFG_Type cfgtmr={
			.PrescaleOption=TIM_PRESCALE_TICKVAL,
			.PrescaleValue=450E6
	};
	TIM_Init(LPC_TIM2, TIM_TIMER_MODE, &cfgtmr);

	//match, canal 0, match 3 (cmsis no resta 1)
	TIM_MATCHCFG_Type cfgmatch={
			.ExtMatchOutputType=TIM_EXTMATCH_NOTHING,
			.IntOnMatch=ENABLE,
			.MatchChannel=0,
			.MatchValue=3-1,
			.ResetOnMatch=ENABLE,
			.StopOnMatch=DISABLE
	};
	TIM_ConfigMatch(LPC_TIM2, &cfgmatch);

	//bajar banderas y cargar en NVIC
	TIM_ClearIntPending(LPC_TIM2, TIM_MR0_INT);
	NVIC_ClearPendingIRQ(TIMER2_IRQn);
	NVIC_EnableIRQ(TIMER2_IRQn);

	return;
}

int main(void) {

    // TODO: insert code here

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
        i++ ;
        // "Dummy" NOP to allow source level single
        // stepping of tight while() loop
        __asm volatile ("nop");
    }
    return 0 ;
}
