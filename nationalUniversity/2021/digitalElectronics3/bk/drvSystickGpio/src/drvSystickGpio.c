/*
===============================================================================
 Name        : drvSystickGpio.c
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
#include <lpc17xx_systick.h>
#include <lpc17xx_pinsel.h>
#include <lpc17xx_gpio.h>
#include <lpc17xx_uart.h>

/*
 * Handlers
 */
void SysTick_Handler(){
	//bajar banderas
	SYSTICK_ClearCounterFlag();

	//toggle al p0.22 (RED)
	LPC_GPIO0->FIOPIN^=(1<<22);

	return;
}

int main(void) {

    /**
     * Core init
     */
    SystemInit();

    /**
     * Config SysTick
     */
    //habilitar systick, delay 100ms, habilitar interrupcion
    SYSTICK_Cmd(ENABLE);
    SYSTICK_InternalInit(100);
    SYSTICK_ClearCounterFlag();
    SYSTICK_IntCmd(ENABLE);

    /**
     * Config GPIO
     */
    //p0.22 a GPIO, pull-up
    PINSEL_CFG_Type *pCfgPin;

    PINSEL_GetDefaultCfg(pCfgPin);
    pCfgPin->Portnum=PINSEL_PORT_0;
    pCfgPin->Pinnum=PINSEL_PIN_22;

    PINSEL_ConfigPin(pCfgPin);

    //p0.22 salida digital
    GPIO_SetDir(0, 1<<22, 1);

    while(1) {
        // "Dummy" NOP to allow source level single
        // stepping of tight while() loop
        __asm volatile ("nop");
    }
    return 0 ;
}
