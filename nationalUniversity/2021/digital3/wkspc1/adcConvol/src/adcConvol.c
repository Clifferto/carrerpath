/*
===============================================================================
 Name        : adcConvol.c
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
#include <lpc17xx_timer.h>
#include <lpc17xx_exti.h>
#include <lpc17xx_pinsel.h>
#include <lpc17xx_gpio.h>
#include <lpc17xx_clkpwr.h>
#include <lpc17xx_systick.h>
#include <stdbool.h>

/*
 * Macros
 */
#define instAdc LPC_ADC
#define instTmr0 LPC_TIM0
#define len 1024
#define finSignal &buffSignal[len-1]
#define finConv &buffConv[len-1]

/*
 * xxx Variables globales
 */
unsigned char resp[len]={
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

//buffers de salida y entrada
unsigned short int buffSignal[len];
unsigned short int *pSignal=buffSignal;
int buffConv[len];
int *pConv=buffConv;
int playVar=0;

//banderas
bool flgConv=false;
bool flgMuest=true;
bool flgFinal=false;
bool flgPlay=false;

/*
 * xxx Funciones auxiliares
 */
void cfgAdc(){
	/*
	 * ADC operativo a 8Ksamples
	 */
	ADC_Init(instAdc, 8183);

	/*
	 * p0.23 a AD0.0
	 */
	//p0.23 a ch0, open drain off, pull off
	PINSEL_CFG_Type cfgP023={0};
	cfgP023.Funcnum=1;
	cfgP023.OpenDrain=PINSEL_PINMODE_NORMAL;
	cfgP023.Pinmode=PINSEL_PINMODE_TRISTATE;
	cfgP023.Pinnum=23;
	cfgP023.Portnum=0;

	//aplicar configuracion
	PINSEL_ConfigPin(&cfgP023);

	//habilitar ch0
	ADC_ChannelCmd(instAdc, 0, ENABLE);

	/*
	 * Interrupcion por canal
	 */
	ADC_IntConfig(instAdc, ADC_ADINTEN0, ENABLE);
	//bajar banderas y cargar en NVIC
	NVIC_ClearPendingIRQ(ADC_IRQn);
	NVIC_EnableIRQ(ADC_IRQn);

	return;
}

void cfgTmr0(){
	/*
	 * TIMER0 toggle a MAT0.0 (GREEN) cada 500ms
	 */
	//prescaler en cero, control por MATCH
	TIM_TIMERCFG_Type cfgtmr={0};

	cfgtmr.PrescaleOption=TIM_PRESCALE_TICKVAL;
	cfgtmr.PrescaleValue=1;
	TIM_Init(instTmr0, TIM_TIMER_MODE, &cfgtmr);

	//cambiar clock del bloque a 12.5MHz
	LPC_SC->PCLKSEL0|=(0b11<<2);

	//toggle a MAT0.0, reset, no interrupt, no stop
	TIM_MATCHCFG_Type cfgmatch={0};

	cfgmatch.ExtMatchOutputType=TIM_EXTMATCH_TOGGLE;
	cfgmatch.IntOnMatch=DISABLE;
	cfgmatch.MatchChannel=0;
	cfgmatch.MatchValue=6.25E6-1;
	cfgmatch.ResetOnMatch=ENABLE;
	cfgmatch.StopOnMatch=DISABLE;
	TIM_ConfigMatch(instTmr0, &cfgmatch);

	//p3.25 a MAT0.0
	PINSEL_CFG_Type cfgP325={
			.Funcnum=2,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_TRISTATE,
			.Pinnum=25,
			.Portnum=3
	};
	PINSEL_ConfigPin(&cfgP325);

	//bajar banderas y cargar en NVIC
	TIM_ClearIntPending(instTmr0, TIM_MR0_INT);
	NVIC_ClearPendingIRQ(TIMER0_IRQn);
	NVIC_EnableIRQ(TIMER0_IRQn);

	return;
}

void cfgGpio(){
	/*
	 * p0.22 y p3.26 a GPIO (RED-BLUE), salida digital
	 */
	//p0.22 a GPIO
	PINSEL_CFG_Type cfgP022P326={
			.Funcnum=0,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_TRISTATE,
			.Pinnum=22,
			.Portnum=0};
	PINSEL_ConfigPin(&cfgP022P326);

	//p3.26 a GPIO
	cfgP022P326.Pinnum=26;
	cfgP022P326.Portnum=3;
	PINSEL_ConfigPin(&cfgP022P326);

	//salidas digitales
	GPIO_SetDir(0, 1<<22, 1);
	GPIO_SetDir(3, 1<<26, 1);

	//leds apagados
	GPIO_SetValue(0, 1<<22);
	GPIO_SetValue(3, 1<<26);

	return;
}

void cfgEint0(){
	/*
	 * EINT0, flanco decendente
	 */
	//iniciar bloque
	EXTI_Init();

	//p2.10 a EINT0, pull up
	PINSEL_CFG_Type cfgP210={
			.Funcnum=1,
			.OpenDrain=PINSEL_PINMODE_NORMAL,
			.Pinmode=PINSEL_PINMODE_PULLUP,
			.Pinnum=10,
			.Portnum=2};
	PINSEL_ConfigPin(&cfgP210);

	//EINT0, flanco decendente
	EXTI_InitTypeDef cfgeint={
			.EXTI_Line=EXTI_EINT0,
			.EXTI_Mode=EXTI_MODE_EDGE_SENSITIVE,
			.EXTI_polarity=EXTI_POLARITY_LOW_ACTIVE_OR_FALLING_EDGE
	};
	EXTI_Config(&cfgeint);

	//bajar banderas y cargar en NVIC
	EXTI_ClearEXTIFlag(EXTI_EINT0);
	NVIC_ClearPendingIRQ(EINT0_IRQn);
	NVIC_EnableIRQ(EINT0_IRQn);

	return;
}

void convol(){
	//eq a convol
	int aux0=0;

	for(int i=0;i<len;i++){
		*(buffConv+i)=i;
	}

	//habilitar TIMR0, toggle en GREEN
	GPIO_SetValue(0, 1<<22);
	GPIO_SetValue(3, 1<<26);
	TIM_Cmd(instTmr0, ENABLE);

	//pasar a fase final
	flgConv=false;
	flgFinal=true;

	return;
}

/*
 * xxx Handlers
 */
void ADC_IRQHandler(){
	//si se lleno el buffer de entrada
	if(pSignal==finSignal){
		//cargar ultimo dato y reiniciar puntero
		*pSignal=ADC_GetData(0);
		pSignal=buffSignal;

		//detener muestreo y pasar a fase de convolucion
		ADC_BurstCmd(instAdc, DISABLE);
		flgMuest=false;
		flgConv=true;
	}
	//sino
	else{
		//continuar sumando muestras
		*pSignal=ADC_GetData(0);
		pSignal++;
	}

	return;
}

void EINT0_IRQHandler(){
	//bajar banderas
	EXTI_ClearEXTIFlag(EXTI_EINT0);

	//si en fase muestreo
	if(flgMuest){
		//led BLUE on, disparar modo burst
		GPIO_ClearValue(3, 1<<26);
		ADC_BurstCmd(instAdc, ENABLE);
	}

	//si en fase final
	else if(flgFinal){
		//apagar TMR0, leds GREEN-RED on
		TIM_Cmd(instTmr0, DISABLE);

		instTmr0->EMR&=~1;
		GPIO_ClearValue(0, 1<<22);
		GPIO_SetValue(3, 1<<26);

		//reproducir el resultado
		flgFinal=false;
		flgPlay=true;
	}

	//si en fase de play
	else if(flgPlay){
		//led RED on
		GPIO_ClearValue(0, 1<<22);
		instTmr0->EMR|=1;
		GPIO_SetValue(3, 1<<26);

		//vover a la fase de muestreo
		flgPlay=false;
		flgMuest=true;
	}

	return;
}

/*
 * xxx Definir frec. de muestreo y cantidad de muestras (1024, 8KHz, timers)
 * Cargar respuesta del sistema (array, python)
 * Samplear y llenar el buffer
 * Dejar de muestrear y hacer la convolucion, guardarla en el buffer de salida
 * Requerir pulsado y reproducir la señal de salida
 * Reinicializar muestreo
 */
int main(void) {
	/*
	 * Core init
	 */
	SystemInit();

	/*
	 * Configurar ADC
	 */
	cfgAdc();

	/*
	 * Configurar TIMER0
	 */
	cfgTmr0();

	//apagar GREEN
	instTmr0->EMR|=1;

	/*
	 * Configurar LEDS de salida
	 */
	cfgGpio();

	/*
	 * Configurar EINT
	 */
	cfgEint0();

	//comenzar por la fase de muestrear señal (RED)
	GPIO_ClearValue(0, 1<<22);

	SYSTICK_Cmd(ENABLE);
	SYSTICK_InternalInit(100);
	SYSTICK_Cmd(DISABLE);

    while(1) {
    	//si se completo la fase de muestreo, realizar convolucion
        if(flgConv){
        	convol();
        }

        //en estado de play
        if(flgPlay){

        	//reproducir el resultado
        	for(int i=0;i<1024;i++){
        		playVar=*(buffConv+i);
        		while(SYSTICK_GetCurrentValue()!=0);
        	}
        }
    }
    return 0 ;
}
