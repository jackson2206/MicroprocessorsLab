	#include <xc.inc>

psect	code, abs
	
main:    
	org	0x0
	goto	start
	org	0x100		    ; Main code starts here at address 0x100
start:	
	movlw 	0x00
	movwf	TRISD, A	; Port C all outputs
 
loop:
	clrf 0x06, A		;clear register
	clrf 0x07, A
	movff   0x06, PORTD	;output values to port C
	movf    0x07, W, A	;load direction
 
 
increase:
	incf	0x06, F, A	;increment value
	movf	0x06, W, A	;update to W
	movwf	PORTD, A
	call	delay
	movlw	0XFF		;compare with 255
	cpfseq	0x06, A		;if not equal, continue
	bra	increase
	movlw	0x01		;direction to dec
	movwf	0x07, A		
 
decrease:
	decf	0x06, F, A	;decrement
	movf	0x06, W, A	;load to W
	movwf	PORTD, A
	call	delay
	movlw	0x00		;comparw with 0
	cpfseq	0x06, A		;if not equal, continue
	bra	decrease
	bra	loop
 
delay: 
	movlw   high(0x11ED)
	movwf   0x10, A	
	movlw	low(0x11ED)
	movwf	0x11, A
bigdelay:
	decfsz	0x11, F, A	;dec and check if 0
	bra	bigdelay
	decfsz	0x10, F, A
	bra	bigdelay	;stay in delay loop
	return

end	main	
