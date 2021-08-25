errorlevel -203, -205, -302				;DISMINUIR ADVERTENCIAS MOLESTAS
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1, b'1110000011010100'

CBLOCK 0X20
tecla 
tecla_ASCII
primer_tecla_en_fila
PORTB_temp
ENDC

#define carga_TMR2_50ms MOVLW .61
#define iniciar_fila1 MOVLW 0X10

ORG 0 
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTB
				CLRF tecla
				CLRF tecla_ASCII
				CLRF primer_tecla_en_fila
				BANKSEL ANSELH
				CLRF ANSELH
				BANKSEL TRISB
				MOVLW 0X0F
				MOVWF TRISB
				MOVWF IOCB
				BANKSEL T2CON
				CALL TMR2_setup
				BANKSEL PORTB
				BSF INTCON,PEIE
				BSF INTCON,GIE
				BSF T2CON,TMR2ON

main 			GOTO $

INT				BTFSC INTCON,RBIF
				CALL INT_IOC
				BTFSC PIR1,TMR2IF
				CALL INT_TMR2
				RETFIE

INT_IOC			MOVF PORTB,W
				MOVWF PORTB_temp
				MOVF primer_tecla_en_fila,W
				MOVWF tecla
				BTFSC PORTB_temp,3
				CALL guardarTecla
				INCF tecla,F
				BTFSC PORTB_temp,2
				CALL guardarTecla
				INCF tecla,F
				BTFSC PORTB_temp,1
				CALL guardarTecla
				INCF tecla,F
				BTFSC PORTB_temp,0
				CALL guardarTecla
				BANKSEL TRISB
				CLRF TRISB
				BANKSEL PORTB
				MOVLW 0XF0
				ANDWF PORTB,F
				BANKSEL TRISB
				MOVLW 0X0F
				MOVWF TRISB
				BANKSEL PORTB
				BCF INTCON,RBIF
				RETURN
				
INT_TMR2		BCF T2CON,TMR2ON
				BCF PIR1,TMR2IF
				BCF INTCON,PEIE
				BSF INTCON,RBIE
				BSF INTCON,GIE
				iniciar_fila1
				MOVWF PORTB
				MOVLW .0
				MOVWF primer_tecla_en_fila
				CALL scan50ms
				CALL sigFila
				MOVLW .4
				MOVWF primer_tecla_en_fila
				CALL scan50ms
				CALL sigFila
				MOVLW .8
				MOVWF primer_tecla_en_fila
				CALL scan50ms
				CALL sigFila
				MOVLW .12
				MOVWF primer_tecla_en_fila
				CALL scan50ms
				BSF INTCON,PEIE
				BCF INTCON,RBIE
				BSF T2CON,TMR2ON
				RETURN				

scan50ms		BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON
				carga_TMR2_50ms
				MOVWF TMR2
				BCF PIR1,TMR2IF
				RETURN

sigFila			BCF STATUS,C
				RLF PORTB,F
				RETURN

guardarTecla	MOVF tecla,W
				CALL tabla_ASCII
				MOVWF tecla_ASCII
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
				carga_TMR2_50ms
				MOVWF TMR2
				BANKSEL PIE1
				BSF PIE1,TMR2IE
				RETURN
END