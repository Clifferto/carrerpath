;------------------------------------------------
;Proyecto Intento de driver para brushless
;------------------------------------------------
errorlevel -203, -205, -302
LIST P=PIC16F887
#include <P16F887.inc>
;POWER-UP-TIMER ON,WATCH-DOG OFF,OSC XT CRYSTAL 4MHz,MCLR EXT
__CONFIG _CONFIG1,B'0010000011100001'

CBLOCK 0X20
ENDC

ORG 0
GOTO setup
ORG 5
setup			CLRF PORTB
				CLRF PORTA
				BANKSEL ANSEL					;PORTA ENTRADA DIGITAL
				CLRF ANSEL
				BANKSEL ANSELH					;PORTB SALIDA DIGITAL
				CLRF ANSELH
				BANKSEL TRISB
				CLRF TRISB
				BANKSEL T2CON
				CALL TMR2_setup

main			MOVLW B'00010111'				;A=H,B=0,C=0
				MOVWF PORTB
				CALL ret_ms
				MOVLW B'00010101'				;A=0,B=0,C=0
				MOVWF PORTB
				CALL femcem
				MOVLW B'00011101'				;A=0,B=H,C=0
				MOVWF PORTB
				CALL ret_ms
				MOVLW B'00010101'				;A=0,B=0,C=0
				MOVWF PORTB
				CALL femcem
				MOVLW B'00110101'				;A=0,B=0,C=H
				MOVWF PORTB
				CALL ret_ms
				MOVLW B'00010101'				;A=0,B=0,C=0
				MOVWF PORTB
				CALL femcem
				MOVLW B'00010100'				;A=L,B=0,C=0
				MOVWF PORTB
				CALL ret_ms
				MOVLW B'00010101'				;A=0,B=0,C=0
				MOVWF PORTB
				CALL femcem
				MOVLW B'00010001'				;A=0,B=L,C=0
				MOVWF PORTB
				CALL ret_ms
				MOVLW B'00010101'				;A=0,B=0,C=0
				MOVWF PORTB
				CALL femcem
				MOVLW B'00000101'				;A=0,B=0,C=L
				MOVWF PORTB
				CALL ret_ms
				MOVLW B'00010101'				;A=0,B=0,C=0
				MOVWF PORTB
				CALL femcem
				GOTO main

ret_ms			CLRF TMR2
				BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF PIR1,TMR2IF
				RETURN		

femcem			BTFSC PORTA,RA0
				GOTO $-1
				RETURN
	
;===============CONFIGURACIONES============================================================
TMR2_setup		COMF T2CON,F
				BCF T2CON,TMR2ON
				RETURN
END