/*
===============================================================================
 Name        : drvCapture.c
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
#include <lpc17xx_timer.h>

#define blkTmr3 LPC_TIM3

//array de tiempos
unsigned int timesval[2];
unsigned int *pTimes=timesval;
unsigned int *finTimes=&timesval[1];

/*
 * Funciones auxiliares
 */
void cfgTmr3(){
	/*
	 * Capture, CAP0.0 en flanco de bajada, incremento del timer cada 500ms
	 */
	//timer init, prescaler para 100ms
	TIM_TIMERCFG_Type cfgtmr={
			.PrescaleOption=TIM_PRESCALE_TICKVAL,
			.PrescaleValue=250E3
	};
	TIM_Init(blkTmr3, TIM_TIMER_MODE, &cfgtmr);

	//p0.23 a CAP3.0, pull-up
	PINSEL_CFG_Type cfgP023={
			.Funcnum=3,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_PULLUP,
			.Pinnum=23,
			.Portnum=0
	};
	PINSEL_ConfigPin(&cfgP023);

	//config CAP3.0, flanco de bajada, habilitar interrupt
	TIM_CAPTURECFG_Type cfgcap={
			.CaptureChannel=0,
			.FallingEdge=ENABLE,
			.IntOnCaption=ENABLE,
			.RisingEdge=DISABLE
	};
	TIM_ConfigCapture(blkTmr3, &cfgcap);

	//bajar bnderas y cargar en NVIC
	TIM_ClearIntCapturePending(blkTmr3, TIM_CR0_INT);
	NVIC_ClearPendingIRQ(TIMER3_IRQn);
	NVIC_EnableIRQ(TIMER3_IRQn);

	return;
}

/*
 * Handlers
 */
void TIMER3_IRQHandler(){
	//bajar banderas
	TIM_ClearIntCapturePending(blkTmr3, TIM_CR0_INT);

	//si se tomaron 2 tiempos
	if(pTimes==finTimes){
		//cargar valor, calcular intervalo y reiniciar puntero
		*pTimes=TIM_GetCaptureValue(blkTmr3, TIM_COUNTER_INCAP0);

		float dt=(*(timesval+1)-*(timesval))*.01;

		pTimes=timesval;
	}
	//sino
	else{
		//cargar valor e incrementar puntero
		*pTimes=TIM_GetCaptureValue(blkTmr3, TIM_COUNTER_INCAP0);

		pTimes++;
	}

	return;
}

int main(void) {

    /*
     * Core init
     */
	SystemInit();

	//config timer3, cap3.0
	cfgTmr3();

	//activar timer
	TIM_Cmd(blkTmr3, ENABLE);

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
