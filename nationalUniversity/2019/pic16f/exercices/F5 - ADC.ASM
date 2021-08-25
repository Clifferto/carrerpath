errorlevel -203, -205, -302
LIST P=16F887
#include <P16F887.inc>
__CONFIG _CONFIG1, B'0010000011110100'

CBLOCK 0X20
X
K
ENDC

ORG 0
GOTO setup
ORG 4
;GOTO INT
ORG 5
setup			CLRF PORTA
				CLRF PORTB
				CLRF INTCON
				CLRF PIR1
				BANKSEL ANSELH
				CLRF ANSELH
				BANKSEL TRISB
				CLRF TRISB
				CLRF ADCON1
				BSF PIE1,ADIE
				BSF INTCON,PEIE
				BANKSEL ADCON0
				MOVLW B'11000001'
				MOVWF ADCON0
				COMF X,F
				COMF K,F
				
main			CALL muestrear
				BSF ADCON0,GO
				BTFSC ADCON0,GO	
				GOTO $-1
				MOVF ADRESH,W
				MOVWF PORTB
				CALL retxms
				BCF PIR1,ADIF
				GOTO main

muestrear		NOP
				NOP
				NOP
				NOP
				NOP
				RETURN

retxms			DECFSZ X					;RETARDO DE 500ms
				GOTO $-1
				DECF X,F
				DECFSZ K
				GOTO retxms
				COMF K,F
				RETURN

END				
				