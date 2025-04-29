/*
===============================================================================
 Name        : drvTimer.c
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

#include <lpc17xx_timer.h>
#include <lpc17xx_pinsel.h>

// TODO: insert other definitions and declarations here

/**
 * Handlers
 */
void TIMER0_IRQHandler(){
    //bajar banderas
    TIM_ClearIntPending(LPC_TIM0, TIM_MR1_INT);

    //toggle al p3.26 (BLUE)

    return;
}

int main(void) {
    /**
     * Core init
     */
    SystemInit();

    /*
     * Timer config
     */
    //iniciar estructura de configuracion
    TIM_TIMERCFG_Type cfgTim;
    //TIM_ConfigStructInit(TIM_TIMER_MODE, &cfgTim);

    /**
	* dt = Tpclk*(PS + 1)*(Match + 1)
	*/

    //prescaler para 1seg
    //cfgTim.PrescaleOption=TIM_PRESCALE_TICKVAL;

    TIM_GetDefaultCfg(&cfgTim);
    cfgTim.PrescaleValue=5;

    //aplicar configuracion del timer
    TIM_Init(LPC_TIM0, TIM_TIMER_MODE, &cfgTim);

    /*
     * Config pin
     */
    //p3.26 a MAT0.1 (BLUE)
    PINSEL_CFG_Type cfgPinsel;
	PINSEL_GetDefaultCfg(&cfgPinsel);

	cfgPinsel.Pinnum=26;
	cfgPinsel.Portnum=3;
	cfgPinsel.Funcnum=PINSEL_FUNC_2;

	PINSEL_ConfigPin(&cfgPinsel);

    //match externo, toggle MAT0.0/interrupt/reset en match, valor para 1seg
    TIM_MATCHCFG_Type cfgMatch;

    TIM_GetDefaultMatch(&cfgMatch);
    cfgMatch.ExtMatchOutputType=TIM_EXTMATCH_TOGGLE;
    cfgMatch.IntOnMatch=ENABLE;
    cfgMatch.MatchChannel=1;
    cfgMatch.MatchValue=5E6-1;
    //cfgMatch.ResetOnMatch=ENABLE;
    //cfgMatch.StopOnMatch=DISABLE;

	//aplicar configuracion de match
    TIM_ConfigMatch(LPC_TIM0, &cfgMatch);

    //reset timer
    TIM_ResetCounter(LPC_TIM0);

    //bajar flags y cargar en NVIC
    TIM_ClearIntPending(LPC_TIM0, TIM_MR1_INT);
    NVIC_ClearPendingIRQ(TIMER0_IRQn);
    NVIC_EnableIRQ(TIMER0_IRQn);

    //timer on
    TIM_Cmd(LPC_TIM0, ENABLE);

    while(1) {
        __asm volatile ("nop");
    }
    return 0 ;
}
