errorlevel -205, -203
LIST P=PIC16F887
#include <P16F887.inc>

#define veces .15

aux 	EQU 	0X22

ORG 0X00
GOTO setup
ORG 0X04
;GOTO INT

ORG 0X05
setup				MOVLW veces
					MOVWF aux
					GOTO main

main				MOVLW 0X30
					MOVWF FSR
					MOVLW .33
					MOVWF INDF
					INCF FSR
					DECFSZ aux
					GOTO $-3
					SLEEP					
END