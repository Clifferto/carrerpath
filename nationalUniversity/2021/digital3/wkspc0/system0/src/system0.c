/*
===============================================================================
 Name        : system0.c
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

#include <stdbool.h>

/*
 * Prototipos
 */
//funciones de configuracion
void cfgGpio();
void cfgSystick();

//handler de eint3 compartido con las interrupciones de gpio0 y 2
void EINT3_IRQHandler();
//handler del systick
void SysTick_Handler();

bool flReloadH=true;
unsigned char dcy=0;
unsigned int dth,dtl;

int main(void) {

    /*
     * Core init
     */
	SystemInit();

	//configurar perisfericos
	cfgGpio();
	cfgSystick();

	//iniciar dcy=0%, led off, systick off
	dcy=0;
	LPC_GPIO0->FIOPIN|=(1<<22);
	LPC_GPIO2->FIOPIN&=~(1<<4);

	SysTick->CTRL&=~1;

    while(1) {

    }
    return 0 ;
}

/*
 * Configuraciones de GPIO
 */
void cfgGpio(){
	//p0.22 gpio, pullup, digital output
	LPC_GPIO0->FIODIR|=(1<<22);

	//p2.4 gpio, pullup, digital output
	LPC_GPIO2->FIODIR|=(1<<4);

	//p2.13 gpio, pullup, digital input, enmascarado (defaut)
	LPC_PINCON->PINSEL4&=~(0b11<<26);
	LPC_PINCON->PINMODE4&=~(0b11<<26);
	LPC_GPIO2->FIODIR&=~(1<<13);
	//LPC_GPIO2->FIOMASK&=~(1<<13);

	//interrupcion por flanco de bajada, inicializando banderas
	LPC_GPIOINT->IO2IntClr|=(1<<13);
	LPC_GPIOINT->IO2IntEnF|=(1<<13);
	NVIC_SetPriority(EINT3_IRQn, 0);
	NVIC_EnableIRQ(EINT3_IRQn);

	return;
}

/*
 * Config del systick
 */
void cfgSystick(){
	/*
	 * (RELOAD + 1)/clk = dt
	 */
	//SysTick->LOAD=0x98967F;

	//valor por defecto de 10ms a 100MHz, se carga un ciclo despues de limpiar el timer
	SysTick->LOAD=SysTick->CALIB;

	//coreclock, activar interrupciones, systick on
	SysTick->CTRL|=(0b111);

	//limpiar la cuenta y bajar cualquier flag, escribiendo en STCURR
	SysTick->VAL=0x0FF;

	//cargar interrupcion al NVIC
	//NVIC_EnableIRQ(SysTick_IRQn);

	return;
}

/*
 * GPIO Handler
 */
void EINT3_IRQHandler(){

	//bajar flag
	LPC_GPIOINT->IO2IntClr|=(1<<13);

	//aumentar de a 10% el dutycycle
	dcy+=10;
	if(dcy>100) dcy=0;

	//si el dcy es 0% o 100%
	if(dcy==0 || dcy==100){
		//desactivar systick
		SysTick->CTRL&=~1;

		//si 0%, apagar el led R (logica negada)
		if(dcy==0){
			LPC_GPIO0->FIOPIN|=(1<<22);
			LPC_GPIO2->FIOPIN&=~(1<<4);

		}

		//si 100%, prender led R
		else{
			LPC_GPIO0->FIOPIN&=~(1<<22);
			LPC_GPIO2->FIOPIN|=(1<<4);
		}
	}

	//sino
	else{
		//calcular nuevos parametros para el systick
		dth=(unsigned int)(SysTick->CALIB*dcy/100);
		dtl=(unsigned int)(SysTick->CALIB*(100-dcy)/100);

		//si esta apagado el systick
		if((SysTick->CTRL&0x01)==0){
			//setear el tiempo en alto
			SysTick->LOAD=dth;
			flReloadH=false;

			//activar, limpiar banderas y recargar systick
			SysTick->CTRL|=1;
			SysTick->VAL=0x0FF;

			//led R, on
			LPC_GPIO0->FIOPIN&=~(1<<22);
			LPC_GPIO2->FIOPIN|=(1<<4);
		}
	}

	return;
}

/*
 * SysTick Handler
 */
void SysTick_Handler(){
	//toggle al led R
	LPC_GPIO0->FIOPIN^=(1<<22);
	LPC_GPIO2->FIOPIN^=(1<<4);

	//si hay que setear el tiempo en alto
	if(flReloadH){
		//setear tiempo en alto
		SysTick->LOAD=dth-1;
		//la proxima setear tiempo en bajo
		flReloadH=false;
	}
	//sino
	else{
		//setear tiempo en bajo
		SysTick->LOAD=dtl-1;
		//la prox setear tiempo en alto
		flReloadH=true;
	}

	/*
	 * RECARGAR SYSTICK Y BAJAR FLAG
	 */
	SysTick->VAL=0x0FF;

	return;
}
