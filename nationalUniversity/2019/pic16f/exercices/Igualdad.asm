errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

#define set_clave MOVF PORTD, W
#define prender BSF PORTB, RB4
#define apagar BCF PORTB, RB4

CBLOCK 0x20
	clave
	cuenta
ENDC

ORG 0x00
GOTO setup

ORG 0x05
setup 	CLRF PORTB					;Limpiar PuertoB
		CLRF PORTD
		BANKSEL ANSELH
		CLRF ANSELH					;Desactiva entradas analogicas
		BANKSEL TRISB	
		MOVLW 0x0F	
		MOVWF TRISB					;RB<0;3> in, RB<4;7> out
		MOVWF TRISD					;RD<0;3> in, selector de clave
		BCF OPTION_REG, NOT_RBPU	;PullUp para el PuertoB
		BANKSEl PORTB				;Volver a banco 0
		GOTO main

main	set_clave
		XORWF PORTB, W
		BTFSS STATUS, Z
		GOTO main
		GOTO igual 

igual 	CALL roll		
		GOTO main

roll	BCF STATUS, C
		BSF PORTB, RB4
rotar	CALL ret		
		RLF PORTB
		BTFSS PORTB, RB7
		GOTO rotar
		CLRF PORTB
		RETURN	

ret		CLRF cuenta
delay	INCFSZ cuenta
		GOTO $-1
		RETURN			
END