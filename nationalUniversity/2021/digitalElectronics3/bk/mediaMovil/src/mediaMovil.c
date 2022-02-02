/*
===============================================================================
 Name        : mediaMovil.c
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
int getData();
int promediar(int *set);
char outGpio0(int data);

bool buffFull=false;

int main(void) {

    //core init
	SystemInit();

	//gpio1 entrada flotante, digital

	//gpio0 salida digital

	//llenar buffer por 1er vez
	int buff[8];
	int media=0;

	//todo poner media en gpio0

	//para todos los promedios siguientes descartar el dato buff[0]
    while(1) {

    	//primer promedio
		if(!buffFull){

			//llenar buffer, transitorio
			for(int i=0;i<8;i++){
				*(buff+i)=getData();
			}

			buffFull=true;
		}

		//con buffer lleno, regimen
		else{

			for(int i=0;i<8;i++){

				//pop a la primer posicion
				if(i!=7){
					*(buff+i)=*(buff+i+1);
				}
				//colocar nuevo dato en ultima posicion
				else{
					*(buff+i)=getData();
				}
			}
		}

		//promediar valores del buffer
		media=promediar(buff);

		//resultado al gpio0
		outGpio0(media);

    }

    return 0 ;
}

int gpio1[20]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
unsigned char ptr=0;

int getData(){

	int datax=*(gpio1+ptr);

	ptr++;

	return datax;

//	//leer gpio1-L
//	//0b0000-0000-1111-1111-1100-0111-0001-0011
//	int aux0=(LPC_GPIO1->FIOPIN)&0x00FFC713;
//
//	//rearmar dato
//	int data=0;
//
//	//0b0000-0000-0000-0000-0000-0000-0000-00(11)
//	data|=(aux0)&0x3;
//
//	//0b0000-0000-0011-1111-1111-0001-1100-0100
//	aux0=aux0>>2;
//	//0b0000-0000-0000-0000-0000-0000-0000-0(1)00
//	data|=(aux0)&0x4;
//
//	//0b0000-0000-0000-0111-1111-1110-0011-1000
//	aux0=aux0>>3;
//	//0b0000-0000-0000-0000-0000-0000-00(11-1)000
//	data|=(aux0)&0x38;
//
//	//0b0000-0000-0000-0000-1111-1111-1100-0111
//	aux0=aux0>>3;
//	//0b0000-0000-0000-0000-(1111-1111-11)00-0000
//	data|=(aux0)&0xFFC0;
//
//	return data;


}

/*
 * Promedio de 8 valores
 */
int promediar(int *set){

	int acc=0;

	//acumular
	for(int i=0;i<8;i++){
		acc+=*(set+i);
	}

	//promediar
	return acc>>3;

}

/*
 * Dato short int a los 16 LSB validos del gpio0
 */
char outGpio0(int data){
	return 0;
}
