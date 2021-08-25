__CONFIG _CONFIG1, 0X20F4
    LIST P=16F887
    #include <P16F887.inc>
    
    #define LED PORTB,RB0
    
    CBLOCK 0X20
	v_l
	v_h
	v_uh
    ENDC
    
    ORG 0X00
    GOTO setup
    ORG 0X04
    ;GOTO INTSR
    ORG 0X05
    
    setup       MOVLW 0X6C
                BANKSEL OSCCON
                MOVWF OSCCON
		
		BANKSEL TRISB
		MOVLW 0XFE
		MOVWF TRISB
		
		BANKSEL ANSELH
		CLRF ANSELH
		
		BANKSEL PORTB
		CLRF PORTB
		
    
    main	CLRF v_l	    
		COMF v_l	    ;v_l = 255
		CLRF v_h	    
		COMF v_h	    ;v_h = 255
		MOVLW 0X04
		MOVWF v_uh	    ;v_uh = 4
;----------------------------------------------------------------------------
    cuenta	DECFSZ v_l	    
		GOTO cuenta
		DECF v_l	    ;(255-1)3 + 2 = 764 + 1 = 765 inst
;----------------------------------------------------------------------------
		DECFSZ v_h	    ;Llamar cuenta 254 veces mas	    
		GOTO cuenta
		DECF v_h	    ;(765)(254)3 + 2 = 582932 + 1 = 582933 inst
		DECFSZ v_uh	    ;Repite todo 3 veces mas 
		GOTO cuenta
		
		COMF PORTB          ;(582933)3*3 + 2 = 5246390 inst
		GOTO main
END

		;SI X EN LA PRECARGA, Y SE LLAMA V VECES EL BUCLE: 
		;[ (x-1)3 + 2 ](v-1)3 + 2 [inst]
		
    
    
    