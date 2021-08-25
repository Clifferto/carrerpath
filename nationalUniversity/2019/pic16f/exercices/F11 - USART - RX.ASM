errorlevel -203, -205, -302
LIST P=16F887
#include <P16F887.inc>
;POWER-UP-TIMER ON, WATCH-DOG OFF,OSC XT CRYSTAL 4MHz, MCLR OFF
__CONFIG _CONFIG1,B'0010000011000001'

CBLOCK 0X20
	aux
	aux2
ENDC
				
ORG 0
GOTO setup
ORG 4
;GOTO INT
ORG 5
setup			CLRF PORTC
				CLRF PORTB
				BANKSEL TRISB
				CLRF TRISB
				BANKSEL T2CON
				CALL TMR2_setup
				CALL USART_setup				;CONFIG DEL RECEPTOR
				BANKSEL RCREG
				BSF RCSTA,CREN

main			BSF PORTB,RB5
				CALL rxRecibir
				CALL rxRecibir
				CALL rxRecibir
				GOTO main
	
rxRecibir		BTFSS PIR1,RCIF					;ESPERA UN DATO
				GOTO $-1
				BCF PORTB,RB5
				MOVF RCREG,W
				BCF RCSTA,CREN
				MOVWF PORTB
				CALL ret1s
				CLRF PORTB
				RETURN		

ret1s			MOVLW .17
				MOVWF aux2
				CLRF TMR2
C3				BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON
				BCF PIR1,TMR2IF
				DECFSZ aux2
				GOTO C3
				RETURN				

;===============CONFIGURACIONES==========================================================
USART_setup		NOP								;600 BAUDIOS, ASYNC, EUSART ON, RECEPTOR OFF
				BANKSEL SPBRG					
				MOVLW .103						
				MOVWF SPBRG
				CLRF SPBRGH
				BCF TXSTA,SYNC					
				BANKSEL RCSTA
				BSF RCSTA,SPEN
				RETURN

TMR2_setup		COMF T2CON						;ps = 16, PS = 16, T2OFF
				BCF T2CON,TMR2ON
				CLRF TMR2
				RETURN
END