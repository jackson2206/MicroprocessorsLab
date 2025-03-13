#include <xc.inc>
global  write,write_title
extrn	GLCD_Setup,GLCD_Write_char,GLCD_Write_Message
psect   udata_acs    
counter: ds 1    
psect	udata_bank4 ; reserve data anywhere in RAM
;faulty:	    ds 0x40    
title_screen:
	    ds 256
psect	udat_bank5	    
myplayer:   ds 0x40
charS:	    ds 0x40 
psect	data    
	; ******* myTable, data in programme memory, and its length *****
num0_list:
	db	0x0,0x0,0x3E,0x51,0x49,0x45,0x3E,0x0
	num0_	EQU 8
	align	2
Character:
	db	0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	S_	EQU 8
	align	2
title_screen_list:
	db	0x00, 0x00, 0x00, 0xE0, 0xF0, 0x30, 0x10, 0x10, 0x30, 0x20, 0x00, 0x00, 0x00, 0xF0, 0xF0, 0x10
	db	0x10, 0x10, 0xF0, 0xE0, 0xC0, 0x00, 0x00, 0x00, 0xE0, 0x70, 0xF0, 0x80, 0x00, 0x00, 0x00, 0x00
	db	0xE0, 0x70, 0x30, 0x10, 0x30, 0x70, 0x60, 0x00, 0x00, 0x00, 0xF0, 0x10, 0x10, 0x10, 0x10, 0x10
	db	0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xF0, 0x00, 0x00, 0x00, 0xF0, 0x70, 0xE0, 0x80
	db	0x00, 0x00, 0xF0, 0xF0, 0x00, 0x00, 0x10, 0xF0, 0xE0, 0x00, 0x00, 0x00, 0xC0, 0x70, 0x10, 0x00
	db	0x00, 0x80, 0xE0, 0x70, 0xF0, 0x80, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xF0, 0x10, 0x10, 0x10, 0x30
	db	0xE0, 0xE0, 0x00, 0x00, 0x00, 0xF0, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00, 0xF0, 0xF0
	db	0x10, 0x10, 0x10, 0x30, 0xF0, 0xE0, 0x00, 0x00, 0xE0, 0xE0, 0x30, 0x10, 0x10, 0x30, 0x30, 0x00
	db	0x00, 0x00, 0x00, 0x31, 0x31, 0x31, 0x33, 0x33, 0x32, 0x1E, 0x0C, 0x00, 0x00, 0x3F, 0x3F, 0x02
	db	0x02, 0x02, 0x03, 0x01, 0x00, 0x30, 0x3C, 0x1F, 0x09, 0x08, 0x08, 0x0F, 0x3E, 0x38, 0x00, 0x00
	db	0x1F, 0x38, 0x30, 0x30, 0x30, 0x38, 0x18, 0x00, 0x00, 0x00, 0x3F, 0x33, 0x33, 0x33, 0x33, 0x33
	db	0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x3F, 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x03
	db	0x06, 0x18, 0x3F, 0x3F, 0x00, 0x00, 0x00, 0x01, 0x07, 0x1F, 0x38, 0x1F, 0x07, 0x00, 0x00, 0x30
	db	0x3E, 0x0F, 0x0B, 0x08, 0x09, 0x0F, 0x3E, 0x30, 0x00, 0x00, 0x3F, 0x3F, 0x30, 0x30, 0x30, 0x30
	db	0x1F, 0x1F, 0x00, 0x00, 0x00, 0x3F, 0x33, 0x33, 0x33, 0x33, 0x33, 0x30, 0x00, 0x00, 0x3F, 0x3F
	db	0x03, 0x03, 0x07, 0x0F, 0x39, 0x30, 0x00, 0x10, 0x19, 0x31, 0x31, 0x33, 0x33, 0x32, 0x1E, 0x1E
    
	Sp	EQU	256
	align	2
start_list:	
	db	0x00, 0x00, 0x0C, 0x44, 0x54, 0x54, 0x14, 0x34, 0x00, 0x04, 0x04, 0x7C, 0x7C, 0x04, 0x04, 0x40
	db	0x30, 0x38, 0x24, 0x2C, 0x38, 0x60, 0x40, 0x00, 0x7C, 0x7C, 0x14, 0x14, 0x34, 0x6C, 0x48, 0x04
	db	0x04, 0x04, 0x7C, 0x04, 0x04, 0x04
	St_	EQU	38
	align	2
psect	char_code,class=CODE	
write:
	lfsr	0, myplayer	; Load FSR0 with address in RAM
	movlw	low highword(Character)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(Character)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(Character)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	S_	; bytes to read
	movwf 	counter, A		; our counter register
loop_char: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop_char		; keep going until finished
		

	movlw	S_	; output message to LCD
				; don't send the final carriage return to LCD
	lfsr	2, myplayer
	call	GLCD_Write_char
	clrf	counter,A
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
write_title:
	lfsr	0, title_screen	; Load FSR0 with address in RAM
	movlw	low highword(title_screen_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(title_screen_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(title_screen_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	Sp	; bytes to read
	movwf 	counter, A		; our counter register
loop_title:
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop_title		; keep going until finished
		

	movlw	Sp	; output message to LCD
				; don't send the final carriage return to LCD
	lfsr	2, title_screen
	call	GLCD_Write_Message ; command must be different
	clrf	counter,A
	return	
	