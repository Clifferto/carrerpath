;DISMINUIR ADVERTENCIAS MOLESTAS
errorlevel -203, -205, -302				
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1, b'1110000011010100'

#define carga_TMR1H_2048 MOVLW b'01111100'

#define carga_TMR2_50ms MOVLW .60

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTD				;INICIALIZACIONES
	 			BANKSEL TRISD
				CLRF TRISD
				BANKSEL T1CON
				CALL TMR1_setup
				BANKSEL T2CON
				CALL TMR2_setup
				BSF INTCON,PEIE
				BSF INTCON,GIE
				BSF T1CON,TMR1ON

main			SLEEP
				NOP
				GOTO main

INT				BTFSC PIR1,TMR1IF
				CALL aviso
				RETFIE

aviso			BSF PORTD,RD0
				CALL ret_50ms
				BCF PORTD,RD0
				CALL ret_50ms
				GOTO aviso
				BCF PIR1,TMR1IF
				RETURN

ret_50ms		BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON 
				carga_TMR2_50ms
				MOVWF TMR2
				BCF PIR1,TMR2IF
				RETURN

;===============CONFIGURACIONES===============================================
TMR1_setup		BSF T1CON,TMR1CS
				BSF T1CON,T1SYNC
				carga_TMR1H_2048
				MOVWF TMR1H
				CLRF TMR1L
				BANKSEL PIE1
				BSF PIE1,TMR1IE
				RETURN

TMR2_setup		COMF T2CON,F
				BCF T2CON,TMR2ON
				carga_TMR2_50ms
				MOVWF TMR2
				RETURN

END