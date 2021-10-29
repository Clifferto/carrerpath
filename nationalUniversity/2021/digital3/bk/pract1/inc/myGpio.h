/*
 * myGpio.h
 *
 *  Created on: Aug 26, 2021
 *      Author: cliff
 */

#ifndef MYGPIO_H_
#define MYGPIO_H_

// Macros
#define PINSELBASE 	(unsigned int *)(0x4002C000)
#define PINMODEBASE (unsigned int *)(0x4002C040)

// Prototipos
/*
 * Configurar gpio
 * Para la placa interesan los Gpio: 0, 1, 2L, 3H, 4H
 * >> Por default el pin es: salida, float
 */
unsigned char cfgGpio(unsigned char gpio,unsigned char pin,char dir,char pullmode);

/*
 * Retornar valor del pin p en el Gpio x (Gx.p)
 */
unsigned char getGpio(unsigned char gpio,unsigned char pin);

/*
 * Setear al valor val del pin p en el Gpio x (Gx.p = val)
 * >> Por default el pin es: 1
 */
void setGpio(unsigned char gpio,unsigned char pin,unsigned char val);

#endif /* MYGPIO_H_ */

