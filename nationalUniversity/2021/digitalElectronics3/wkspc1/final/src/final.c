/*
===============================================================================
 Name        : ED3_proyecto_final_LPC.c
 Author      : $(author)
 Version     :
 Copyright   : $(copyright)
 Description : (TX) Graba el mensaje, tiene una clave configurable, envia los datos
               a través de modulo nrf, interfaz con usuario (Script MATLAB)
			   mediante UART.
===============================================================================
*/

#ifdef __USE_CMSIS
#include "LPC17xx.h"
#include "lpc17xx_uart.h"
#include "lpc17xx_gpio.h"
#include "lpc17xx_pinsel.h"
#include "lpc17xx_adc.h"
#include "lpc17xx_timer.h"
#include "lpc17xx_dac.h"
#include "lpc17xx_rit.h"
#endif

#include <cr_section_macros.h>

//Macros---
#define MULVAL 14
#define DIVADDVAL 2
#define Ux_FIFO_EN (1<<0)
#define Rx_FIFO_RST (1<<1)
#define Tx_FIFO_RST (1<<2)
#define DLAB_BIT (1<<7)
#define Rx_RDA_INT (1<<0)
#define MASK_INT_ID (0xE)
#define MASK_RDA_INT (2)
//seleccion de UART
#define UARTx (LPC_UART_TypeDef*) LPC_UART2_BASE
#define LED_RED_TOGGLE() LPC_GPIO0 -> FIOPIN ^= (1 << 22)
#define LED_BLUE_TOGGLE() LPC_GPIO3 -> FIOPIN ^= (1 << 26)
#define LED_GREEN_TOGGLE() LPC_GPIO3 -> FIOPIN ^= (1 << 25)
#define IN_BUFF_LEN 12000u

//Variables y punteros---
uint32_t currentKey;
uint8_t readyToLoad, flagAdcDone;
uint8_t cmd[3];
uint16_t inBuff[IN_BUFF_LEN];
uint16_t *pInBuff = inBuff;

//xxx Prototipos---
void initUARTx(void);
void initLEDPins(void);
void initADC(void);
void initTMR0(void);
void initTMR2(void);
void blinkRedLed(void);
void blinkGreenLed(void);
void blinkBlueLed(void);
void delay_ms(int);
//opcionales
void initDAC(void);
void initRit();

/*
 * xxx Main loop
 */
int main(void) {
	/* System Clock Init */
	SystemInit();

	/* Init */
	initLEDPins();
	initUARTx();
	initADC();
	initTMR0();
	initTMR2();
	//opcionales
	initRit();
	initDAC();

	/* Algorithm */
	//Default key
    currentKey = 0x12345678; 
    readyToLoad = 1;

	while(1){
		//Listen dot commands
		UART_Receive(UARTx, (uint8_t *)cmd, sizeof(cmd), BLOCKING);

		/*
		* Decide que comando ejecutar:
		* '.g': Get current Key
		* '.s': Set a new Key
		* '.r': Record and send message
		* '.t': Transmit message by SPI (falta)
		*/
		//if dot command
		if (cmd[0] == '.') {
			//recognize command
			switch (cmd[1]) {
				//getkey
				case 'g':
					//Get current key, and blink red led
					UART_Send(UARTx, (uint8_t *)&currentKey, sizeof(currentKey), BLOCKING);
					blinkRedLed();
					break;
				//setkey
				case 's':
					//Set a new key, and blink green led
					UART_Send(UARTx, &readyToLoad, sizeof(readyToLoad), BLOCKING);
					UART_Receive(UARTx, (uint8_t *)&currentKey, sizeof(currentKey), BLOCKING);
					blinkGreenLed();
					break;
				//record
				case 'r':
					flagAdcDone=0;
					//Record a 2sec message, and blink blue led
					TIM_ResetCounter(LPC_TIM0);
					TIM_Cmd(LPC_TIM0, ENABLE);
					while(!flagAdcDone) {};

					TIM_Cmd(LPC_TIM0, DISABLE);
					blinkBlueLed();

					//rit on, start playing signal through DAC
					//RIT_Cmd(LPC_RIT, ENABLE);
					break;
			}
			//clean command buffer
			cmd[0]=0;
			cmd[1]=0;
			cmd[2]=0;
		}
	};
    return 0 ;
}

/*
 * Config UART
 * * BaudRate= ~115200(114882) (si PCLK=25MHz, lo es por defecto)
 * * P0.2 TX0
 * * P0.3 RX0
 */
