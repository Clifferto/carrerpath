LIST P=16F887
#include <P16F887.inc>

CBLOCK 0X20
	n1
	n2
	res1
	sts_temp
ENDC

ORG 0 
GOTO setup
ORG 5 
setup	NOP
		BANKSEL OSCCON
		MOVLW B'01101100'
		MOVWF OSCCON
		BANKSEL ANSEL
		CLRF ANSEL
		CLRF ANSELH
main	MOVF n2,W
		SUBWF n1,W
		SWAPF STATUS,W
		MOVWF sts_temp
		SWAPF sts_temp,F
		MOVF n2,W
		BTFSC sts_temp,2
		CLRF res1
		BTFSC sts_temp,0
		SUBWF n1,W
		BTFSS sts_temp,0
		ADDWF n1,W
		MOVWF res1
		GOTO main
END