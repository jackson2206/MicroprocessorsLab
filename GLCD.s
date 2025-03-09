#include <xc.inc>

global  GLCD_Setup,Set_Xaddress,Set_display,GLCD_Send_Byte_D,GLCD_Write_Message,Set_Yaddress,clear_page

psect	udata_acs   ; named variables in access ram
GLCD_cnt_l:	ds 1	; reserve 1 byte for variable LCD_cnt_l
GLCD_cnt_h:	ds 1	; reserve 1 byte for variable LCD_cnt_h
GLCD_cnt_ms:	ds 1	; reserve 1 byte for ms counter
GLCD_tmp:	ds 1	; reserve 1 byte for temporary use
GLCD_counter:	ds 1	; reserve 1 byte for counting through nessage
GLCD_cnt:       ds 1   ; one byte for data
YADD:		ds 1
pg:		ds 1    
clear_cnt1:	ds 1
clear_cnt2:	ds 1

GLCD_CS1    EQU 0
GLCD_CS2    EQU 1
GLCD_RS	    EQU 2
GLCD_E	    EQU 4
GLCD_RST    EQU 5
GLCD_RW	    EQU 3    

psect	Glcd_code,class=CODE

GLCD_Setup:
	clrf	TRISH,A
	clrf	PORTH,A
	clrf	TRISD,A ; set LATD as output
	clrf	LATD,A	; empty LATD
	clrf	LATB,A ; clear LATB
	movlw	0xC0
	movwf	TRISB,A 
	bcf	LATB,GLCD_CS1,A ; set display 1 to active
	bcf	LATB,GLCD_CS2,A ; set display 2 to active
	bsf	LATB,GLCD_RST,A ; set reset high 
	nop
	nop
	bcf	LATB,GLCD_RW,A ; set RW bit to 0
	bcf	LATB,GLCD_RST,A ; resets the display for new run
	nop
	nop
	nop
	nop
	bsf	LATB,GLCD_RST,A ; reset pin high in operation
	movlw	0
	call	display_on_off ; turns display off
	call	Clear_display
	movlw	1
	call	display_on_off ; turns display on
	return
	
display_on_off:
	addlw	0x3E
	call	GLCD_Send_Byte_I
	return
;;~~~~~~~~~~~~~~~~~~~~ backend code
	
GLCD_Send_Byte_I:	    ; Transmits byte stored in W to instruction reg
	bcf	LATB,GLCD_E,A ;enable pin low
	nop
	movwf	LATD,A
	bcf	LATB,GLCD_RS,A ; set RS=0
	bcf	LATB,GLCD_RW,A
	nop
	bsf	LATB,GLCD_E,A ; enable pin high
	movlw	1
	call	GLCD_delay_x4us ; 4 us delay
	nop
	bcf	LATB,GLCD_E,A ; enable pin low
	nop
	movlw	1
	call	GLCD_delay_x4us
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
	movlw	1
	call	GLCD_delay_x4us ; 3 ms delay
	nop
	bcf	LATB,GLCD_E,A ; enable pin low
	nop
	movlw	1
	call	GLCD_delay_x4us
	nop
	return

choose_display1: ; chooses which display to write to
	bsf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	bcf	LATB,GLCD_CS1,A
	nop
	nop
	nop
	return
choose_display2:
	bsf	LATB,GLCD_CS1,A
	nop
	nop
	nop
	bcf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	return
choose_both:
	bcf	LATB,GLCD_CS1,A
	bcf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	nop
	return
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
Set_Xaddress: ; sets the page of the display
    ; input position as decimal, will add 0xB8 to it to get correct address always specify after y address
	addlw	0xB8
	call	GLCD_Send_Byte_I
	return	

	
Set_Yaddress: ; set yaddress of page
	addlw	0x40
	call	GLCD_Send_Byte_I
	return



	
Set_display:	; takes y address in wreg and sets display
	clrf	YADD,A
	movwf	YADD,A
	movlw	63  
	cpfslt	YADD,A ; if f reg is greater than w  bra is skipped
	bra	dos
	call	choose_display1
	movf	YADD,W,A
	call	Set_Yaddress
	return
dos:
	call	choose_display2
	movlw	64
	subwf	YADD,W,A ; moves value into w
	call	Set_Yaddress
	return
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  writing    
	
	
GLCD_Write_Message:	    ; Message stored at FSR2, length stored in W
	movwf   GLCD_counter, A
	movlw	0
	call	Set_Xaddress
	movlw	0
	call	Set_display
GLCD_Loop_message:
	movf    POSTINC2, W, A
	call    GLCD_Send_Byte_D
	decfsz  GLCD_counter, A
	bra	GLCD_Loop_message
	return	
Clear_display:
	movlw	7
	movwf	clear_cnt2,A
	call	choose_both
clear:	
	movf	clear_cnt2,W,A
	call	clear_page
	decfsz	clear_cnt2,A
	bra	clear
	return
	
clear_page:  ; takes page i.e Xaddress and clears the entire row of 1 display
	movwf	pg,A
	movlw	64
	movwf	clear_cnt1,A
	movlw	0
	call	Set_Yaddress
	movf	pg,W,A
	call	Set_Xaddress
page_loop:
	movlw	0
	call	GLCD_Send_Byte_D
	movff	clear_cnt1,PORTH
	decfsz	clear_cnt1,A
	bra	page_loop
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