void initUARTx(void)
{
	//p0.10 y p0.11 to UART2, pull-up
	PINSEL_CFG_Type cfgTXRX={
		.Funcnum=1,
		.Pinnum=10,
		.Portnum=0
	};
	PINSEL_ConfigPin(&cfgTXRX);

	cfgTXRX.Pinnum=11;
	PINSEL_ConfigPin(&cfgTXRX);

	//UART 115200 bauds, 8 bits data, 1 stop bit, no parity
	LPC_SC->PCONP |= 1<<24; //enciendo UART2 (por default encendido)

	LPC_UART2->LCR = 3|DLAB_BIT ; //8 bits, sin paridad, 1 Stop bit y DLAB enable
	//set baud rate
	LPC_UART2->DLL = 12;
	LPC_UART2->DLM = 0;
	LPC_UART2->FDR = (MULVAL<<4)|DIVADDVAL; //MULVAL=15(bits - 7:4), DIVADDVAL=2(bits - 3:0)

	/*
	 * Block divisor latches
	 */
	LPC_UART2->LCR &= ~(DLAB_BIT); //desactivando DLAB lockeamos los divisores para el Baudrate

	LPC_UART2->FCR |= Ux_FIFO_EN|Rx_FIFO_RST|Tx_FIFO_RST;

	//	//UART 115200 bauds, 8 bits data, 1 stop bit, no parity
	//	UART_CFG_Type cfgUart;
	//	cfgUart.Baud_rate = 115200;
	//	cfgUart.Databits = UART_DATABIT_8;
	//	cfgUart.Parity = UART_PARITY_NONE;
	//	cfgUart.Stopbits = UART_STOPBIT_1;
	//	UART_Init(UARTx, &cfgUart);
}

/*
 * Config LEDs
 * * P0.22 Red
 * * P3.26 Blue
 * * P3.25 Green
 */
void initLEDPins(void) {

	const uint8_t ledNum[] = {22, 26, 25};
	const uint8_t ledPort[] = {0, 3, 3};

	PINSEL_CFG_Type ledPin;
	ledPin.Pinmode = PINSEL_PINMODE_PULLUP;
	ledPin.Funcnum = 0;

	for (int i = 0;i < 3; i++) {
		ledPin.Pinnum = ledNum[i];
		ledPin.Portnum = ledPort[i];
		PINSEL_ConfigPin(&ledPin);
		GPIO_SetDir(ledPort[i], 1<<ledNum[i], 1);
	}

	//set higth level (LEDS OFF)
	GPIO_SetValue(0, 1<<22);
	GPIO_SetValue(3, 1<<25);
	GPIO_SetValue(3, 1<<26);
}

/*
 * Config ADC
 * * P0.23 to AD0.0
 * * pull-off
 */
void initADC(void) {

	PINSEL_CFG_Type ADC_pin;
	ADC_pin.Pinnum = 23;
	ADC_pin.Portnum = 0;
	ADC_pin.Funcnum = 1;
	ADC_pin.Pinmode = 2; //TRISTATE

	PINSEL_ConfigPin(&ADC_pin);

	//conf del ADC
	LPC_SC-> PCLKSEL0 |= (3 << 24);  // CCLK/8 = 100Mhz/8 = 12.5 MHz
	ADC_Init(LPC_ADC, 192307); //enciende PCONP, da PDN = 1 y carga un CLKDIV medio choto
	ADC_ChannelCmd(LPC_ADC, 0, ENABLE); //selecciona bits SEL, o sea el canal habiliado, recordar que es modo hardware
	//ADC_BurstCmd(LPC_ADC, DISABLE); //configura BURST de ADCR
	ADC_StartCmd(LPC_ADC, ADC_START_ON_MAT01); //configura START de ADCR
	ADC_EdgeStartConfig(LPC_ADC, ADC_START_ON_FALLING); //configura EDGE de ADCR
	ADC_IntConfig(LPC_ADC, ADC_ADGINTEN, SET); //configura individualmente las int por canales o la global

	NVIC_ClearPendingIRQ(ADC_IRQn);
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
}

/*
 * Config TMR0
 * * Recordar F_MRx = 2*prom*F_s(deseada)
 * * F_s = 3 KHz, prom = 8 -> F_MRx = 48 KHz -> 20.8us
 * * Con 12us -> F_s(real)= 47.619 KHz
 */
