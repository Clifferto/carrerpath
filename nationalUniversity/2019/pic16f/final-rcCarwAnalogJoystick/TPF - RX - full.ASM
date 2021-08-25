;------------------------------------------------
;Proyecto Demo ASK - RDS
;Grupo: Los Pistoleros
;Transmisor ASK
;------------------------------------------------

errorlevel -203, -205, -302
LIST P=16F887
#include <P16F887.inc>
;POWER-UP-TIMER ON,WATCH-DOG OFF,OSC XT CRYSTAL 4MHz,MCLR EXT
__CONFIG _CONFIG1,B'0010000011100001'

ORG 0
GOTO setup
ORG 5
setup			CLRF PORTC						;INICIALIZACIONES
				CLRF PORTB
				BANKSEL ANSELH					;PORTB SALIDA DIGITAL
				CLRF ANSELH
				BANKSEL TRISB
				CLRF TRISB
				CALL USART_setup				;CONFIG DEL RECEPTOR
				BANKSEL RCREG

main			BSF RCSTA,CREN					;ESCUCHAR TRANSMISIONES
				CALL rxRecibir
				BANKSEL PORTB
				MOVWF PORTB
				BANKSEL RCREG
				GOTO main

rxRecibir		BTFSS PIR1,RCIF					;RECIBIR DATO2
				GOTO $-1
				MOVF RCREG,W
				RETURN
				
;===============CONFIGURACIONES============================================================
USART_setup		NOP								;BAUDIAGE = 1250, ASYNC, EUSART ON, RX OFF
				BANKSEL SPBRG					
				MOVLW .49						
				MOVWF SPBRG
				CLRF SPBRGH
				BCF TXSTA,SYNC					
				BANKSEL RCSTA
				BSF RCSTA,SPEN					
				RETURN
END