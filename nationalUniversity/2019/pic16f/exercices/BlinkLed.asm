errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

CBLOCK 0x20
	aux
ENDC

ORG 0x00
GOTO setup
ORG 0x05

setup	CLRF PORTA
		BANKSEL ANSEL
		CLRF ANSEL
		BANKSEL TRISA
		CLRF TRISA
		BANKSEL PORTA

main	BSF PORTA, RA0
		CALL espera
		BCF PORTA, RA0
		CALL espera
		GOTO main

espera	MOVLW 0xFF
		MOVWF aux
cuenta	DECFSZ aux
		GOTO cuenta
		RETURN

END		 