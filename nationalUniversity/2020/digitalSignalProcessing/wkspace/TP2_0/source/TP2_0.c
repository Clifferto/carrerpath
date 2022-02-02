#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MK64F12.h"
#include "fsl_debug_console.h"
/* TODO: insert other include files here. */
#include "arm_math.h"
#include "firs.h"

/* TODO: insert other definitions and declarations here. */
//pit frec 60MHz
#define frec 60000000
//orden del filtro y tamaño de bloque
#define dataBlock 512
#define buffBlock 512
#define setSamp 5

//orden de filtros
#define lp8kTabs 288
#define hp8kTabs 310
#define bp8kTabs 124
#define bs8kTabs 320

#define lp16kTabs 146
#define hp16kTabs 300
#define bp16kTabs 124
#define bs16kTabs 316

//prototipos
void mostrarRate();
void GPIOA_IRQHANDLER();
void GPIOC_IRQHANDLER();
void PIT_CHANNEL_0_IRQHANDLER();
void ADC0_IRQHANDLER();
float timeCount(bool start, bool disInterr);


//Periodos para PIT 8KHz (125us), 16KHz (63us), 22KHz (45us), 44KHz (23us), 48KHz (21u)
const long rate[setSamp]={USEC_TO_COUNT(125u,frec),
					USEC_TO_COUNT(63u,frec),
					USEC_TO_COUNT(45u,frec),
					USEC_TO_COUNT(23u,frec),
					USEC_TO_COUNT(21u,frec)};
//punteros, limites y contador
long *pRate, *fRate;
char contRate=0;

//buffers de entrada y salida
q15_t buffIn[buffBlock], buffOut[buffBlock];
q15_t *pBuffIn, *pBuffOut, *fBuffIn, *fBuffOut;

//generar la fifo de estados para el fir
q15_t lp8kStatus[lp8kTabs+dataBlock-1];
q15_t hp8kStatus[hp8kTabs+dataBlock-1];
q15_t bp8kStatus[bp8kTabs+dataBlock-1];
q15_t bs8kStatus[bs8kTabs+dataBlock-1];

q15_t lp16kStatus[lp16kTabs+dataBlock-1];
q15_t hp16kStatus[hp16kTabs+dataBlock-1];
q15_t bp16kStatus[bp16kTabs+dataBlock-1];
q15_t bs16kStatus[bs16kTabs+dataBlock-1];

//instanciar firs
arm_fir_instance_q15 lp3k6s8k;
arm_fir_instance_q15 hp100s8k;
arm_fir_instance_q15 bp100a3k5s8k;
arm_fir_instance_q15 bs100bw40s8k;

arm_fir_instance_q15 lp3k6s16k;
arm_fir_instance_q15 hp100s16k;
arm_fir_instance_q15 bp100a3k5s16k;
arm_fir_instance_q15 bs50bw80s16k;

bool buffFull=false;
bool byPass=true;

//App
int main(void) {
	//Inicializa sistema
	//------------------------------------------------------------------------------------
	//BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
    BOARD_InitButtonsPins();
    BOARD_InitLEDsPins();
#ifndef BOARD_INIT_DEBUG_CONSOLE_PERIPHERAL
    BOARD_InitDebugConsole();
#endif
    PRINTF("Hello World\n");
    //------------------------------------------------------------------------------------
    //inicializa punteros y finales
    //nombre del array, equivale a la direccion del primer elemento del array
    pRate=rate; fRate=&rate[setSamp-1];

    pBuffIn=buffIn; fBuffIn=&buffIn[buffBlock-1];
    pBuffOut=buffOut; fBuffOut=&buffOut[buffBlock-1];

    //primer frec de muestreo a 8K
    PIT_SetTimerPeriod(PIT, kPIT_Chnl_0, rate[0]);
    mostrarRate();

    //inicializar fir
    //no hace falta castear los define
    arm_fir_init_q15(&lp3k6s8k, lp8kTabs, &lp8k, &lp8kStatus, dataBlock);
    arm_fir_init_q15(&hp100s8k, hp8kTabs, &hp8k, &hp8kStatus, dataBlock);
    arm_fir_init_q15(&bp100a3k5s8k, bp8kTabs, &bp8k, &bp8kStatus, dataBlock);
    arm_fir_init_q15(&bs100bw40s8k, bs8kTabs, &bs8k, &bs8kStatus, dataBlock);

    arm_fir_init_q15(&lp3k6s16k, lp16kTabs, &lp16k, &lp16kStatus, dataBlock);
	arm_fir_init_q15(&hp100s16k, hp16kTabs, &hp16k, &hp16kStatus, dataBlock);
	arm_fir_init_q15(&bp100a3k5s16k, bp16kTabs, &bp16k, &bp16kStatus, dataBlock);
	arm_fir_init_q15(&bs50bw80s16k, bs16kTabs, &bs16k, &bs16kStatus, dataBlock);

    while(1) {
    	//si se lleno el buffer de entrada
    	if(buffFull){
    		//dejar de tomar muestras, y reproducir señal filtrada
    		buffFull=false;

    		switch(byPass){
    			//no esta en bypass, filtrar las 512 muestras
    			case false:
    				;
//    				float At=timeCount(true,true);
//    				arm_fir_q15(&lp3k6s8k, &buffIn, &buffOut, dataBlock);
//    				arm_fir_q15(&hp100s8k, &buffIn, &buffOut, dataBlock);
//    				arm_fir_q15(&bp100a3k5s8k, &buffIn, &buffOut, dataBlock);
//    				arm_fir_q15(&bs100bw40s8k, &buffIn, &buffOut, dataBlock);

//    				arm_fir_q15(&lp3k6s16k, &buffIn, &buffOut, dataBlock);
//    				arm_fir_q15(&hp100s16k, &buffIn, &buffOut, dataBlock);
//    				arm_fir_q15(&bp100a3k5s16k, &buffIn, &buffOut, dataBlock);
					arm_fir_q15(&bs50bw80s16k, &buffIn, &buffOut, dataBlock);
//    				At=timeCount(false,true);
    				break;
				//sino, pasar las muestras al buffer de salida
    			default:
    				//pasar muestras al buffer de salida
    				for(int i=0;i<512;i++) buffOut[i]=buffIn[i];
    				//*pBuffOut=*pBuffIn;
    				break;
    		}
    	}
    }
    return 0 ;
}

