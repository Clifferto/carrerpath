/*
===============================================================================
 Name        : pract1.c
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

#include "myGpio.h"

/*
 * Proceso
 */
int main(void) {

	/*
	 * Init core
	 */
	SystemInit();

	//gpio a digital output
	cfgGpio(0, 22, 'o', 'x');
	cfgGpio(3, 25, 'o', 'x');
	cfgGpio(3, 26, 'o', 'x');

	//led off
	setGpio(0, 22, 1);
	setGpio(3, 25, 1);
	setGpio(3, 26, 1);

	// Force the counter to be placed into memory
	volatile static unsigned int i = 0 ;

	// Blink led
	while(1) {

		//led R
		setGpio(0, 22, 0);
		setGpio(3, 25, 1);
		setGpio(3, 26, 1);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led G
		setGpio(0, 22, 1);
		setGpio(3, 25, 0);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led B
		setGpio(3, 25, 1);
		setGpio(3, 26, 0);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led RG
		setGpio(3, 26, 1);
		setGpio(0, 22, 0);
		setGpio(3, 25, 0);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led GB
		setGpio(0, 22, 1);
		setGpio(3, 26, 0);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led BR
		setGpio(3, 25, 1);
		setGpio(0, 22, 0);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led RGB
		setGpio(3, 25, 0);

		//delay
		while(i!=1024*1000) i++;
		i=0;

		//led OFF
		setGpio(0, 22, 1);
		setGpio(3, 25, 1);
		setGpio(3, 26, 1);

		//delay
		while(i!=1024*1000) i++;
		i=0;
	}

    return 0;
}

