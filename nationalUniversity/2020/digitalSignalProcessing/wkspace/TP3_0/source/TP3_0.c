#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MK64F12.h"
#include "fsl_debug_console.h"

/* TODO: insert other include files here. */
#include "stdbool.h"
#include "arm_math.h"

/* TODO: insert other definitions and declarations here. */
//xxx DEF
#define frec 60000000
#define sizRate 5
#define dcOffset 2005
#define fftMaxPoints 2048

//xxx PROTOTIPOS
void mostrarRate();
void GPIOA_IRQHANDLER();
void GPIOC_IRQHANDLER();
void PIT_CHANNEL_0_IRQHANDLER();
void ADC0_IRQHANDLER();
void GPIOB_IRQHANDLER();
float timeCount(bool start, bool disInterr);
void setFftConfig();

//xxx PIT
//Periodos para PIT 8KHz (125us), 16KHz (63us), 22KHz (45us), 44KHz (23us), 48KHz (21u)
const long rate[sizRate]={USEC_TO_COUNT(125u,frec),
							USEC_TO_COUNT(63u,frec),
							USEC_TO_COUNT(45u,frec),
							USEC_TO_COUNT(23u,frec),
							USEC_TO_COUNT(21u,frec)};
//punteros, limites y contador
long *pRate, *fRate;
char contRate=0;

//xxx BUFFERS
//se usan bufferes de 2048 y se van cambiando los limites de sus punteros a 512, 1024 y 2048
q15_t buffIn[fftMaxPoints], buffOut[fftMaxPoints];
q15_t *pBuffIn, *pBuffOut, *fBuffIn, *fBuffOut;

//xxx INSTANCIAS
arm_rfft_instance_q15 fftModule;

//xxx PUNTOS DE LA FFT
short fftPointsConfig;
char fftScale;

//xxx BANDERAS BOOLEANAS
bool buffFull=false;
bool byPass=true;

//xxx APP
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
    BOARD_InitDEBUG_UARTPins();
    //------------------------------------------------------------------------------------

    //puntero y final para el sample rate
    //nombre del array, equivale a la direccion del primer elemento del array
    pRate=rate;
    fRate=&rate[sizRate-1];

    //iniciar con primer frec de muestreo a 8K
	PIT_SetTimerPeriod(PIT, kPIT_Chnl_0, rate[0]);
	//iniciar RGB
	mostrarRate();

	//punteros, buffers de entrada y salida
    pBuffIn=buffIn;
    pBuffOut=buffOut;

    //iniciar el sistema en 512 puntos
    fftPointsConfig=fftMaxPoints;
    setFftConfig();

    while(true) {
    	//si se lleno buffIn, procesar
    	if(buffFull){
    		buffFull=false;

    		//si esta en bypass, pasar buffIn a buffOut
    		if(byPass) for(int i=0;i<fftPointsConfig;i++) buffOut[i]=buffIn[i];
    		//SE INTENTO TRABAJAR SOLO CON PUNTEROS, PERO SIN EXITO PARA TODAS LAS FREC DE MUESTREO
    		//if(byPass) for(int i=0;i<fftPointsConfig;i++) (*(buffOut+i))=(*(buffIn+i));

    		//sino, hacer la fft del buffIn
			else{
				//medir tiempos, iniciar
				//timeCount(true, false);

				//ventana hanning, by elD4rius
				q15_t wHanning[fftPointsConfig];
				for(int i=0;i<fftPointsConfig;i++) wHanning[i]=(q15_t)(0.5f*32768.0f*(1.0f-cosf(2.0f*PI*i/fftPointsConfig)));

				//aplicar la ventana
				for(int i;i<fftPointsConfig;i++) buffIn[i]=(q15_t)(buffIn[i]*wHanning[i]);

				//crear buffers auxiliares
				q15_t buffFFT[2*fftPointsConfig];
				q15_t buffAux[fftPointsConfig];
				for(int i=0;i<fftPointsConfig;i++) buffAux[i]=buffIn[i];

				//calcular la FFT
				arm_rfft_q15(&fftModule, &buffAux, &buffFFT);

				//FFT UPSCALE (volver a q15)
				//512: <<8, 1024: <<9, 2048: <<10
				for(int i=0;i<2*fftPointsConfig;i++) buffFFT[i]=buffFFT[i]<<fftScale;

				//SE INTENTO ENVIAR LA FFT COMPLEJA A PYTHON Y CALCULAR SU MODULO, PERO SI EXITO
				//UART_WriteBlocking(UART0, &buffFFT, sizeof(buffFFT));

				//modulo de la fft al buffOut
				arm_cmplx_mag_q15(&buffFFT, &buffOut, fftPointsConfig);

				//EN MI CASO USANDO EL VISUAL ANALYZER COMO OSC PARA PC, MEJORA LA SALIDA CON ESTA DIVISION
				for(int i=0;i<fftPointsConfig;i++) buffOut[i]=buffOut[i]>>2;

				//medir tiempos, finalizar
				//float At=timeCount(false, false);

				//enviar a python el modulo
				UART_WriteBlocking(UART0, &buffOut, sizeof(buffOut));
				for(int t=0;t<10000;t++);
			}
    	}
    	//sino, continuar ingresando datos
		else;
    }
    return 0;
}

