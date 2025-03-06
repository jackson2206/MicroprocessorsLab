#include <xc.inc>

global  GLCD_Setup,Set_Xaddress,Set_yaddress,GLCD_Send_Byte_D

psect	udata_acs   ; named variables in access ram
GLCD_cnt_l:	ds 1	; reserve 1 byte for variable LCD_cnt_l
GLCD_cnt_h:	ds 1	; reserve 1 byte for variable LCD_cnt_h
GLCD_cnt_ms:	ds 1	; reserve 1 byte for ms counter
GLCD_tmp:	ds 1	; reserve 1 byte for temporary use
GLCD_counter:	ds 1	; reserve 1 byte for counting through nessage
GLCD_cnt:       ds 1   ; one byte for data
YADD:		ds 1 
B_:		ds 1

GLCD_CS1    EQU 0
GLCD_CS2    EQU 1
GLCD_RS	    EQU 2
GLCD_E	    EQU 4
GLCD_RST    EQU 5
GLCD_RW	    EQU 3    

psect	Glcd_code,class=CODE

GLCD_Setup:
	clrf	TRISD
	clrf	LATD
	clrf	LATB
	movlw	0xC0
	andwf	TRISB,f,A
	bsf	LATB,GLCD_RST,A
	nop
	nop
	bcf	LATB,GLCD_RW,A
	bcf	LATB,GLCD_RST,A ; resets the display for new run
	nop
	nop
	nop
	nop
	bsf	LATB,GLCD_RST,A ; high in operation
	movlw	0
	call	display_on_off ; turns display off
	movlw	0
	call	Set_Xaddress
	movlw	0
	call	Set_Yaddress
	movlw	1
	call	display_on_off ; turns display on
	return
display_on_off:
	addlw	0x3E
	bsf	LATB,GLCD_CS1,A
	bsf	LATB,GLCD_CS2,A
	call	GLCD_Send_Byte_I
	return
	
;LCD_Write_Message:	    ; Message stored at FSR2, length stored in W
;	movwf   LCD_counter, A
;LCD_Loop_message:
;	movf    POSTINC2, W, A
;	call    LCD_Send_Byte_D
;	decfsz  LCD_counter, A
;	bra	LCD_Loop_message
;	return

GLCD_Send_Byte_I:	    ; Transmits byte stored in W to instruction reg
	bcf	LATB,GLCD_E,A ;enable pin low
	nop
	nop
	movwf	LATD,A
	bcf	LATB,GLCD_RS,A ; SET RS=0
	bcf	LATB,GLCD_RW,A
	nop
	bsf	LATB,GLCD_E,A ; enable pin high
	movlw	3
	call	GLCD_delay_ms ;  3 ms delay
	nop
	bcf	LATB,GLCD_E,A ; enable pin low
	nop
	movlw	3
	call	GLCD_delay_ms 
	nop
	return
GLCD_Send_Byte_D: ; transmits byte in wreg to data
	bcf	LATB,GLCD_E,A ;enable pin low
	nop
	movwf	LATD,A
	bsf	LATB,GLCD_RS,A ; set RS=1
	bcf	LATB,GLCD_RW,A
	nop
	bsf	LATB,GLCD_E,A ; enable pin high
	movlw	3
	call	GLCD_delay_ms ; 3 ms delay
	nop
	bcf	LATB,GLCD_E,A ; enable pin low
	nop
	movlw	3
	call	GLCD_delay_ms
	nop
	return
Set_Xaddress: ; sets the page of the display
    ; input position as decimal, will add 0xB8 to it to get correct address
	addlw	0xB8
	bsf	LATB,GLCD_CS1,A
	bsf	LATB,GLCD_CS2,A
	call	GLCD_Send_Byte_I
	return
Set_yaddress: ; sets the column of the display
    ;input the column number between 0 ~ 127
	movwf	YADD,A
	addlw	64
	cpfsgt	YADD,A
	bra	display_1
display2:
	movf	YADD,W,A
	bsf	LATB,GLCD_CS2,A
	bcf	LATB,GLCD_CS1,A
	call	GLCD_Send_Byte_D
	return
display1:
	movf	YADD,W,A
	bsf	LATB,GLCD_CS1,A
	bcf	LATB,GLCD_CS2,A
	call	GLCD_Send_Byte_D
	return	
; ** a few delay routines below here as LCD timing can be quite critical ****
GLCD_delay_ms:		    ; delay given in ms in W
	movwf	GLCD_cnt_ms, A
Glcdlp2:movlw	250	    ; 1 ms delay
	call	GLCD_delay_x4us	
	decfsz	GLCD_cnt_ms, A
	bra	Glcdlp2
	return
    
GLCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	GLCD_cnt_l, A	; now need to multiply by 16
	swapf   GLCD_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	GLCD_cnt_l, W, A ; move low nibble to W
	movwf	GLCD_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	GLCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	GLCD_delay
	return

GLCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
Glcdlp1:decf 	GLCD_cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	GLCD_cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	Glcdlp1		; carry, then loop again
	return			; carry reset so return
end
