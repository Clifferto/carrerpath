;DISMINUIR ADVERTENCIAS MOLESTAS
errorlevel -203, -205, -302				
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1,b'1110000011010100'

CBLOCK 0X20
paso
res_H
res_L
cent_offset
dec_offset
unid_offset
ENDC

#define carga_TMR2_5ms MOVLW .60

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTA				;INICIALIZACIONES
				MOVLW .2
				MOVWF paso
				BANKSEL ANSELH
				CLRF ANSELH
				BANKSEL TRISA
				CLRF TRISA				;RA0 IN AN0, RA5-RA7 ANODOS DISP
				BSF TRISA,TRISA0
				CLRF TRISD				;PORTD DISP
				BANKSEL ADCON0
				CALL ADC_config			
				BANKSEL T2CON
				CALL TMR2_config
				BANKSEL PORTA
				BSF INTCON,PEIE
				BSF INTCON,INTE			;HABILITAR INT EXTERNAS Y POR TMR2
				BSF INTCON,GIE
				BSF T2CON,TMR2ON		;COMENZAR CUENTA

main			GOTO $					;ALGO

INT				BTFSC INTCON,INTF		;OPRIMIERON RB0?
				CALL tomarTemp
				BTFSC PIR1,TMR2IF		;PASARON 5ms?
				CALL mostrarRes
				RETFIE

tomarTemp		BSF ADCON0,ADON			;MUESTREA, CONVIERTE, Y MUESTRA LA TEMP EN DISP
				CALL muestreo
				BSF ADCON0,GO
				BTFSS PIR1,ADIF
				GOTO $-1
				BCF PIR1,ADIF
				BCF ADCON0,ADON
				CALL mostrarTemp
				BCF INTCON,INTF
				RETURN

muestreo		NOP						;RET DE 5us aprox PARA EL SAMPLE-HOLD
				NOP
				NOP	
				NOP
				NOP
				RETURN

mostrarTemp		CALL armarRes			;OBTIENE EL VALOR TAL CUAL LO VEMOS
				CALL calcOffsets		
				CALL corregirOffsets
				CALL mostrarRes			;MUESTRA EN LOS 3 DISPLAYS
				RETURN											

armarRes		CLRF res_L				;INICIALIZA
				CLRF res_H
M1				MOVF ADRESH,W				
				ADDWF res_L,F
				BTFSC STATUS,C
				INCF res_H,F
				BCF STATUS,C
				DECFSZ paso
				GOTO M1
				MOVLW .2
				MOVWF paso
				RETURN

calcOffsets		CLRF cent_offset		;INICIALIZA
				CLRF dec_offset
				CLRF unid_offset
				BTFSC res_H,0			;SI LLEGO A 256 -> CENT=2, DEC=5 Y UNID=6 
				CALL mayorA255
C1				MOVLW .100				;PREGUNTAR POR LA CANT DE CENTENAS
				SUBWF res_L,W
				BTFSC STATUS,C
				INCF cent_offset,F
				BTFSC STATUS,C
				MOVWF res_L
				BTFSC STATUS,C
				GOTO C1
D1				MOVLW .10				;IDEM POR LAS DECENAS
				SUBWF res_L,W
				BTFSC STATUS,C
				INCF dec_offset,F
				BTFSC STATUS,C
				MOVWF res_L
				BTFSC STATUS,C
				GOTO D1
U1				MOVLW .1				;POR LAS UNIDADES
				SUBWF res_L,W
				BTFSC STATUS,C
				INCF unid_offset,F
				BTFSC STATUS,C
				MOVWF res_L
				BTFSC STATUS,C
				GOTO U1	
				RETURN

mayorA255		MOVLW .2
				MOVWF cent_offset
				MOVLW .5
				MOVWF dec_offset
				MOVLW .6
				MOVWF unid_offset
				RETURN		

corregirOffsets	NOP
CU				MOVLW .10				;SI UNID >= 10 -> DEC++
				SUBWF unid_offset,W
				BTFSC STATUS,C
				INCF dec_offset,F
				BTFSC STATUS,C
				MOVWF unid_offset
				BTFSC STATUS,C
				GOTO CU
CD				MOVLW .10				;SI DEC >= 10 -> CENT++
				SUBWF dec_offset,W
				BTFSC STATUS,C
				INCF cent_offset,F
				BTFSC STATUS,C
				MOVWF dec_offset
				BTFSC STATUS,C	
				GOTO CD				
				RETURN

mostrarRes		MOVF cent_offset,W		;MUESTRA LAS CENTENAS 5ms		
				CALL TAB_7seg
				MOVWF PORTD
				COMF PORTD,F
				BSF PORTA,RA7
				CALL ret5ms
				BCF PORTA,RA7
				MOVF dec_offset,W		;MUESTRA LAS DECENAS 5ms
				CALL TAB_7seg
				MOVWF PORTD
				COMF PORTD,F
				BSF PORTA,RA6
				CALL ret5ms
				BCF PORTA,RA6				
				MOVF unid_offset,W		;MUESTRA LAS UNIDADES 5ms
				CALL TAB_7seg
				MOVWF PORTD
				COMF PORTD,F
				BSF PORTA,RA5
				CALL ret5ms
				BCF PORTA,RA5
				carga_TMR2_5ms			;CARGA TMR2, BAJA BANDERAS, Y LO PRENDE
				MOVWF TMR2	
				BCF PIR1,TMR2IF
				BSF T2CON,TMR2ON
				RETURN

ret5ms			BCF PIR1,TMR2IF						;RETARDO DE 5ms POR TMR2
				carga_TMR2_5ms
				MOVWF TMR2
				BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON
				BCF PIR1,TMR2IF
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

;===============CONFIGURACIONES===============================================
ADC_config		NOP						;ADC: fadc=f/2, CH AN0, OFF
				BANKSEL ADCON1
				BSF ADCON1,VCFG0		;+Vref = 3v
				RETURN

TMR2_config		carga_TMR2_5ms
				MOVWF TMR2
				COMF T2CON,F			
				BCF T2CON,TMR2ON
				BANKSEL PIE1
				BSF PIE1,TMR2IE
				RETURN
END										