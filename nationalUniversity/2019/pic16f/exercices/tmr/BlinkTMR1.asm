errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

CBLOCK 0x20
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
			CLRF TRISB				;PuertoB salida
			MOVLW 0xC0
			MOVWF INTCON			;Habilida, GIE y int por perisfericos
			BSF PIE1,TMR1IE			;Habilita int por TMR1
			BCF STATUS,RP0			;bk0
			CLRF on_off				;Led apagado
			CLRF TMR1L				;Limpia timer
			CLRF TMR1H
			MOVLW 0x0B				;Precarga del TMR1
			MOVWF TMR1H				;-----------------
			MOVLW 0xDC 				;-----------------
			MOVWF TMR1L				;-----------------
			MOVLW 0x31
			MOVWF T1CON				;Prestacler a 8, TMR1 on
			GOTO main

main		NOP						;deja pasar tiempo
			GOTO main

interr		BTFSS on_off,0			;Esta prendido?
			GOTO prender			;NO
			GOTO apagar				;SI
int_out		BCF PIR1,TMR1IF			;Baja la bandera
			MOVLW 0x0B				;Precarga del TMR1
			MOVWF TMR1H				;-----------------
			MOVLW 0xDC 				;-----------------
			MOVWF TMR1L				;-----------------
			RETFIE

prender     led_on
			BSF on_off,0
			GOTO int_out

apagar		led_off
			BCF on_off,0
			GOTO int_out
END