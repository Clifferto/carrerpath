errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

CBLOCK 0x20
	veces
	on_off
ENDC

#define led_on BSF PORTB,RB3
#define led_off BCF PORTB,RB3

ORG 0
GOTO setup
ORG 4
GOTO interr
ORG 5

setup		CLRF PORTB				;Limpia LATCHES 
			BANKSEL ANSELH			;bk3
			CLRF ANSELH				;Desactiva entradas analogicas
			BCF STATUS,RP1			;bk1
			MOVLW 0xD7				
			MOVWF OPTION_REG		;TMR0 int clock, pre-scaler en 256
			CLRF TRISB				;PuertoB salida
			BCF STATUS,RP0			;bk0
			CLRF on_off				;Estado apagado
			MOVLW .10				;Cantidad de interrupciones
			MOVWF veces
			MOVLW .60				;Carga del TMR0
			MOVWF TMR0
			MOVLW 0xA0				;Habilita GIE e int por TMR0
			MOVWF INTCON
			GOTO main

main		NOP						;deja contar al timer0
			GOTO main

interr		DECFSZ veces			;Fueron 10 veces ?			
			GOTO int_out			
			GOTO blink
int_out		BCF INTCON,T0IF			;baja bandera
			BSF INTCON,T0IE			;habilita otra interr por TMR0
			MOVLW .60				;precarga el TMR0
			MOVWF TMR0
			RETFIE

blink		BTFSS on_off,0			;esta prendido o apagado?
			GOTO prender			;apagado
			GOTO apagar				;prendido

prender		led_on
			BSF on_off,0
			MOVLW .10
			MOVWF veces
			GOTO int_out			 	

apagar		led_off
			BCF on_off,0
			MOVLW .10
			MOVWF veces
			GOTO int_out			
END