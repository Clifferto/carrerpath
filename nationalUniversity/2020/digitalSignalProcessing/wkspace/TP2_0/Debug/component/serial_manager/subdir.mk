################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../component/serial_manager/serial_manager.c \
../component/serial_manager/serial_port_uart.c 

OBJS += \
./component/serial_manager/serial_manager.o \
./component/serial_manager/serial_port_uart.o 

C_DEPS += \
./component/serial_manager/serial_manager.d \
./component/serial_manager/serial_port_uart.d 


# Each subdirectory must supply rules for building sources it contributes
component/serial_manager/%.o: ../component/serial_manager/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -DCPU_MK64FN1M0VLL12 -DARM_MATH_CM4 -DCPU_MK64FN1M0VLL12_cm4 -DFSL_RTOS_BM -DSDK_OS_BAREMETAL -DSERIAL_PORT_TYPE_UART=1 -DSDK_DEBUGCONSOLE=0 -DCR_INTEGER_PRINTF -DPRINTF_FLOAT_ENABLE=1 -D__MCUXPRESSO -D__USE_CMSIS -DDEBUG -D__REDLIB__ -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/CMSIS" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/drivers" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/component/uart" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/component/lists" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/component/serial_manager" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/device" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/utilities" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/board" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/source" -I/media/cliff/Desk/UNC/DSP/wkspace/sdk/CMSIS/Include -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/drivers" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/device" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/CMSIS" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/component/uart" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/utilities" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/component/serial_manager" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP2_0/component/lists" -O0 -fno-common -g3 -Wall -c -ffunction-sections -fdata-sections -ffreestanding -fno-builtin -fmerge-constants -fmacro-prefix-map="../$(@D)/"=. -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -D__REDLIB__ -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


