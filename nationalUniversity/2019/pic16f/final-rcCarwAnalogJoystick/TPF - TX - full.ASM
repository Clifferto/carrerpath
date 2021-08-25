;------------------------------------------------
;Proyecto final - Auto RC
;Grupo: Ferraris/Bonino
;Transmisor auto RC
;MODULOS: ADC (Con multiplexado de canales)
;		  EUSAR (Transmisor serie)
;------------------------------------------------

errorlevel -203, -205, -302
LIST P=16F887
#include <P16F887.inc>

;POWER-UP-TIMER ON, WATCH-DOG OFF,OSC XT CRYSTAL 4MHz
__CONFIG _CONFIG1,B'0010000011000001'

CBLOCK 0X20
	aux									;VAR AUX PARA DISTINTOS CALCULOS
	aux_centro							;VAR AUX PARA CALCULAR LA POSICION DEL JOYSTICK
	dato_vel							;DATOS DE VELOCIDAD 
	dato_dir							;Y DIRECCION A ENVIAR
ENDC

#define _adcChVel BCF ADCON0,CHS0		;EJE DE VELOCIDAD COMO ENTRADA DEL ADC		
#define _adcChDir BSF ADCON0,CHS0		;EJE DE DIRECCION COMO ENTRADA DEL ADC
#define _dirAdelante MOVLW 0X05			;DEFINICIONES PARA CONFIGURAR LA DIRECCION
#define _dirAtras MOVLW 0X0A			;DE MOVIMIENTO
#define _dirDer MOVLW 0X0C
#define _dirIzq MOVLW 0X03
#define _dirReposo CLRF dato_dir
#define _mayor BSF aux_centro,0			;DEFINICIONES PARA AVERIGUAR LA POSICION DE 
#define _menor BSF aux_centro,1 		;LOS EJES
#define _centro CLRF aux_centro

ORG 0
GOTO setup
ORG 5
setup			CLRF PORTA				;INICIALIZACIONES
				CLRF PORTC
				BANKSEL ADCON0
				CALL ADC_setup			;CONFIGURACION DEL ADC
				BANKSEL SPBRG
				CALL USART_setup		;CONFIGURACION DEL TRANSMISOR 
				BANKSEL PORTA
				BSF INTCON,PEIE			;PARA LEVANTAR EL MICRO AL FINAL DE LA CONVERSION

main			CLRF dato_vel			;INICIALIZA LOS VALORES DE VEL Y DIRECCION
				CLRF dato_dir
				CLRF TXREG
				_adcChVel				;SENSAR LA VELOCIDAD, CORREGIRLA, Y CALCULAR EL
				CALL sensarAnalog		;DUTY CYCLE PARA ENVIAR
				CALL calcVel
				_adcChDir				;SENSAR LA DIRECCION, CORREGIRLA, Y CALCULAR
				CALL sensarAnalog		;LA LOGICA PARA LA ACTIVACION DE MOTORES
				CALL calcDir			
				MOVF dato_vel,W			;ENVIA LA VELOCIDAD
				CALL txEnviar
				MOVF dato_dir,W			;ENVIA LA CONFIGURACION DE DIRECCION
				CALL txEnviar
				GOTO main

sensarAnalog	BSF ADCON0,ADON			;MUESTREA Y CONVIERTE EL VALOR DEL CANAL 
				CALL ret5us				;SELECCIONADO, RETORNA CON EL RESULTADO EN W
				BSF ADCON0,GO			
				SLEEP
				NOP
				BCF ADCON0,ADON
				BCF PIR1,ADIF
				MOVF ADRESH,W
				RETURN

ret5us			NOP						;RETARDO DE 5us PARA MUESTREO
				NOP
				NOP
				NOP
				NOP
				RETURN

calcVel			CALL compConCentro		;SEGUN LA VELOCIDAD DICE SI VA PARA ADELANTE,
				_dirReposo				;ATRAS O QUEDA EN REPOSO
				BTFSC aux_centro,0
				_dirAdelante
				BTFSC aux_centro,0
				MOVWF dato_dir
				BTFSC aux_centro,1
				_dirAtras
				BTFSC aux_centro,1
				MOVWF dato_dir
				BCF STATUS,C			;DISMINUIR SENCIBILIDAD DEL JOYSTICK (/4)
				RRF aux,F
				BCF STATUS,C			
				RRF aux,W				
				MOVWF dato_vel				
				RETURN			

compConCentro 	_centro
				MOVWF aux				;NOS DICE SI EL JOYSTICK ESTA EL LA POSICION
				MOVLW .127				;CENTRAL, A LA IZQ O A LA DER DEL CENTRO
				SUBWF aux,F				;ADEMAS CALCULA aux = |X-127|, QUE USAMOS PARA
				BTFSS STATUS,C			;CALCULAR LA VELOCIDAD
				_menor
				BTFSS STATUS,C
				COMF aux,F
				BTFSS STATUS,C
				INCF aux,F
				BTFSC STATUS,C
				_mayor
				BTFSC STATUS,Z
				_centro
				RETURN

calcDir			MOVWF aux
				MOVLW .64
				SUBWF aux,W
				BTFSS STATUS,C
				_dirIzq
				BTFSS STATUS,C
				ANDWF dato_dir,F
				BTFSS STATUS,C
				RETURN
				MOVLW .192
				SUBWF aux,W
				BTFSC STATUS,C
				_dirDer
				BTFSC STATUS,C
				ANDWF dato_dir,F
				RETURN			

txEnviar		MOVWF TXREG				;ENVIAR LO QUE ESTE EN W
 				CALL ret5us
				BTFSS PIR1,TXIF			
				GOTO $-1				
				RETURN
  	
;===============CONFIGURACIONES============================================================
ADC_setup		BSF ADCON0,ADCS1		;OSC INT fadc=500KHz, CH0, ADC OFF
				BSF ADCON0,ADCS0
				BANKSEL ADCON1
				CLRF ADCON1				;RES IZQUIERDA, +VREF=VCC, -VREF=GND
				BSF PIE1,ADIE			;HABILITAR INT DEL ADC
				RETURN

USART_setup		MOVLW .49				;BAUDIAGE = 1250, ASYNC, EUSART ON, TX ON				
				MOVWF SPBRG
				CLRF SPBRGH
				BCF TXSTA,SYNC			
				BANKSEL RCSTA					
				BSF RCSTA,SPEN			
				BANKSEL TXSTA
				BSF TXSTA,TXEN			
				RETURN
END				