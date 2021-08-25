;DISMINUIR ADVERTENCIAS MOLESTAS
errorlevel -203, -205, -302				
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1,b'1110000011010100'

aux_60s EQU 0X20

#define carga_TMR2_5s MOVLW .104

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTA				;INICIALIZACIONES
				MOVLW b'01110111'
				MOVWF PORTD
				MOVLW .12
				MOVWF aux_60s
				BANKSEL OSCCON
				BCF OSCCON,IRCF2		;OSC f=31KHz -> Tcy=129us aprox
				BCF OSCCON,IRCF1
				BANKSEL TRISD
				CLRF TRISD
				BANKSEL ADCON0
				CALL ADC_setup
				BANKSEL T2CON
				CALL TMR2_setup
				BANKSEL PORTA
				BSF INTCON,PEIE
				BSF INTCON,GIE
				BSF T2CON,TMR2ON

main			GOTO $

INT				BTFSC PIR1,TMR2IF
				CALL esperarMinuto
				RETFIE

esperarMinuto	BCF T2CON,TMR2ON
				;DECFSZ aux_60s
				;GOTO S1
				;MOVLW .12
				;MOVWF aux_60s
				CALL tomarMuestra
				CALL mostrarRes		
S1				carga_TMR2_5s
				MOVWF TMR2
				BCF PIR1,TMR2IF
				BSF T2CON,TMR2ON
				RETURN

tomarMuestra	BSF ADCON0,ADON
				CALL muestreo
				BSF ADCON0,GO
				BTFSS PIR1,ADIF
				GOTO $-1
				BCF PIR1,ADIF
				BCF ADCON0,ADON
				RETURN

muestreo		NOP 
				NOP 
				NOP 
				NOP 
				NOP 
				RETURN

mostrarRes		MOVF ADRESH,W
				CALL TAB_res
				MOVWF PORTD
				RETURN

TAB_res			ADDWF PCL,F
				RETLW b'01110111'		;A EN 7 SEG	
				RETLW b'01110111'		;IDEM
				RETLW b'01111100'		;B EN 7 SEG
				RETLW b'00111001'		;C EN 7SEG
				RETURN
				
;===============CONFIGURACIONES==================================================
ADC_setup		NOP						;ADC: fadc=f/2, CH AN0, OFF
				BANKSEL ADCON1
				COMF ADCON1,F			;JUSTIFICACION DERECHA, +Vref = 4V, -Vref=0 
				BCF ADCON1,VCFG1
				RETURN

TMR2_setup		carga_TMR2_5s
				MOVWF TMR2
				COMF T2CON,F
				BCF T2CON,TMR2ON
				BANKSEL PIE1
				BSF PIE1,TMR2IE
				RETURN
END