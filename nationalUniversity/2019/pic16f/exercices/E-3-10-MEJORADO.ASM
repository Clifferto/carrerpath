errorlevel -203, -205, -302
LIST P=16F887
#include <P16F887.inc>
__CONFIG _CONFIG1,b'001000011010100'

CBLOCK 0X20
tecla
tecla_7seg
ENDC 

#define carga_TMR2_10ms MOVLW .217

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTA
				CLRF PORTB
				CLRF tecla
				BANKSEL ANSEL
				CLRF ANSEL
				CLRF ANSELH
				BANKSEL TRISA
				CLRF TRISA
				MOVLW 0XF0
				MOVWF TRISB
				BANKSEL T2CON
				CALL TMR2_setup
				BANKSEL PORTA
				BSF INTCON,PEIE
				BSF INTCON,GIE
				BSF T2CON,TMR2ON

main			GOTO $

INT 			BTFSC PIR1,TMR2IF
				CALL INT_TMR2
				RETFIE

INT_TMR2		BCF T2CON,TMR2ON
				CALL scanTeclado
				CALL mostrarTecla
				BCF PIR1,TMR2IF 
				carga_TMR2_10ms
				MOVWF TMR2
				BSF T2CON,TMR2ON
				RETURN

scanTeclado		MOVLW 0X01
				MOVWF PORTB
				CLRW 
				MOVWF tecla
C1				CALL scanTeclas
				CALL sigFila
				BTFSS tecla,4
				GOTO C1
				RETURN
	
mostrarTecla	MOVF tecla_7seg,W
				MOVF PORTB
				BCF PORTA,RA0
				CALL ret50ms
				BSF PORTA,RA0
				RETURN

ret50ms			BCF PIR1,TMR2IF
				MOVLW .0
				MOVWF TMR2
				BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON
				RETURN

scanTeclas		BTFSC PORTB,RB4
				CALL buscarTecla
				INCF tecla,F	
				BTFSC PORTB,RB5
				CALL buscarTecla
				INCF tecla,F
				BTFSC PORTB,RB6
				CALL buscarTecla
				INCF tecla,F
				BTFSC PORTB,RB7
				CALL buscarTecla
				INCF tecla,F
				RETURN
		
sigFila			BCF STATUS,C
				RLF PORTB,F
				RETURN

buscarTecla		MOVF tecla,W
				CALL TAB_7seg
				MOVWF tecla_7seg
				RETURN
				
TAB_7seg		ADDWF PCL,F
				RETLW b'00111111'
				RETLW b'00000110'
				RETLW b'01011011'
				RETLW b'01001111'
				RETLW b'01100110'
				RETLW b'01101101'
				RETLW b'01111101'
				RETLW b'00100111'
				RETLW b'01111111'
				RETLW b'01101111'
				RETLW b'01110111'
				RETLW b'01111100'
				RETLW b'00111001'
				RETLW b'01011110'
				RETLW b'01111001'
				RETLW b'01110001'
				RETLW b'00111111'
				RETURN

;===============CONFIGURACIONES===========================================
TMR2_setup		COMF T2CON,F
				BCF T2CON,TMR2ON
				carga_TMR2_10ms
				MOVWF TMR2
				BANKSEL PIE1
				BSF PIE1,TMR2IE
				RETURN
END	