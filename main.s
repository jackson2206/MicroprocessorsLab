#include <xc.inc>
extrn   Keypad_Setup, Keypad_read
extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex,LCD_Send_Byte_D,LCD_Clear,LCD_Shift_down,LCD_Shift_up,LCD_up_down
 ; external LCD subroutines
extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
adrr:	    ds 1 
up:	    ds 1    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data
psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'H','e','l','l','o',' ','W','o','r','l','d','!',0x0a
					; message, plus carriage return
	myTable_l   EQU	13	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
        clrf    PORTD,A
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	call    ADC_Setup   ; setup ADC
	call    Keypad_Setup
	call    Keypad_read
	movlw	0x0
	movwf	up,A
	goto	read
	
read:
	movlw   0xBB
	movwf   adrr,A
	call    delay
	call    Keypad_read
	call    delay
	call	LCD_up_down
	movf    adrr,W,A
	call    LCD_Send_Byte_D
	goto    read
	

	goto    $
	;call    LCD_Send_Byte_D
;	; ******* Main programme ****************************************
;start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
;	movlw	low highword(myTable)	; address of data in PM
;	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
;	movlw	high(myTable)	; address of data in PM
;	movwf	TBLPTRH, A		; load high byte to TBLPTRH
;	movlw	low(myTable)	; address of data in PM
;	movwf	TBLPTRL, A		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter, A		; our counter register
;loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter, A		; count down to zero
;	bra	loop		; keep going until finished
;		
;	movlw	myTable_l	; output message to UART
;	lfsr	2, myArray
;	call	UART_Transmit_Message
;
;	movlw	myTable_l-1	; output message to LCD
;				; don't send the final carriage return to LCD
;	lfsr	2, myArray
;	call	LCD_Write_Message
;	goto    $
;;measure_loop:
;;	call	ADC_Read
;;	movf	ADRESH, W, A
;;	call	LCD_Write_Hex
;;	movf	ADRESL, W, A
;;	call	LCD_Write_Hex
;;	goto	measure_loop		; goto current line in code
;	
	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst