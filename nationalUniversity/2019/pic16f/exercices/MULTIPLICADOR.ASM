;DISMINUIR ADVERTENCIAS MOLESTAS
errorlevel -203, -205, -302				
LIST P=16F887
#include <P16F887.inc>
;CONFIG: MCLR OFF, WATCH-GOG OFF, OSCILADOR INTOSCIO, TODO LO DEMAS OFF
__CONFIG _CONFIG1,b'1110000011010100'

CBLOCK 0X20
	paso								;SI SON 5v, A 8bits -> VEMOS 500 -> paso = 500/255 
	ADC									;SERIA EL Byte MAS SIGNIFICATIVO DEL ADC (PARA 8bits)
	res_L								;RESULTADOS DE LA MULTIPLICACION: ADC x paso
	res_H
	cent_offset							;VARIABLES PARA BUSCAR EN LA TABLA
	dec_offset
	unid_offset
	CENT								;VALORES FINALES, QUE TENDRIAN QUE IR A LOS DISPLAYS
	DEC
	UNID
ENDC

ORG 0
GOTO setup
ORG 5
setup			MOVLW .2				;INICIALIZACIONES
				MOVWF paso				;

main			;CALL convertir			;NO LO HICE TODAVIA xD
				CALL multiplicar		;SI 255 SON 500 EN EL DISP -> ADC x paso = RESULTADO
				CALL calcOffsets		;SACA LA CENT, DEC Y UNIDADES DEL RESULTADO
				CALL corregirOffsets	;CORRIGE SI POR EJEMPLO LAS DEC = 10 -> CENT++
				CALL mostrarRes			;ACA HABRIA QUE HACER EL MULTIPLEXADO DE DISPLAYS
				GOTO main
					

multiplicar		CLRF res_L				;INICIALIZA
				CLRF res_H
M1				MOVF paso,W				;SUMA ADC VECES EL PASO = ADC x paso Y GUARDA EN 2Bytes
				ADDWF res_L,F
				BTFSC STATUS,C
				INCF res_H,F
				BCF STATUS,C
				DECFSZ ADC
				GOTO M1
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
				GOTO CD					;EN ESTE CASO NO HAY MILLARES ASI QUE NO HACE FALTA PARA LAS CENTENAS
				RETURN

mostrarRes		MOVF cent_offset,W		;DEBERIA SER EL MULTIPLEXADO
				CALL TAB_res
				MOVWF CENT
				MOVF dec_offset,W
				CALL TAB_res
				MOVWF DEC
				MOVF unid_offset,W
				CALL TAB_res
				MOVWF UNID
				RETURN				

TAB_res			ADDWF PCL,F				;ACA IRIA EN 7seg PARA EL MULTIPLEXADO
				RETLW .0		
				RETLW .1
				RETLW .2
				RETLW .3
				RETLW .4
				RETLW .5
				RETLW .6
				RETLW .7
				RETLW .8
				RETLW .9
				RETURN												
END
				
										