//Cambiar colores del RGB segun la frecuencia de muestreo
void mostrarRate(){
	//apagar leds
	GPIO_PortSet(GPIOB, 1u<<21u);
	GPIO_PortSet(GPIOB, 1u<<22u);
	GPIO_PortSet(GPIOE, 1u<<26u);

	switch(contRate){
		//ROJO: 8k
		case 0:
			GPIO_PortClear(GPIOB, 1u<<22u);
			break;
		//AMARILLO: 16k
		case 1:
			GPIO_PortClear(GPIOB, 1u<<22u);
			GPIO_PortClear(GPIOE, 1u<<26u);
			break;
		//VERDE: 24k
		case 2:
			GPIO_PortClear(GPIOE, 1u<<26u);
			break;
		//CYAN: 44k
		case 3:
			GPIO_PortClear(GPIOE, 1u<<26u);
			GPIO_PortClear(GPIOB, 1u<<21u);
			break;
		//AZUL: 48k
		default:
			GPIO_PortClear(GPIOB, 1u<<21u);
			break;
	}
	//hacer el contador ciclico
	if(contRate==4) contRate=0u;
	else contRate++;

	return;
}

//Configuracion ciclica segun los puntos de la FFT, bits a escalar y limites de punteros para los buffers
void setFftConfig(){
	//hacer ciclicos los puntos de la FFT, y los bits de escalado correspondientes
	if(fftPointsConfig>=fftMaxPoints) {
		fftPointsConfig=512;
		fftScale=8;
	}
	else {
		fftPointsConfig*=2;
		fftScale++;
	}

	//setear finales para los buffers de entrada y salida de datos
	pBuffIn=buffIn; pBuffOut=buffOut;
	fBuffIn=&buffIn[fftPointsConfig-1];
	fBuffOut=&buffOut[fftPointsConfig-1];

	//iniciar la instancia segun la cantidad de puntos
	arm_rfft_init_q15(&fftModule, fftPointsConfig, 0, 1);

	return;
}

//Handler del GPIOA, configura e indica la velocidad de muestreo
void GPIOA_IRQHANDLER(){
	//bajar banderas, seleccionar y mostrar sample rate
	GPIO_PortClearInterruptFlags(GPIOA, 1u<<4u);

	//hacer el buffer ciclico
	if(pRate==fRate) pRate=rate;
	else pRate++;

	//cambia frecuencia de muestreo
	PIT_SetTimerPeriod(PIT, kPIT_Chnl_0, (int)(*pRate));

	//segun contRate prender los leds correspondientes
	mostrarRate();

	__DSB();
}

//Handler del GPIOC, alterna entre modo fft y bypass
void GPIOC_IRQHANDLER(){
	//bajar banderas y cambiar de modo
	GPIO_PortClearInterruptFlags(GPIOC, 1u<<6u);

	byPass=!byPass;

	__DSB();
}

//Handler del GPIOB, configura los puntos de la FFT
void GPIOB_IRQHANDLER(){
	//bajar banderas
	GPIO_PortClearInterruptFlags(GPIOB, 1<<2);

	//reconfigurar el sistema para los puntos de la FFT
	setFftConfig();

	__DSB();
}

//Handler del PIT, pasa al DAC el buffer de salida y pone a convertir al ADC
void PIT_CHANNEL_0_IRQHANDLER(){
	//bajar banderas
	PIT_ClearStatusFlags(PIT, kPIT_Chnl_0, kPIT_TimerFlag);

	//mostrar el bloque N-1
	if(byPass) DAC_SetBufferValue(DAC0, 0, *pBuffOut+dcOffset);
	else DAC_SetBufferValue(DAC0, 0, *pBuffOut);

	//hacer ciclico el buffOut
	if(pBuffOut==fBuffOut) pBuffOut=buffOut;
	else pBuffOut++;

	//llenar el bloque N
	ADC16_SetChannelConfig(ADC0, 0u, &ADC0_channelsConfig[0]);

	__DSB();
}

//Handler del ADC, almacena valores en el buffIn y si se llena comienza procesamiento
void ADC0_IRQHANDLER(){
	//bajar banderas
	ADC16_ClearStatusFlags(ADC0, kADC16_ChannelConversionDoneFlag);

	//recuperar muestra, sin offset
	*pBuffIn=(q15_t)(ADC16_GetChannelConversionValue(ADC0, 0)-dcOffset);

	//si se lleno, mandar a procesar
	if(pBuffIn==fBuffIn){
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
	//si iniciar conteo
	if(start){
		//si deshabilita interrupciones, guarda vector actual
		if(disInterr) primask=DisableGlobalIRQ();
		//comienza a contar ciclos
		cy0=PIT_GetCurrentTimerCount(PIT, kPIT_Chnl_1);
		PIT_StartTimer(PIT, kPIT_Chnl_1);
		return 0;
	}
	else{
		//finaliza la cuenta
		cy=cy0-PIT_GetCurrentTimerCount(PIT, kPIT_Chnl_1);
		PIT_StopTimer(PIT, kPIT_Chnl_1);
		//si se dehabilitaron las int, recuperar estado y volver a habilitarlas
		if(disInterr) EnableGlobalIRQ(primask);
		//calcular tiempo de procesamiento
		return (float)cy/(float)frec;
	}
}