void initTMR0(void) {

	LPC_SC -> PCONP |= (1 << 1); //enciende TMR0 (recordar que ya lo esta por defecto);
	//LPC_SC -> PCLKSEL0 |= (1 << 2); //CCLK/1
	LPC_TIM0 -> EMR |= (3 << 6); //toglear (funcion 3) EM0 (MAT0.1)
	LPC_TIM0 -> PR = 25-1; //si PCLK = 25MHz entonces con ese PR se logra resolución de 1us
	LPC_TIM0 -> MR1 = 21-1;
	LPC_TIM0 -> MCR |= (2 << 3); //solo resetar cuando se llegue match, no int, no stop
	//LPC_TIM0 -> TCR = 3; //enable y reset en 1
	//LPC_TIM0 -> TCR &= ~(2); //quito el reset
}

void initTMR2(void) {
	/*
	 * Temporizador de resolucion de 1ms
	 */
	TIM_TIMERCFG_Type timer2_conf;

	//timer2 config
	timer2_conf.PrescaleOption = TIM_PRESCALE_USVAL;
	timer2_conf.PrescaleValue  = 1000; //resolucion de 1ms (si PCLK= 25MHz)

	TIM_Init(LPC_TIM2, TIM_TIMER_MODE, &timer2_conf); //TIM_Init no le da enable
}

//suma para promediar
unsigned int acc0=0;
unsigned char samp=0;
unsigned char n=8;

//xxx
void ADC_IRQHandler(void) {
	volatile uint16_t ADC_value;
	ADC_value = (ADC_GlobalGetData(LPC_ADC) >> 4) & 0xFFF;

	//aumentar numero de muestra
	samp++;

	//acumular
	acc0+=ADC_value;

	/*
	 * todo Correjir velocidad de reproduccion
	 */
	//si se cumplen las n muestras
	if(samp>=n){
		//promediar y actualizar dac
		acc0>>=3;
		DAC_UpdateValue(LPC_DAC, (acc0>>2)&0x3FF);

		//reiniciar variables
		acc0=0;
		samp=0;
	}

	/*
	 * todo Reemplazar por logica del buffer
	 */

//	*pInBuff = ADC_value;
//
//	if(pInBuff == &inBuff[IN_BUFF_LEN-1]) {
//		pInBuff = inBuff;
//		flagAdcDone = 1;
//	}
//	else {
//		pInBuff++;
//		flagAdcDone = 0;
//	}
}

void blinkRedLed(void) {
	//LED_RED_TOGGLE();
	LPC_GPIO0->FIOPIN^=(1<<22);
	delay_ms(100);
	//LED_RED_TOGGLE();
	LPC_GPIO0->FIOPIN^=(1<<22);
}

void blinkGreenLed(void) {
	//LED_GREEN_TOGGLE();
	LPC_GPIO3->FIOPIN^=(1<<25);
	delay_ms(100);
	//LED_GREEN_TOGGLE();
	LPC_GPIO3->FIOPIN^=(1<<25);
}

void blinkBlueLed(void) {
	//LED_BLUE_TOGGLE();
	LPC_GPIO3->FIOPIN^=(1<<26);
	delay_ms(100);
	//LED_BLUE_TOGGLE();
	LPC_GPIO3->FIOPIN^=(1<<26);
}

void delay_ms(int time) {
	TIM_ResetCounter(LPC_TIM2);
	TIM_Cmd(LPC_TIM2, ENABLE);
	while (LPC_TIM2 -> TC < time); //en [ms]
	TIM_Cmd(LPC_TIM2, DISABLE);
}

void initDAC(void){
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

void initRit(){
	//inicializar timer, por defecto habilitado
	RIT_Init(LPC_RIT);
	//apagar para config
	RIT_Cmd(LPC_RIT, DISABLE);

	//configurar para 166ms
	RIT_TimerConfig(LPC_RIT, 166);
	//pasar a micro segundos
	LPC_RIT->RICOMPVAL=(unsigned int)((LPC_RIT->RICOMPVAL)/1000);

	//limpiar pending y cargar en NVIC
	NVIC_ClearPendingIRQ(RIT_IRQn);
	NVIC_EnableIRQ(RIT_IRQn);

	return;
}

void RIT_IRQHandler(){
	//bajar banderas
	RIT_GetIntStatus(LPC_RIT);

	//actualizar valor del dac
	DAC_UpdateValue(LPC_DAC, ((*pInBuff)>>4)&0x3FF);

	//incrementar puntero del buffer
	if(pInBuff==&inBuff[IN_BUFF_LEN-1]){
		pInBuff=inBuff;

		//apagar timer
		RIT_Cmd(LPC_RIT, DISABLE);
	}
	else pInBuff++;

	return;
}
