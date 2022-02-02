
#ifdef __USE_CMSIS
#include "LPC17xx.h"
#endif

#include <cr_section_macros.h>

// TODO: insert other include files here

/**
 * Funciones auxiliares
 */
void cfgTimer(){
    /**
	 * TIMER Secuencia de inicializacion:
	 * * pwr (PCONP),
	 * * clk (PCLKSEL),
	 * * pines para capture/match externo (PINSEL,PINMODE),
     * * config timer (TCR,MRx)
	 * * interrupts (IR,MCR,CCR)
	 */

    /**
     * dt = Tpclk*(PS + 1)*(Match + 1)
     */

    //habilitar bloque (def: timer0 habilitado), clk del bloque 12.5MHz
    LPC_SC->PCONP|=(1<<1);    
    LPC_SC->PCLKSEL0|=(0b11<<2);

    //modo timer, reset, match/prescaler para 1seg
    LPC_TIM0->CTCR&=~(0b11);
    LPC_TIM0->PC=0;
    LPC_TIM0->TC=0;

    LPC_TIM0->PR=1E5-1;
    LPC_TIM0->MR0=125-1;

    //interrupcion y reset en match0
    LPC_TIM0->MCR|=0b11;

    //ext match0, toggle
    LPC_TIM0->EMR|=(1 | 0b11<<4);

    //p3.25 a MAT0.0 (GREEN), pull-up (def: pull-up)
    LPC_PINCON->PINSEL7|=(0b10<<18);
    LPC_PINCON->PINMODE7&=~(0b11<<18);

    //bajar banderas y cargar en NVIC
    LPC_TIM0->IR|=1;

    NVIC_ClearPendingIRQ(TIMER0_IRQn);
    NVIC_EnableIRQ(TIMER0_IRQn);

    return;
}

/**
 * Handlers
 */
void TIMER0_IRQHandler(){
    //bajar banderas
    LPC_TIM0->IR|=1;

    //toggle al p0.22 (RED)
    //LPC_GPIO0->FIOPIN^=(1<<22);

    return;
}

int main(void) {
    /**
     * Core init
     */
    SystemInit();

    //config timer
    cfgTimer();

    // //p0.22 a gpio (default), salida digital, reposo en 1
    // LPC_PINCON->PINSEL1&=~(0b11<<12);
    // LPC_GPIO0->FIODIR|=(1<<22);
    // LPC_GPIO0->FIOPIN|=(1<<22);

    //tmr0 on
    LPC_TIM0->TCR|=1;
    
    while(1) {
        __asm volatile ("nop");
    }
    return 0 ;
}
