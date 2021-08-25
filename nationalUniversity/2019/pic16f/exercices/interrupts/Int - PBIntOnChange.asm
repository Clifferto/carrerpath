errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

CBLOCK 0x20
	w_sav
	sts_sav
	tiempo
ENDC

#define int_trig PORTB,RB0
#define ioc_trig PORTB,RB1
#define led_on BSF PORTB,RB2
#define led_off BCF PORTB,RB2
#define led_int_on BSF PORTB,RB3
#define led_int_off BCF PORTB,RB3
#define led_ioc_on BSF PORTB,RB4
#define led_ioc_off BCF PORTB,RB4
#define w_con PORTB,RB5

ORG 0 
GOTO setup
ORG 4 
GOTO interrupt
ORG 5

setup		CLRF PORTB				;Limpia los latchs			
			BANKSEL ANSELH
			CLRF ANSELH				;Desactiva entradas analogicas
			BCF STATUS,RP1			;bk 1
			MOVLW 0x02				;pull up solo en RB1
			MOVWF WPUB
			BCF OPTION_REG,NOT_RBPU ;PullUPS
			BCF OPTION_REG,INTEDG	;Int por flanco de bajada
			MOVLW 0x03
			MOVWF TRISB				;RB0 y RB1 para INT y IOChange
			BSF IOCB,IOCB1			;IOC en RB1
			BSF INTCON,INTE			;interrupcion por INT
			BSF INTCON,RBIE			;interrupcion por IOC
			BSF INTCON,GIE
			BCF STATUS,RP0			;bk0
			GOTO main

main		MOVLW 0x07				;carga valor en w
			SUBLW .7			
			BTFSS STATUS,Z			
			SLEEP
			BSF w_con				;verifica si se recupero el valor de w
			CALL blink
			GOTO main

blink		led_on					;BLINK 
			CALL delay
			CALL delay
			led_off
			CALL delay
			CALL delay
			RETURN		

delay		MOVLW 0xFF
			MOVWF tiempo
			DECFSZ tiempo
			GOTO $-1
			RETURN

interrupt	MOVLW 0x07
			BTFSC INTCON,INTF
			GOTO rb_int
			BTFSC INTCON,RBIF
			GOTO rb_ioc
			GOTO ninguno

rb_int		MOVWF w_sav				;guarda entorno
			SWAPF w_sav
			SWAPF STATUS,W
			MOVWF sts_sav
			led_off
			led_int_on				;indicador de interrupcion por INT

blink_int	led_on					;RSAI INT
			CALL delay				
			CALL delay
			CALL delay
			CALL delay
			led_off
			CALL delay
			BTFSC int_trig			;Se solto el boton?
			GOTO blink_int
			led_int_off
			SWAPF sts_sav,W			;carga entorno
			MOVWF STATUS
			SWAPF w_sav,W
			BCF INTCON,INTF			;borra flag INTF
			RETFIE

rb_ioc		MOVWF w_sav				;guarda entorno
			SWAPF w_sav
			SWAPF STATUS,W
			MOVWF sts_sav
			led_off
			led_ioc_on				;indicador de interrupcion por INT
			led_on					;RSAI INT
			CALL delay				
			CALL delay
			CALL delay
			CALL delay
			CALL delay
			CALL delay
			led_off
			CALL delay
			CALL blink
			CALL delay
			led_on
			CALL delay
			led_off
			led_oic_off
			SWAPF sts_sav,W			;carga entorno
			MOVWF STATUS
			SWAPF w_sav,W
			BCF INTCON,RBIF			;borra flag de Interrup on Change
			RETFIE

ninguno		led_int_on
			led_ioc_on
			SLEEP			 
END			