################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include inc/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: emisor.axf

# Tool invocations
emisor.axf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MCU Linker'
	arm-none-eabi-gcc -nostdlib -L"/home/dario/Documents/MCUXpresso_11.4.1_6260/workspace/CMSISv2p00_LPC17xx/Debug" -L"/home/dario/Documents/MCUXpresso_11.4.1_6260/workspace/CMSISv2p00_LPC17xx/Drivers/src" -Xlinker -Map="emisor.map" -Xlinker --cref -Xlinker --gc-sections -Xlinker -print-memory-usage -mcpu=cortex-m3 -mthumb -T "emisor_Debug.ld" -o "emisor.axf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(EXECUTABLES)$(OBJS)$(C_DEPS) emisor.axf
	-@echo ' '

post-build:
	-@echo 'Performing post-build steps'
	-arm-none-eabi-size "emisor.axf"; # arm-none-eabi-objcopy -v -O binary "emisor.axf" "emisor.bin" ; # checksum -p LPC1769 -d "emisor.bin";
	-@echo ' '

.PHONY: all clean dependents post-build

-include ../makefile.targets
