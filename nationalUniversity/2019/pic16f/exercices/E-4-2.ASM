errorlevel -203, -205, -302
LIST P=16F887
#include <P16F887.inc>
__CONFIG _CONFIG1,b'001000011010100'

aux_1s EQU 0X20
aux_50ms EQU 0X21

carga_TMR0_10ms	macro v	
				MOVLW .177
				MOVWF TMR0
				endm

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTD				;INICIALIZACIONES
				MOVLW .5
				MOVWF aux_50ms
				MOVLW .100
				MOVWF aux_1s
				BANKSEL TRISD
				CLRF TRISD
				BANKSEL OSCCON
				BSF OSCCON,IRCF0		;INTOSC A f=8MHz
				BANKSEL OPTION_REG
				MOVLW b'11010111'
				MOVWF OPTION_REG
				BANKSEL PORTD
				CLRF INTCON
				BSF INTCON,T0IE
				BSF INTCON,GIE
				BSF INTCON,T0IF
				
main 			GOTO $

INT				BTFSC INTCON,T0IF
				CALL INT_TMR0 
				RETFIE

INT_TMR0		DECFSZ aux_1s
				GOTO S1
				MOVLW .10
				MOVWF aux_1s
signal			BSF PORTD,RD0
				CALL ret_50ms
				BCF PORTD,RD0
				CALL ret_50ms
				DECFSZ aux_1s
				GOTO signal
				MOVLW .100
				MOVWF aux_1s
S1				BCF PORTD,RD0
				BCF INTCON,T0IF
				carga_TMR0_10ms 0
				RETURN

ret_50ms		BCF INTCON,T0IF
				carga_TMR0_10ms 0
				BTFSS INTCON,T0IF
				GOTO $-1
				DECFSZ aux_50ms
				GOTO ret_50ms
				MOVLW .5
				MOVWF aux_50ms
				RETURN
END		