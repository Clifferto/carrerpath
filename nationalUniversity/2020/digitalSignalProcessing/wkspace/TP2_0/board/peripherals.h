/***********************************************************************************************************************
 * This file was generated by the MCUXpresso Config Tools. Any manual edits made to this file
 * will be overwritten if the respective MCUXpresso Config Tools is used to update this file.
 **********************************************************************************************************************/

#ifndef _PERIPHERALS_H_
#define _PERIPHERALS_H_

/***********************************************************************************************************************
 * Included files
 **********************************************************************************************************************/
#include "fsl_common.h"
#include "fsl_adc16.h"
#include "fsl_dac.h"
#include "fsl_gpio.h"
#include "fsl_port.h"
#include "fsl_pit.h"

#if defined(__cplusplus)
extern "C" {
#endif /* __cplusplus */

/***********************************************************************************************************************
 * Definitions
 **********************************************************************************************************************/
/* Definitions for BOARD_InitPeripherals functional group */
/* Alias for ADC0 peripheral */
#define ADC0_PERIPHERAL ADC0
/* ADC0 interrupt vector ID (number). */
#define ADC0_IRQN ADC0_IRQn
/* ADC0 interrupt handler identifier. */
#define ADC0_IRQHANDLER ADC0_IRQHandler
/* Channel 0 (SE.0) conversion control group. */
#define ADC0_CH0_CONTROL_GROUP 0
/* Alias for DAC0 peripheral */
#define DAC0_PERIPHERAL DAC0
/* Alias for GPIOA peripheral */
#define GPIOA_GPIO GPIOA
/* Alias for PORTA */
#define GPIOA_PORT PORTA
/* GPIOA interrupt vector ID (number). */
#define GPIOA_IRQN PORTA_IRQn
/* GPIOA interrupt handler identifier. */
#define GPIOA_IRQHANDLER PORTA_IRQHandler
/* Alias for GPIOC peripheral */
#define GPIOC_GPIO GPIOC
/* Alias for PORTC */
#define GPIOC_PORT PORTC
/* GPIOC interrupt vector ID (number). */
#define GPIOC_IRQN PORTC_IRQn
/* GPIOC interrupt handler identifier. */
#define GPIOC_IRQHANDLER PORTC_IRQHandler
/* BOARD_InitPeripherals defines for PIT */
/* Definition of peripheral ID. */
#define PIT_PERIPHERAL PIT
/* Definition of clock source. */
#define PIT_CLOCK_SOURCE kCLOCK_BusClk
/* Definition of clock source frequency. */
#define PIT_CLK_FREQ 60000000UL
/* Definition of ticks count for channel 0 - deprecated. */
#define PIT_0_TICKS 7499U
/* Definition of ticks count for channel 1 - deprecated. */
#define PIT_1_TICKS 59999999U
/* PIT interrupt vector ID (number) - deprecated. */
#define PIT_0_IRQN PIT0_IRQn
/* PIT interrupt handler identifier - deprecated. */
#define PIT_0_IRQHANDLER PIT0_IRQHandler
/* Definition of channel number for channel 0. */
#define PIT_CHANNEL_0 kPIT_Chnl_0
/* Definition of channel number for channel 1. */
#define PIT_CHANNEL_1 kPIT_Chnl_1
/* Definition of ticks count for channel 0. */
#define PIT_CHANNEL_0_TICKS 7499U
/* Definition of ticks count for channel 1. */
#define PIT_CHANNEL_1_TICKS 59999999U
/* PIT interrupt vector ID (number). */
#define PIT_CHANNEL_0_IRQN PIT0_IRQn
/* PIT interrupt handler identifier. */
#define PIT_CHANNEL_0_IRQHANDLER PIT0_IRQHandler

/***********************************************************************************************************************
 * Global variables
 **********************************************************************************************************************/
extern adc16_channel_config_t ADC0_channelsConfig[1];
extern const adc16_config_t ADC0_config;
extern const adc16_channel_mux_mode_t ADC0_muxMode;
extern const adc16_hardware_average_mode_t ADC0_hardwareAverageMode;
extern const dac_config_t DAC0_config;
extern const pit_config_t PIT_config;

/***********************************************************************************************************************
 * Initialization functions
 **********************************************************************************************************************/
void BOARD_InitPeripherals(void);

/***********************************************************************************************************************
 * BOARD_InitBootPeripherals function
 **********************************************************************************************************************/
void BOARD_InitBootPeripherals(void);

#if defined(__cplusplus)
}
#endif

#endif /* _PERIPHERALS_H_ */
