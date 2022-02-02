/*
===============================================================================
 Name        : test_spi.c
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

#include <stdio.h>

#include "pin_conf.h"
#include "ssp_spi.h"
#include "timers.h"
#include "nRF24L01.h"
#include "lpc17xx_exti.h"
#include "lpc17xx_pinsel.h"
#include "lpc17xx_adc.h"
#include "lpc17xx_dac.h"

#define BUFFER_LENGTH  PAYLOAD_WIDTH

//xxx Vars---
uint8_t val0[5];
uint8_t val1[5];

uint8_t status;
uint8_t conf[1];
uint8_t buffer_tx[BUFFER_LENGTH];
uint8_t count_loss[1] = {0};
uint8_t count_error;


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
	ADC_Init(LPC_ADC, 16E3);

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
	ADC_IntConfig(LPC_ADC, ADC_ADINTEN0, ENABLE);

	//bajar banderas y cargar en NVIC
	NVIC_ClearPendingIRQ(ADC_IRQn);
	//bajar prioridad de interrupcion
	NVIC_SetPriority(ADC_IRQn, 1);
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

void cfgDac(void){
	//p0.26 a AOUT (habilitar acceso a registros)
	PINSEL_CFG_Type cfgP026={
		.OpenDrain=PINSEL_PINMODE_NORMAL,
		.Pinmode=PINSEL_PINMODE_TRISTATE,
		.Funcnum=2,
		.Pinnum=26,
		.Portnum=0
	};
	PINSEL_ConfigPin(&cfgP026);

	//iniciar dac, maxima velocidad 1MHz
	DAC_Init(LPC_DAC);
	DAC_SetBias(LPC_DAC, 0);

	return;
}


volatile unsigned int acc0=0;
volatile unsigned char samp=0;
volatile unsigned char n=2;
unsigned char pass=0xAA;
/*
 * xxx Handlers
 */
void ADC_IRQHandler(){
	//incrementar contador de muestras
	samp++;

	//leer valor del adc
	res0=ADC_ChannelGetData(LPC_ADC, 0);

	//acumular valor de conversion y bajar banderas
	acc0+=res0;

	//promediar cada n muestras
	if(samp==n){
		acc0>>=1;

		//pasar valor al DAC
		DAC_UpdateValue(LPC_DAC, (acc0>>2)&0x3FF);

		//armar paquete
		unsigned char msb=(unsigned char)((acc0>>8)&0xFF);
		unsigned char lsb=(unsigned char)(acc0&0xFF);
		unsigned char pckt[]={pass,msb,lsb};

		//enviar a nRF
		nrf24_transmit_payload(pckt,sizeof(pckt));

		//reiniciar variables
		acc0=0;
		samp=0;
	}

	return;
}

int main(void) {
    /*
     * Core init
     */
	SystemInit();

	cfgAdc();
	cfgDac();

	//originales
	confPin();
	initLEDPins();
	confSpi();
	confTimer1();
	confTimer2();
	nrf24_init(1);
	status=nrf24_status();
	nrf24_writeToNrf(R, RF24_TX_ADDR, val0, 5);
	confIntExt();

//	for(int i =0;i<BUFFER_LENGTH;i++){
//		buffer_tx[i] = i;
//	}
	//nrf24_listen_payload();

	//disparo por hw, burst mode a 8KHz, LA FUNCION HACE EL DISPARO
	ADC_BurstCmd(LPC_ADC, ENABLE);

	while(1) {
    	//nrf24_transmit_payload(buffer_tx,BUFFER_LENGTH);
	}

    return 0 ;
}

void EINT0_IRQHandler(void) {
	uint8_t aux0[1];
	EXTI_ClearEXTIFlag(0);
	uint8_t status= nrf24_status();
	if(status & RF24_MASK_MAX_RT){
		//error de retransmicion
		nrf24_writeToNrf(R, RF24_OBSERVE_TX, count_loss , sizeof(count_loss));
		aux0[0] = status | RF24_MASK_MAX_RT;
		nrf24_writeToNrf(W, RF24_STATUS, aux0 , sizeof(aux0)); //limpio el flag MAX_RT (miximo de retrasnmiciones)
		//green off
		GPIO_SetValue(3, 1<<25);
		LED_RED_TOGGLE();
	}
	else if(status & (RF24_MASK_TX_DS|RF24_MASK_RX_DR)){
		//transmicion exitosa
		aux0[0] = status | RF24_MASK_TX_DS | RF24_MASK_RX_DR;
		nrf24_writeToNrf(W, RF24_STATUS, aux0 , sizeof(aux0)); //limpio el flag TX_DS y RX_DR
		//red off
		GPIO_SetValue(0, 1<<22);
		LED_GREEN_TOGGLE();
	}
}
