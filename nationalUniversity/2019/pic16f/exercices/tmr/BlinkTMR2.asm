errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

CBLOCK 0x20
	on_off
	veces
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
			CLRF ANSELH				;Entradas AN off
			BCF STATUS,RP1			;bk1
			CLRF TRISB				;PB out
			CLRF PR2				;TMR2 desborda en 0
			MOVLW 0xC0				;Habilita GIE y PEIE
			MOVWF INTCON			;-------------------
			BSF PIE1,TMR2IE			;Habilita interrupcion por timer2
			BCF STATUS,RP0			;bk0
			MOVLW .125				;Precarga timer2
			MOVWF TMR2				;-------------------
			MOVLW 0x7F				;PreScal 16, TMR2 ON, PostScal 16
			MOVWF T2CON			    ;-------------------
			CLRF on_off				;baja bandera de LED
			MOVLW .10				;Inicializa 10 veces
			MOVWF veces				;-------------------
			GOTO main

main		NOP						;deja pasar tiempo
			GOTO main

interr		DECFSZ veces			;10 veces?
			GOTO int_out			;NO
			GOTO led				;SI
int_out		BCF PIR1,TMR2IF			;Baja la bandera de interrupcion
			MOVLW .125				;Precarga el timer2
			MOVWF TMR2				;-------------------
			RETFIE

led			BTFSS on_off,0			;Esta prendido?
			GOTO prender			;NO
			GOTO apagar				;SI
			
prender		led_on					;Prende el led
			BSF on_off,0			;Sube la bandera
			MOVLW .10				;Inicializa en 10 veces
			MOVWF veces				;-------------------
			GOTO int_out

apagar 		led_off					;Apaga el led
			BCF on_off,0			;Baja la bandera
			MOVLW .10				;Inicializa en 10 veces
			MOVWF veces				;-------------------
			GOTO int_out
END