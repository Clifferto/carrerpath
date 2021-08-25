;DISMINUIR ADVERTENCIAS MOLESTAS
errorlevel -203, -205, -302				
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1,b'1110000011010100'

CBLOCK 0X20
cuenta
decenas_offset
unidades_offset
aux_1s
ENDC

#define carga_TMR0_80e MOVLW .254
#define carga_TMR2_20ms MOVLW .200

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTD				;INICIALIZACIONES
				CLRF PORTC    
				MOVLW .50
				MOVWF aux_1s
				BANKSEL ANSEL
				CLRF ANSEL
				BANKSEL TRISD
				CLRF TRISD				;RD0-RD6 DISPLAYS, RD7 RELE	
				CLRF PORTC				;RC0, RC1 ENABLES
				COMF OPTION_REG,F
				BSF OPTION_REG,T0CS		;TMR0 ASINCRONO, FLANCO ASCENDENTE, ps=1
				BANKSEL TMR0
				carga_TMR0_80e
				MOVWF TMR0
				CALL TMR2_setup
				BANKSEL PORTD
				CLRF INTCON
				BSF INTCON,T0IE
				BSF INTCON,PEIE
				BSF INTCON,GIE
				BSF T2CON,TMR2ON				

main			GOTO $

INT				BTFSC INTCON,T0IF
				CALL reiniciar
				BTFSC PIR1,TMR2IF
				CALL mostrarCuenta
				RETFIE

reiniciar		MOVLW b'00111111'
				MOVWF PORTD
				BCF PORTC,RC0
				BCF PORTC,RC1
				BSF PORTD,RD7
				CALL ret_1s
				BCF PORTD,RD7
				BSF PORTC,RC0
				BSF PORTC,RC1
				BCF INTCON,T0IF
				carga_TMR0_80e
				MOVWF TMR0
				RETURN

mostrarCuenta	BCF T2CON,TMR2ON
				CALL calcOffsets
				MOVF decenas_offset,W
				CALL TAB_7seg
				MOVWF PORTD
				BCF PORTC,RC0
				CALL ret_20ms
				BSF PORTC,RC0
				MOVF unidades_offset,W
				CALL TAB_7seg
				MOVWF PORTD
				BCF PORTC,RC1
				CALL ret_20ms
				BSF PORTC,RC1
				BCF PIR1,TMR2IF
				carga_TMR2_20ms
				MOVWF TMR2
				BSF T2CON,TMR2ON
				RETURN

calcOffsets		CLRF decenas_offset
				CLRF unidades_offset
				CLRF cuenta
				carga_TMR0_80e
				SUBWF TMR0,W
				MOVWF cuenta
D1				MOVLW .10
				SUBWF cuenta,W
				BTFSC STATUS,C
				INCF decenas_offset,F
				BTFSC STATUS,C
				MOVWF cuenta
				BTFSC STATUS,C
				GOTO D1				
U1				MOVLW .1
				SUBWF cuenta,W
				BTFSC STATUS,C
				INCF unidades_offset,F
				BTFSC STATUS,C
				MOVWF cuenta
				BTFSC STATUS,C
				GOTO U1
				RETURN

ret_20ms		BCF PIR1,TMR2IF
				carga_TMR2_20ms
				MOVWF TMR2
				BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON
				RETURN

ret_1s			CALL ret_20ms
				DECFSZ aux_1s
				GOTO ret_1s
				MOVLW .50
				MOVWF aux_1s
				RETURN

TAB_7seg		ADDWF PCL,F
				RETLW b'00111111'		;0 EN 7 SEG		
				RETLW b'00000110'
				RETLW b'01011011'
				RETLW b'01001111'
				RETLW b'01100110'
				RETLW b'01101101'
				RETLW b'01111101'
				RETLW b'00100111'
				RETLW b'01111111'
				RETLW b'01101111'		;9 EN 7 SEG
				RETURN

;===============CONFIGURACIONES==================================================
TMR2_setup		COMF T2CON,F
				BCF T2CON,TMR2ON
				carga_TMR2_20ms
				MOVWF TMR2
				BANKSEL PIE1
				BSF PIE1,TMR2IE
				RETURN
END