errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

CBLOCK 0x20
	w_sav
	sts_sav
	valor
ENDC

#define led_on BSF PORTE,RE0
#define led_off BCF PORTE,RE0

ORG 0
GOTO setup
ORG 4
GOTO interrupt
ORG 5 

setup	CLRF PORTB				;Limpiar PuertoB
		CLRF PORTE				;Limpiar PuertoE
		BANKSEL ANSELH			 
		CLRF ANSELH
		CLRF ANSEL				;Desactiva entradas analogicas
		BCF STATUS,RP1			;bk1
		MOVLW 0x01
		MOVWF TRISB				;RB0 como entrada
		MOVLW 0x40				;Activa pull-ups
		MOVWF OPTION_REG
		CLRF TRISE				;PuertoE como salida
		MOVLW 0x88				
		MOVWF INTCON 			;Activar GIE y RBIOC
		BSF IOCB,IOCB0			;Activa interrupt on change en RB0
		BCF STATUS,RP0			;bk0
		CLRF PORTB
		GOTO main

main	SLEEP
		NOP
		GOTO main

delay	CLRF valor	
cuenta	INCFSZ valor
		GOTO cuenta
		RETURN

interrupt	MOVWF w_sav			;PRIMERO salva W
			SWAPF w_sav			;Espeja
			SWAPF STATUS,W		;SEGUNDO salva STATUS espejado 	
			MOVWF sts_sav

			led_on
			CALL delay
			BSF PORTE,RE1
			CALL delay
			BCF PORTE,RE1
			CALL delay
			led_off
			CLRF PORTB
			BCF INTCON,RBIF  	;Borra bandera de interrupcion

			SWAPF sts_sav,W		;PRIMRO carga STATUS
			MOVWF STATUS		
			SWAPF w_sav,W		;SEGUNDO carga W
			RETFIE	
END