LIST P=PIC18F2550
#include <P18F2550.inc>
__CONFIG

ORG 0
GOTO setup
ORG 20
setup				CLRF PORTB
					BANKSEL TRISB
					CLRF TRISB
					CALL TMR0_setup

main				BSF PORTB,RB0
					CALL ret
					BCF PORTB,RB0
					CALL ret
					GOTO main

ret					CLRF TMR0H
					CLRF TMR0H
					BSF T0CON,TMR0ON
					BTFSS INTCON,TMR0IF
					GOTO $-1
					BCF INTCON,TMR0IF
					RETURN
;=============================================================================
TMR0_setup			CLRF TMR0H
					CLRF TMR0L
					MOVLW 0X07
					MOVWF T0CON
					RETURN			
END