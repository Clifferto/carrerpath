errorlevel -203, -205, -302				;DISMINUIR ADVERTENCIAS MOLESTAS
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1, b'1110000011010100'

;EL PROGRAMA SENSA EL ESTADO DE RA4, DE MANERA QUE SI ESTA PRESIONADO PORTD PARPADEA CADA 1s
;SI SE PRESIONA RB0, LLAMA A LA INTERRUPCION QUE GENERA UNA PAUSA DE 3 seg

;CARGAS DEL TMR1 PARA DISTINTOS RETARDOS
#define carga_TMR1H_1s MOVLW b'11000010'
#define carga_TMR1L_1s MOVLW b'11110111'
#define carga_TMR1H_3s MOVLW b'01001000'
#define carga_TMR1L_3s MOVLW b'11100101'

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTA				;INICIALIZACIONES			
				CLRF PORTB
				CLRF PORTD
				BANKSEL ANSEL			;PORTA Y B A DIGITAL
				CLRF ANSEL
				CLRF ANSELH
			    BANKSEL TRISD			;RA4, RB0 ENTRADAS Y PORTD SALIDA
				CLRF TRISD
				CALL TMR1_setup			;CONFIG DEL TMR1 PARA 1s O 3s
				BANKSEL OPTION_REG
				MOVLW b'10011000'		;PULL-UPS OFF, INT POR FLANCO DESCENDENTE
				MOVWF OPTION_REG
				BANKSEL PORTD
				BCF INTCON,INTF			;LIMPIA BANDERA Y ACTIVA INTERRUPCION EXTERNA
				BSF INTCON,INTE			;Y LA GLOBAL
				BSF INTCON,GIE
				
main			BTFSC PORTA,RA4			;SI SE PRESIONA RA4 PARPADEA
				GOTO $-1				;SINO BORRA PORTD Y CONTINUA LA ESPERA
				CALL parpadeo
				BTFSS PORTA,RA4
				GOTO $-2
				CLRF PORTD
				GOTO main

parpadeo		COMF PORTD,F			;COMPLEMENTA EL PORTD Y ESPERA 1 seg
				carga_TMR1H_1s
				MOVWF TMR1H
				carga_TMR1L_1s
				MOVWF TMR1L
				BSF T1CON,TMR1ON
				BTFSS PIR1,TMR1IF
				GOTO $-1
				BCF T1CON,TMR1ON
				BCF PIR1,TMR1IF
				RETURN

INT 			BTFSC INTCON,INTF		;SI HUBO INT EXTERNA
				CALL INT_EXT
				RETFIE

INT_EXT			carga_TMR1H_3s			;PAUSAR POR 3 seg EL PARPADEO
				MOVWF TMR1H				
				carga_TMR1L_3s
				MOVWF TMR1L
				BSF T1CON,TMR1ON
				BTFSS PIR1,TMR1IF
				GOTO $-1
				BCF T1CON,TMR1ON
				BCF PIR1,TMR1IF
				BCF INTCON,INTF
				RETURN

;---------------CONFIGURACIONES----------------------------------------
TMR1_setup		MOVLW b'10101100'		;TMR1: ps=2, OSC LP INTERNO f=32KHz, OFF
				MOVWF T1CON
				RETURN
END
								
				
				