//Cambiar colores del RGB segun la velocidad de muestreo
void mostrarRate(){
	//apagar leds
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

//Handler del GPIOA, configura e indica la velocidad de muestreo
void GPIOA_IRQHANDLER(){
	//bajar banderas, seleccionar y mostrar sample rate
	GPIO_PortClearInterruptFlags(GPIOA, 1u<<4u);

	if(pRate==fRate) pRate=rate;
	else pRate++;

	PIT_SetTimerPeriod(PIT, kPIT_Chnl_0, (int)(*pRate));

	//segun contRate prender los leds correspondientes
	mostrarRate();

	__DSB();
}

//Handler del GPIOC, alterna entre modo filtro y bypass
void GPIOC_IRQHANDLER(){
	//bajar banderas
	GPIO_PortClearInterruptFlags(GPIOC, 1u<<6u);

	byPass=!byPass;

	__DSB();
}

bool flag=true;
//Handler del PIT, toma una muestra o reproduce el buffer de salida
void PIT_CHANNEL_0_IRQHANDLER(){
	//bajar banderas
	PIT_ClearStatusFlags(PIT, kPIT_Chnl_0, kPIT_TimerFlag);

	//mostrar el bloque N-1
	DAC_SetBufferValue(DAC0, 0, *pBuffOut+2030);
	if(pBuffOut==fBuffOut) pBuffOut=buffOut;
	else pBuffOut++;

//	if(flag) {
//		flag=false;
//		timeCount(true, false);
//	}
	//llenar el bloque N
	ADC16_SetChannelConfig(ADC0, 0u, &ADC0_channelsConfig[0]);

	__DSB();
}

//Handler del ADC, comienza filtrado y pone el resultado en el DAC, muestra por muestra
void ADC0_IRQHANDLER(){
	//bajar banderas y pasar resultado al DAC
	ADC16_ClearStatusFlags(ADC0, kADC16_ChannelConversionDoneFlag);

	//recuperar muestra
	short aux=ADC16_GetChannelConversionValue(ADC0, 0)-2030;
	*pBuffIn=(q15_t)aux;

	//si se lleno, madar a filtrar
	if(pBuffIn==fBuffIn){
//		float At=timeCount(false, false);
//		flag=true;
		pBuffIn=buffIn;
		buffFull=true;
	}
	//sino, incrementar puntero
	else pBuffIn++;

	__DSB();
}

int cy0=0;
int cy=0;
uint32_t primask;
//calcular tiempo de ejecucion
float timeCount(bool start, bool disInterr){
	if(start){
		if(disInterr) primask=DisableGlobalIRQ();
		cy0=PIT_GetCurrentTimerCount(PIT, kPIT_Chnl_1);
		PIT_StartTimer(PIT, kPIT_Chnl_1);
		return 0;
	}
	else{
		cy=cy0-PIT_GetCurrentTimerCount(PIT, kPIT_Chnl_1);
		PIT_StopTimer(PIT, kPIT_Chnl_1);
		if(disInterr) EnableGlobalIRQ(primask);
		return (float)cy/(float)frec;
	}
}
