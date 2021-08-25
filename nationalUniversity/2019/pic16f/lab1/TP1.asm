errorlevel -205, -207
__CONFIG _CONFIG1, 0X20F4		;config INTOSC/IO WATCH-DOG off
LIST P=16F887				;y diversas funciones
#include <P16F887.inc>
  
#define led PORTA,RA7			;Led para el carry

var_B_def EQU 0x06			;Valor inicial para B
  
CBLOCK 0x20				;Variables de sumandos y valores 
    sum1				;para los retardos
    sum2
    var_x					
    var_A				
    var_B				
ENDC
  
ORG 0X00
GOTO setup
ORG 0X04
;GOTO INT
  
ORG 0X05
setup		CLRF PORTA		;Limpiar puertos
		CLRF PORTB
		BANKSEL OSCCON		;Configurar Oscilador, 4Mhz (1us p/inst)    
		MOVLW 0x6C
		MOVWF OSCCON	
		BANKSEL TRISA		;Direccionalidad de puertos    
		MOVLW 0X70		;PORTA[0,3] y RA7 como salidas
		MOVWF TRISA
		MOVLW 0XFF		;PORTB entrada de datos
		MOVWF TRISB
		CLRF WPUB		;PULL-UPS en PORTB
		COMF WPUB
		BCF OPTION_REG,NOT_RBPU	
		BANKSEL ANSEL		;PORTA y PORTB en digital
		CLRF ANSEL
		CLRF ANSELH
		BANKSEL PORTA	        ;Inicializar las variables 
		CLRF var_x		;para el retardo
		COMF var_x
		CLRF var_A
		COMF var_A
		CLRF var_B
		    
main		COMF PORTB,W		;Pasa de logica neg a pos (PBPU on)
		ANDLW 0X0F
		MOVWF sum1		;PORTB nibble bajo a sum1
		COMF PORTB,W
		ANDLW 0XF0
		MOVWF sum2		;PORTB nibble alto a sum2
		SWAPF sum2,W		;sum2 listo para la suma	
		ADDWF sum1,W		;W = sum2 + sum1
		MOVWF PORTA		;Sacar valor por PORTA
		BTFSC STATUS,DC		;HAY DIGIT-CARY?
		GOTO carry		;SI -> Activar carry
		GOTO main		;NO -> Continuar sumando
		    
carry		BSF led			;BUCLE INFINITO PRENDE Y 
		CALL ret_1seg		;APAGA CARRY CADA 1seg aprox.	
		BCF led
		CALL ret_1seg
		GOTO carry
		 
ret_1seg	MOVLW var_B_def		;(VER CALCULOS)
		MOVWF var_B	
cuenta		DECFSZ var_x	    
		GOTO cuenta
		DECF var_x	
		DECFSZ var_A		    
		GOTO cuenta
		DECF var_A	
		DECFSZ var_B		
		GOTO cuenta
		RETURN			;(256*255 + 1)3*6 = 1.175.058 inst
					;		  = 1 seg (aprox)
END

