################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../device/system_MK64F12.c 

OBJS += \
./device/system_MK64F12.o 

C_DEPS += \
./device/system_MK64F12.d 


# Each subdirectory must supply rules for building sources it contributes
device/%.o: ../device/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -DCPU_MK64FN1M0VLL12 -DARM_MATH_CM4 -DCPU_MK64FN1M0VLL12_cm4 -DFSL_RTOS_BM -DSDK_OS_BAREMETAL -DSDK_DEBUGCONSOLE=0 -DCR_INTEGER_PRINTF -DPRINTF_FLOAT_ENABLE=1 -DSERIAL_PORT_TYPE_UART=1 -D__MCUXPRESSO -D__USE_CMSIS -DDEBUG -D__REDLIB__ -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/drivers" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/CMSIS" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/component/uart" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/utilities" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/component/serial_manager" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/device" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/component/lists" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/CMSIS" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/drivers" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/component/uart" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/utilities" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/component/lists" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/component/serial_manager" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/device" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/board" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0/source" -I"/media/cliff/Desk/UNC/DSP/wkspace/TP1_0" -O0 -fno-common -g3 -Wall -c -ffunction-sections -fdata-sections -ffreestanding -fno-builtin -fmerge-constants -fmacro-prefix-map="../$(@D)/"=. -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -D__REDLIB__ -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

