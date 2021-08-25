errorlevel -205, -203
LIST P=PIC16F887
#include <P16F887.inc>

CBLOCK 0X20
	byte_ascii						;el byte lo guardamos en la pos 0x20
	bcd								;el resultado en la 0x21					
ENDC

ORG 0X00
GOTO main

; En ASCII los numeros del 0 al 9 tienen el formato:
; 0011 + (num_BCD)
; Asi que solo tenemos que recuperar el nibble bajo y tenemos 
; nuestro numero en BCD

ORG 0X05
main			MOVF byte_ascii,W	;cargamos w con el num en ascii
				ANDLW 0X0F			;eliminamos el nibble alto
				MOVWF bcd			;guardamos la conversion
				SLEEP				;hibernamos el micro
END

