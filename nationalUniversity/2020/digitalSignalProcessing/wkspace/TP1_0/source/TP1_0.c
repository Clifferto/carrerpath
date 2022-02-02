#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MK64F12.h"
#include "fsl_debug_console.h"
#include "fsl_common.h"
#include "stdbool.h"
#include "stdint.h"
#include "arm_math.h"

//pit frec 60MHz
#define frec 60000000
//8KHz (125us), 16KHz (63us), 22KHz (45us), 44KHz (23us), 48KHz (21u)
const long rate[5]={USEC_TO_COUNT(125u,frec),
					USEC_TO_COUNT(63u,frec),
					USEC_TO_COUNT(45u,frec),
					USEC_TO_COUNT(23u,frec),
					USEC_TO_COUNT(21u,frec)};
//punteros y limites para el rate
long *pRate;
long *finRate;
char contRate=0;

q15_t buffer[512];
q15_t *pBuffer;
q15_t *finBuffer;

bool adcon=false;

void mostrarRate();
void GPIOA_IRQHANDLER();
void GPIOC_IRQHANDLER();
void PIT_CHANNEL_0_IRQHANDLER();
void ADC0_IRQHANDLER();

//App
int main(void) {
	//BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
    BOARD_InitButtonsPins();
    BOARD_InitLEDsPins();
#ifndef BOARD_INIT_DEBUG_CONSOLE_PERIPHERAL
    BOARD_InitDebugConsole();
#endif
    PRINTF("Hello World\n");

    pRate=rate;
    pBuffer=buffer;
    //finRate=&rate[4];
    finRate=&rate[(sizeof(rate)/sizeof(rate[0])-1)];
    finBuffer=&buffer[(sizeof(buffer)/sizeof(buffer[0])-1)];

    PIT_SetTimerPeriod(PIT, kPIT_Chnl_0, rate[0]);
    mostrarRate();

    while(1) {}
    return 0 ;
}

//Cambiar colores del RGB segun la velocidad de muestreo
void mostrarRate(){
	GPIO_PortSet(GPIOB, 1u<<21u);
	GPIO_PortSet(GPIOB, 1u<<22u);
	GPIO_PortSet(GPIOE, 1u<<26u);

	switch(contRate){
		case 0:
			GPIO_PortClear(GPIOB, 1u<<22u);
			break;
		case 1:
			GPIO_PortClear(GPIOB, 1u<<22u);
			GPIO_PortClear(GPIOE, 1u<<26u);
			break;
		case 2:
			GPIO_PortClear(GPIOE, 1u<<26u);
			break;
		case 3:
			GPIO_PortClear(GPIOE, 1u<<26u);
			GPIO_PortClear(GPIOB, 1u<<21u);
			break;
		default:
			GPIO_PortClear(GPIOB, 1u<<21u);
			break;
	}
	if(contRate==4) contRate=0u;
	else contRate++;
}

//Handler del GPIOC, pone a correr el PIT
void GPIOC_IRQHANDLER(){
	//bajar banderas e iniciar pit
	GPIO_PortClearInterruptFlags(GPIOC, 1u<<6u);
	if(adcon==false){
		PIT_StartTimer(PIT, kPIT_Chnl_0);
		adcon=true;
	}
	else{
		PIT_StopTimer(PIT, kPIT_Chnl_0);
		adcon=false;
	}
	__DSB();
}

//Handler del GPIOA, configura e indica la velocidad de muestreo
void GPIOA_IRQHANDLER(){
	//bajar banderas, seleccionar y mostrar sample rate
	GPIO_PortClearInterruptFlags(GPIOA, 1u<<4u);

	if(pRate==finRate) pRate=rate;
	else pRate++;

	PIT_SetTimerPeriod(PIT, kPIT_Chnl_0, (int)(*pRate));
	mostrarRate();

	__DSB();
}
//Handler del PIT, pide una muestra al ADC
void PIT_CHANNEL_0_IRQHANDLER(){
	//bajar banderas e iniciar conversion
	PIT_ClearStatusFlags(PIT, kPIT_Chnl_0, kPIT_TimerFlag);

	ADC16_SetChannelConfig(ADC0, 0u, &ADC0_channelsConfig[0]);

	__DSB();
}
//Handler del ADC, pone el resultado en el DAC
void ADC0_IRQHANDLER(){
	//bajar banderas y pasar resultado al DAC
	ADC16_ClearStatusFlags(ADC0, kADC16_ChannelConversionDoneFlag);

	*pBuffer=(q15_t)ADC16_GetChannelConversionValue(ADC0, 0u);
	DAC_SetBufferValue(DAC0, 0u, *pBuffer);

	if(pBuffer==finBuffer) pBuffer=buffer;
	else pBuffer++;

	__DSB();
}
