;------------------------------------------------
;Proyecto Demo ASK - RDS
;Grupo: Los Pistoleros
;Receptor ASK
;------------------------------------------------

errorlevel -203, -205, -302
LIST P=PIC16F887
#include <P16F887.inc>
;POWER-UP-TIMER ON,WATCH-DOG OFF,OSC XT CRYSTAL 4MHz,MCLR EXT
__CONFIG _CONFIG1,B'0010000011100001'

CBLOCK 0X20
	handShake
ENDC

ORG 0
GOTO setup
ORG 5
setup			CLRF PORTC						;INICIALIZACIONES
				CLRF PORTB
				MOVLW 0XB4
				MOVWF handShake
				BANKSEL ANSELH					;PORTB SALIDA DIGITAL
				CLRF ANSELH
				BANKSEL TRISB
				CLRF TRISB
				CALL USART_setup				;CONFIG DEL RECEPTOR
				BANKSEL RCREG
				BSF RCSTA,CREN					;ESCUCHAR TRANSMISIONES

main			BTFSS PIR1,RCIF					;RECIBIO ALGO?					
				GOTO $-1
				CALL rxRecibir					
				MOVWF PORTB
				GOTO main

rxRecibir		MOVF RCREG,W					;PREGUNTA POR EL HANDSHAKE
				XORWF handShake,W
				BTFSS STATUS,Z
				GOTO indicRuido					
				BTFSS PIR1,RCIF										
				GOTO $-1
				MOVF RCREG,W
				RETURN

indicRuido			BTFSS PORTB,RB4
				GOTO rOn
				BTFSC PORTB,RB4
				GOTO rOff

rOn				BSF PORTB,RB4
				GOTO main

rOff			BCF PORTB,RB4
				GOTO main				
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