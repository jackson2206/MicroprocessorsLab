	#include <xc.inc>

psect	code, abs
	
main:    
	org	0x0
	goto	start
	org	0x100		    ; Main code starts here at address 0x100
start:	
	call	SPI_MasterInit
	movlw 	0x00
	movwf   PORTC ,A
	movlw   0x00
	movwf	TRISE, A; Port C all outputs
	movlw   0xFF
	movwf   TRISC ,A
	
   
loop:
	clrf 0x06, A		;clear register
	clrf 0x07, A
	movff   0x06, PORTE	;output values to port C
	movf    0x07, W, A	;load direction
 
 
increase:
	incf	0x06, F, A	;increment value
	movf	0x06, W, A	;update to W
	movwf	PORTE, A
	call	SPI_MasterTransmit
	call	delay
	movlw	0XFF		;compare with 255
	cpfseq	0x06, A		;if not equal, continue
	bra	increase
	movlw	0x01		;direction to dec
	movwf	0x07, A		
 
decrease:
	decf	0x06, F, A	;decrement
	movf	0x06, W, A	;load to W
	movwf	PORTE, A
	call	SPI_MasterTransmit
	call	delay
	movlw	0x00		;comparw with 0
	cpfseq	0x06, A		;if not equal, continue
	bra	decrease
	bra	loop
 
delay:  
	movf    PORTC ,W ,A
	movwf   0x10, A	
	movlw	low(0xFFFF)
	movwf	0x11, A
bigdelay:
	decfsz	0x11, F, A	;dec and check if 0
	bra	bigdelay
	decfsz	0x10, F, A
	bra	bigdelay	;stay in delay loop
	return

SPI_MasterInit:	; Set Clock edge to negative	
    bcf	CKE2	; CKE bit in SSP2STAT,
    ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)	
    movlw 	(SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)	
    movwf 	SSP2CON1, A	; SDO2 output; SCK2 output	
    bcf	TRISD, PORTD_SDO2_POSN, A	; SDO2 output	
    bcf	TRISD, PORTD_SCK2_POSN, A	; SCK2 output
    return  ; Start transmission of data (held in W)
 	
	
SPI_MasterTransmit:
    movwf 	SSP2BUF, A 	; write data to output buffer
    
Wait_Transmit:	; Wait for transmission to complete 	
    btfss 	PIR2, 5		; check interrupt flag to see if data has been sent	
    bra 	Wait_Transmit
    bcf 	PIR2, 5		; clear interrupt flag	
    return 	
	
	
end	main	
