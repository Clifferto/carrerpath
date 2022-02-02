################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../inc/nRF24L01.c \
../inc/pin_conf.c \
../inc/ssp_spi.c \
../inc/timers.c 

OBJS += \
./inc/nRF24L01.o \
./inc/pin_conf.o \
./inc/ssp_spi.o \
./inc/timers.o 

C_DEPS += \
./inc/nRF24L01.d \
./inc/pin_conf.d \
./inc/ssp_spi.d \
./inc/timers.d 


# Each subdirectory must supply rules for building sources it contributes
inc/%.o: ../inc/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -DDEBUG -D__CODE_RED -DCORE_M3 -D__USE_CMSIS=CMSISv2p00_LPC17xx -D__LPC17XX__ -D__REDLIB__ -I"/home/dario/Documents/MCUXpresso_11.4.1_6260/workspace/emisor/inc" -I"/home/dario/Documents/MCUXpresso_11.4.1_6260/workspace/CMSISv2p00_LPC17xx/inc" -I"/home/dario/Documents/MCUXpresso_11.4.1_6260/workspace/CMSISv2p00_LPC17xx/Drivers/inc" -O0 -fno-common -g3 -Wall -c -fmessage-length=0 -fno-builtin -ffunction-sections -fdata-sections -fmerge-constants -fmacro-prefix-map="../$(@D)/"=. -mcpu=cortex-m3 -mthumb -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


