errorlevel -205, -203
processor 16f887
#include <p16f887.inc>
list p=16f887

__config _CONFIG1, _XT_OSC & _WDT_OFF & _MCLRE_OFF 
__config _CONFIG2, _BOR21V

scan0 EQU 0x06
scan1 EQU 0x05
scan2 EQU 0x03

CBLOCK 0x20
	t0_carga
ENDC

#define t0_on BCF OPTION_REG,T0CS
#define go_bk0 BCF STATUS,RP0
#define go_bk1 BSF STATUS,RP0

ORG 0
GOTO setup
ORG 5

setup		CLRF PORTB			;Limpia latches de PB
			CLRF PORTD			;Limpia latches de PD
			MOVLW .248			;Carga del TMR0 para 1ms
			MOVWF t0_carga

			BANKSEL ANSELH		;bk3
			CLRF ANSELH			;AN off

			BCF STATUS,RP1		;bk1
			MOVLW 0x78			;RB<0:2> in, RB<3:6> out
			MOVWF TRISB
			CLRF TRISD			;PD out
			MOVLW 0x66			;WPull-Up en PB, PScaler a TMR0 en 128, TMR0 off 
			MOVWF OPTION_REG

			BCF STATUS,RP0		;bk0			
			GOTO main

main		MOVLW scan0			;scan columna 1
			MOVWF PORTB
			CALL set_tmr0
scan_c1		MOVLW 0x06			;W=1
			BTFSS PORTB,RB3		;opr 1?
			MOVWF PORTD			;1 en PD
			MOVLW 0x66			;W=4 				
			BTFSS PORTB,RB4		;opr 4?
			MOVWF PORTD			;4 en PD
			MOVLW 0x07			;W=7
			BTFSS PORTB,RB5		;opr 7?
			MOVWF PORTD			;7 en PD
			BTFSS INTCON,T0IF	;Desbordo TMR0?
 			GOTO scan_c1
			BCF INTCON,T0IF		;Baja bandera
			CALL t0_off								
			
			BSF STATUS,C		;rotar cero, scan columna 2
			RLF PORTB
			CALL set_tmr0
scan_c2		MOVLW 0x02			;W=2
			BTFSS PORTB,RB3		;opr 2?
			MOVWF PORTD			;2 en PD	
			MOVLW 0x05 			;W=5
			BTFSS PORTB,RB4		;opr 5?
			MOVWF PORTD			;5 en PD
			MOVLW 0x08			;W=8
			BTFSS PORTB,RB5		;opr 8?
			MOVWF PORTD			;8 en PD
			BTFSS INTCON,T0IF	;Desbordo TMR0?
			GOTO scan_c2
			BCF INTCON,T0IF		;Baja bandera
			CALL t0_off			

			BSF STATUS,C		;rotar cero, scan columna 3
			RLF PORTB
			CALL set_tmr0
scan_c3		MOVLW 0x03			;W=3			
			BTFSS PORTB,RB3		;opr 3? 
			MOVWF PORTD			;3 en PD
			MOVLW 0x06 			;W=6
			BTFSS PORTB,RB4		;opr 6?	
			MOVWF PORTD			;6 en PD
			MOVLW 0x09			;W=9
			BTFSS PORTB,RB5		;opr 9?	
			MOVWF PORTD			;9 en PD
			BTFSS INTCON,T0IF	;Desbordo TMR0?
			GOTO scan_c3
			BCF INTCON,T0IF		;Baja bandera
			CALL t0_off			
			GOTO main

set_tmr0	MOVF t0_carga,W		;Carga el timer para desborde en 1ms
			MOVWF TMR0
			go_bk1				
			t0_on				;TMR0 on
			go_bk0
			RETURN

t0_off		go_bk1
			BSF OPTION_REG,T0CS ;TMR0 off
			go_bk0
			RETURN
END