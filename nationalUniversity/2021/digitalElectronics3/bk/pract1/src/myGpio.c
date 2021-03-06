/*
 * myGpio.c
 *
 *  Created on: Aug 27, 2021
 *      Author: cliff
 */
#ifdef __USE_CMSIS
#include "LPC17xx.h"
#endif

#include "myGpio.h"

/*
 * Configurar gpio
 * Para la placa interesan los Gpio: 0, 1, 2L, 3H, 4H
 * >> Por default el pin es: salida, float
 */
unsigned char cfgGpio(unsigned char gpio,unsigned char pin,char dir,char pullmode){

	//seleccionar registros correctos de PINCON
	unsigned int *ppPinsel=PINSELBASE;
	unsigned int *ppPinmode=PINMODEBASE;

	switch(gpio){
		//para gpio2-L solo vale PINSEL/MODE2
		case 2:
			ppPinsel+=(2*gpio);
			ppPinmode+=(2*gpio);
			break;

		//para gpio3-H solo vale PINSEL/MODE7
		case 3:
			ppPinsel+=(2*gpio + 1);
			ppPinmode+=(2*gpio + 1);
			break;

		//para gpio4-H solo vale PINSEL/MODE9
		case 4:
			ppPinsel+=(2*gpio + 1);
			ppPinmode+=(2*gpio + 1);
			break;

		//para los demas vale PINSEL/MODE(x) si pin<16, sino PINSEL/MODE(x+1)
		default:
			ppPinsel+=(2*gpio + pin>15);
			ppPinmode+=(2*gpio + pin>15);
			break;
	}

	/*
	 * Funcion gpio digital
	 */
	*ppPinsel&=~(0b11<<(2*pin-32*(pin>15)));

	/*
	 * Pull mode (default: float)
	 */
	switch(pullmode){
		//pullup
		case 'u':
			*ppPinmode&=~(0b11<<(2*pin-32*(pin>15)));
			break;

		//pulldown
		case 'd':
			*ppPinmode|=(0b11<<(2*pin-32*(pin>15)));
			break;

		//float
		default:
			*ppPinmode|=(0b10<<(2*pin-32*(pin>15)));
			break;
	}

	//seleccionar registros correctos de GPIO, van saltando de a 32 bytes
	LPC_GPIO_TypeDef* insGpio=(LPC_GPIO_TypeDef *)(LPC_GPIO_BASE+(32*gpio));

	/*
	 * Data direction (default: salida)
	 */
	//input
	if(dir=='i'){
		insGpio->FIODIR&=~(1<<pin);
	}
	//output
	else{
		insGpio->FIODIR|=(1<<pin);
	}

	return 0;
}

/*
 * Retornar valor del pin p en el Gpio x (Gx.p)
 */
unsigned char getGpio(unsigned char gpio,unsigned char pin){

	//seleccionar registros correctos de GPIO, van saltando de a 32 bytes
	LPC_GPIO_TypeDef* insGpio=(LPC_GPIO_TypeDef *)(LPC_GPIO_BASE+(32*gpio));

	//guardar mascara actual
	unsigned int tmpMask=insGpio->FIOMASK;

	//crear mascara para ver solo el pin pedido
	insGpio->FIOMASK|=~(1<<pin);

	//leer valor por fiopin
	unsigned char stat=(insGpio->FIOPIN)>>pin;

	//restaurar mascara anterior
	insGpio->FIOMASK=tmpMask;

	return stat;
}

/*
 * Setear al valor val del pin p en el Gpio x (Gx.p = val)
 * >> Por default el pin es: 1
 */
void setGpio(unsigned char gpio,unsigned char pin,unsigned char val){

	//seleccionar registros correctos de GPIO, van saltando de a 32 bytes
	LPC_GPIO_TypeDef* insGpio=(LPC_GPIO_TypeDef *)(LPC_GPIO_BASE+(32*gpio));

	/*
	 * Escribir pin (default: 1)
	 */
	if(val==0){
		insGpio->FIOPIN&=~(1<<pin);
	}
	else{
		insGpio->FIOPIN|=(1<<pin);
	}

	return;
}

