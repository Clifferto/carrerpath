;------------------------------------------------
;Proyecto Demo ASK - RDS
;Grupo: Los Pistoleros
;Transmisor ASK
;------------------------------------------------

errorlevel -203, -205, -302
LIST P=PIC16F887
#include <P16F887.inc>
;POWER-UP-TIMER ON, WATCH-DOG OFF,OSC XT CRYSTAL 4MHz
__CONFIG _CONFIG1,B'0010000011100001'

CBLOCK 0X20
	handShake
ENDC

ORG 0
GOTO setup
ORG 5
setup			CLRF PORTB				;INICIALIZACIONES
				CLRF PORTC
				MOVLW 0XB4
				MOVWF handShake
				BANKSEL ANSELH
				CLRF ANSELH				;PORTB ENTRADA DIGITAL
				BANKSEL OPTION_REG
				BCF OPTION_REG,NOT_RBPU
				BANKSEL SPBRG
				CALL USART_setup		;CONFIGURACION DEL TRANSMISOR 
				BANKSEL PORTB
				
main			BTFSC PORTB,RB4
				GOTO $-1
				CALL txEnviar
				GOTO main

ret5us			NOP						;RETARDO DE 5us PARA MUESTREO
				NOP
				NOP
				NOP
				NOP
				RETURN

txEnviar		MOVF handShake,W		;ABRIR LA COMUNICACION CON EL HANDSHAKE
				MOVWF TXREG
				BANKSEL TXSTA
				BTFSS TXSTA,TRMT		
				GOTO $-1
				BANKSEL PORTB			;AHORA ENVIAR EL DATO
				COMF PORTB,W
				MOVWF TXREG				
 				BANKSEL TXSTA
				BTFSS TXSTA,TRMT
				GOTO $-1
				BANKSEL PORTB
				RETURN
  	
;===============CONFIGURACIONES============================================================
USART_setup		MOVLW .49				;BAUDIAGE = 1250, ASYNC, EUSART ON, TX ON				
				MOVWF SPBRG
				CLRF SPBRGH
				BCF TXSTA,SYNC			
				BANKSEL RCSTA					
				BSF RCSTA,SPEN			
				BANKSEL TXSTA
				BSF TXSTA,TXEN			
				RETURN
END		