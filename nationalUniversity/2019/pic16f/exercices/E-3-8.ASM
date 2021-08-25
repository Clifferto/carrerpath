errorlevel -203, -205, -302				;DISMINUIR ADVERTENCIAS MOLESTAS
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1, b'1110000011010100'

CBLOCK 0X20
tecla 
tecla_ASCII
primer_tecla_en_fila
ENDC

#define iniciar_fila1 MOVLW 0X10
#define carga_TMR2_5ms MOVLW .236
 
ORG 0
GOTO setup
ORG 4
;GOTO INT
ORG 5
setup			CLRF PORTB				;INICIALIZACIONES
				CLRF tecla
				CLRF tecla_ASCII
				CLRF PORTD
				BANKSEL ANSELH
				CLRF ANSELH
				BANKSEL TRISB
				MOVLW 0X0F
				MOVWF TRISB
				CLRF TRISD
				BANKSEL T2CON
				CALL TMR2_setup

main			iniciar_fila1
				MOVWF PORTB
				MOVLW .0
				MOVWF primer_tecla_en_fila
				CALL scanFila
				CALL sigFila
				MOVLW .4
				MOVWF primer_tecla_en_fila
				CALL scanFila
				CALL sigFila
				MOVLW .8
				MOVWF primer_tecla_en_fila
				CALL scanFila
				CALL sigFila
				MOVLW .12
				MOVWF primer_tecla_en_fila
				CALL scanFila
				GOTO main

scanFila		BSF T2CON,TMR2ON
cont			MOVF primer_tecla_en_fila,W
				MOVWF tecla
				BTFSC PORTB,RB3
				CALL guardarTecla
				INCF tecla,F
				BTFSC PORTB,RB2
				CALL guardarTecla
				INCF tecla,F
				BTFSC PORTB,RB1
				CALL guardarTecla
				INCF tecla,F
				BTFSC PORTB,RB0
				CALL guardarTecla
				BTFSS PIR1,TMR2IF
				GOTO cont
				BCF T2CON,TMR2ON
				carga_TMR2_5ms
				MOVWF TMR2
				BCF PIR1,TMR2IF
				RETURN

sigFila			BCF STATUS,C
				RLF PORTB,F
				RETURN

guardarTecla	MOVF tecla,W
				CALL tabla_ASCII
				MOVWF tecla_ASCII
				MOVWF PORTD
				RETURN

tabla_ASCII		ADDWF PCL,F
				RETLW '1'
				RETLW '2'
				RETLW '3'
				RETLW '4'
				RETLW '5'
				RETLW '6'
				RETLW '7'
				RETLW '8'
				RETLW '9'
				RETLW 'A'
				RETLW 'B'
				RETLW 'C'
				RETLW 'D'
				RETLW 'E'
				RETLW 'F'
				RETLW '0'
				RETURN

;---------------CONFIGURACIONES-----------------------------------------------
TMR2_setup		COMF T2CON,F
				BCF T2CON,TMR2ON
				carga_TMR2_5ms
				MOVWF TMR2
				RETURN
END						