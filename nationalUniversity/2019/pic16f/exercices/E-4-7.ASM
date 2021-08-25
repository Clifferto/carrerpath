;DISMINUIR ADVERTENCIAS MOLESTAS
errorlevel -203, -205, -302				
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1,b'1110000011010100'

cargas_TMR2 EQU 0X20
frec_setup EQU 0X21

ORG 0
GOTO setup
ORG 4
GOTO INT
ORG 5
setup			CLRF PORTB				;INICIALIZACIONES
				CLRF frec_setup
				CLRW
				CALL TAB_frec
				MOVWF cargas_TMR2
				BANKSEL OSCCON
				BSF OSCCON,IRCF0		;f=8MHz -> Tcy=500ns
				BCF TRISB,TRISB1
				BANKSEL ANSELH
				CLRF ANSELH
				BANKSEL T2CON
				CALL TMR2_setup
				BANKSEL PORTB
				BSF INTCON,INTE
				BSF INTCON,GIE

main			BSF PORTB,RB1
				CALL ret
				BCF PORTB,RB1
				CALL ret
				GOTO main

ret				MOVF cargas_TMR2,W
				MOVWF TMR2
				BSF T2CON,TMR2ON
				BTFSS PIR1,TMR2IF
				GOTO $-1
				BCF T2CON,TMR2ON
				BCF PIR1,TMR2IF
				RETURN	

INT				BTFSC INTCON,INTF
				CALL cambiarFrec
				RETFIE

cambiarFrec		INCF frec_setup,F
				BTFSC frec_setup,2
				CLRF frec_setup
				MOVF frec_setup,W
				CALL TAB_frec
				MOVWF cargas_TMR2
				BCF INTCON,INTF
				RETURN

TAB_frec		ADDWF PCL,F
				RETLW .252				;PARA f=1KHz
				RETLW .248				;PARA f=500Hz
				RETLW .240				;PARA f=250Hz
				RETLW .225				;PARA f=125Hz
				RETURN		

;===============CONFIGURACIONES==================================================
TMR2_setup		COMF T2CON,F			
				BCF T2CON,TMR2ON		;TMR2: ps=16, PS=16, OFF
				RETURN		
END
		
			
				
				
				