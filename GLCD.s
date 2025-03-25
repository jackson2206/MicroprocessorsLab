#include <xc.inc>

global  GLCD_Setup,Set_Xaddress,Set_display,GLCD_Send_Byte_D,Set_Yaddress,clear_page,Set_display,Clear_display,clear_page,GLCD_delay_ms
global	GLCD_Write_player,GLCD_Write_Title,GLCD_Write_bullet,YADD,choose_both,GLCD_Write_Enemy,GLCD_delay_x4us,Draw_endscreen
global	Write_num0,Write_num1,Write_num2,Write_num3,Write_num4,Write_num5,Write_num6,Write_num7,Write_num8,Write_num9,start_animation 	
extrn	Keypad_Setup,Keypad_Move_Char
psect	data    
	; ******* myTable, data in programme memory, and its length *****
num0_list:
	db	0x0,0x0,0x3E,0x51,0x49,0x45,0x3E,0x0
	num0_	EQU 0
	num	EQU 8
	align	2
num1_list:
	db	0x00, 0x00, 0x00, 0x42, 0x7F, 0x40, 0x00, 0x00
	num1_	EQU 1
	align	2
num2_list:
	db	0x00, 0x00, 0x42, 0x61, 0x51, 0x49, 0x46, 0x00
	num2_	EQU 2
num3_list:
	db	0x00, 0x00, 0x21, 0x41, 0x45, 0x4B, 0x31, 0x00
	align	2
num4_list:
	db	0x00, 0x00, 0x18, 0x14, 0x12, 0x7F, 0x10, 0x00
	align	2
num5_list:
	db	0x00, 0x00, 0x27, 0x45, 0x45, 0x45, 0x39, 0x00
	align	2
num6_list:
	db	0x00, 0x00, 0x3C, 0x4A, 0x49, 0x49, 0x30, 0x00
	align	2
num7_list:
	db	0x00, 0x00, 0x01, 0x01, 0x71, 0x0D, 0x03, 0x00
	align	2
num8_list:
	db	0x00, 0x00, 0x36, 0x49, 0x49, 0x49, 0x36, 0x00
	align	2
num9_list:
	db	0x00, 0x00, 0x06, 0x49, 0x49, 0x29, 0x1E, 0x00
	align	2
	
Character:
	db	0xF0, 0xF8, 0xF8, 0xFE, 0xFE, 0xF8, 0xF8, 0xF0
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
Game_over:
	db	0x00, 0x00, 0x80, 0xE0, 0x30, 0x30, 0x30, 0x20, 0x00, 0x00, 0x00, 0x80, 0x60, 0xF0, 0x80, 0x00
	db	0x00, 0x80, 0xF0, 0xF0, 0x00, 0xC0, 0xF0, 0xE0, 0x00, 0x00, 0xF0, 0xB0, 0xB0, 0xB0, 0xB0, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x20, 0x30, 0x30, 0x30, 0x60, 0xC0, 0x00, 0xF0, 0x80, 0x00
	db	0x80, 0xF0, 0x30, 0x00, 0xF0, 0xB0, 0xB0, 0xB0, 0xB0, 0x00, 0xF0, 0x30, 0x30, 0x20, 0xE0, 0xC0
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x0F, 0x0C, 0x09, 0x0D, 0x0D, 0x03, 0x01, 0x0C, 0x07, 0x03, 0x02, 0x03, 0x0F, 0x08
	db	0x0C, 0x0F, 0x01, 0x03, 0x0E, 0x07, 0x00, 0x0F, 0x0C, 0x00, 0x0F, 0x09, 0x09, 0x09, 0x09, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x01, 0x07, 0x0C, 0x08, 0x08, 0x0C, 0x07, 0x01, 0x00, 0x00, 0x0F, 0x0C
	db	0x07, 0x00, 0x00, 0x00, 0x0F, 0x09, 0x09, 0x09, 0x09, 0x00, 0x0F, 0x03, 0x03, 0x07, 0x0D, 0x0C
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	align	2
	game_l	EQU 256
bullet_mp:
	db	0x00,0x00,0x00,0x0F,0x0F,0x00,0x00,0x00
	align	2
	bull	EQU 8
enemy:
	db	0x18, 0x7D, 0xA6, 0x3C, 0x3C, 0xA6, 0x7D, 0x18
	align	2
	en	EQU 8
	
psect	udata_acs   ; named variables in access ram
GLCD_cnt_l:	ds 1	; reserve 1 byte for variable LCD_cnt_l
GLCD_cnt_h:	ds 1	; reserve 1 byte for variable LCD_cnt_h
GLCD_cnt_ms:	ds 1	; reserve 1 byte for ms counter
GLCD_tmp:	ds 1	; reserve 1 byte for temporary use
GLCD_counter:	ds 1	; reserve 1 byte for counting through nessage
GLCD_cnt:       ds 1   ; one byte for data
YADD:		ds 1 ; yaddress 0-128
pg:		ds 1 ;   page number 0-7
clear_cnt1:	ds 1	;   tmp counter
clear_cnt2:	ds 1   ;   tmp counter

GLCD_CS1    EQU 0   ; set low to choose section 1
GLCD_CS2    EQU 1   ; set low to choose section 2
GLCD_RS	    EQU 2   ; set high to write instruction to chipset, low to write data
GLCD_E	    EQU 4   ; pulse to write information to chipset
GLCD_RST    EQU 5   ; reset LCM
GLCD_RW	    EQU 3   ; set low to write instructions/ high to read	 

psect	Glcd_code,class=CODE

GLCD_Setup:
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
	movlw	1
	call	display_on_off ; turns display on
	call	Keypad_Setup
	call	Clear_display
	return
	
display_on_off:  ; if 1 in wreg display on if 0 display off
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

choose_display1: ; chooses display 1
	bsf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	bcf	LATB,GLCD_CS1,A
	nop
	nop
	nop
	return
choose_display2: ; chooses display 2
	bsf	LATB,GLCD_CS1,A
	nop
	nop
	nop
	bcf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	return
choose_both: ; give command to both control chips
	bsf	LATB,GLCD_CS1,A
	bsf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	bcf	LATB,GLCD_CS1,A
	bcf	LATB,GLCD_CS2,A
	nop
	nop
	nop
	return
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~####################	
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
	movlw	64 
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
	
Clear_display:
	movlw	7
	movwf	clear_cnt2,A
	call	choose_both
clear:	
	movf	clear_cnt2,W,A
	call	clear_page
	decfsz	clear_cnt2,A
	bra	clear
	movlw	0
	call	clear_page
	return
	
clear_page:  ; takes page i.e Xaddress and clears the entire row of 1 display
	movwf	pg,A
	movlw	65
	movwf	clear_cnt1,A
	movlw	0
	call	Set_Yaddress
page_loop:
    	movf	pg,W,A
	call	Set_Xaddress
	movlw	0
	call	GLCD_Send_Byte_D
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
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
GLCD_Write_player:
    	call	Clear_display
	call	Keypad_Move_Char
	movwf	YADD,A
	movf	YADD,W,A
	call	Set_display
	movlw	7
	call	Set_Xaddress
write:	
	movlw	low highword(Character)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(Character)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(Character)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	S_	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
loop_char: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf	TABLAT,W,A ; move data from TABLAT to WREG
	call	GLCD_Send_Byte_D
	
	decfsz	GLCD_counter, A		; count down to zero
	bra	loop_char		; keep going until finished
	movf	YADD,W,A
	return
GLCD_Write_Title:
Gen:
    movlw   low highword(title_screen_list)
    movwf   TBLPTRU,A
    movlw   high(title_screen_list)
    movwf   TBLPTRH,A
    movlw   low(title_screen_list)
    movwf   TBLPTRL,A
    movlw   Sp
    movwf   GLCD_counter,A
    movlw   2
    movwf   pg,A
    movlw   0
    movwf   YADD,A
looping:
    movf    YADD,W,A
    call    Set_display
    movf    pg,W,A
    call    Set_Xaddress
    tblrd*+ 
    movf    TABLAT,W,A
    call    GLCD_Send_Byte_D
    INCF    YADD,f,A
    DECFSZ  GLCD_counter,A ; skips if equal to zero
    bra	    n2dloop
    return
n2dloop:    
    movlw   128
    cpfseq  YADD,A
    bra	    looping
    INCF    pg,f,A
    MOVLW   0
    MOVWF   YADD,A
    movlw   8
    cpfseq  pg,A
    bra	    looping
    return
GLCD_Write_bullet:
    
	movlw	low highword(bullet_mp)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(bullet_mp)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(bullet_mp)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	bull	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
loop_bullet: 	tblrd*+		; one byte from PM to TABLAT, increment TBLPRT
	movf	TABLAT,W,A ; move data from TABLAT to WREG
	call	GLCD_Send_Byte_D
	
	decfsz	GLCD_counter, A		; count down to zero
	bra	loop_bullet		; keep going until finished
	return  
	
	
	
	
	
GLCD_Write_Enemy:
    	movlw	low highword(enemy)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(enemy)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(enemy)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	en	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
loop_enemy:
        tblrd*+		; one byte from PM to TABLAT, increment TBLPRT
	movf	TABLAT,W,A ; move data from TABLAT to WREG
	call	GLCD_Send_Byte_D
	
	decfsz	GLCD_counter, A		; count down to zero
	bra	loop_enemy	; keep going until finished
	return
Write_num0:
        movlw	low highword(num0_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num0_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num0_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
loop_num:
        tblrd*+		; one byte from PM to TABLAT, increment TBLPRT
	movf	TABLAT,W,A ; move data from TABLAT to WREG
	call	GLCD_Send_Byte_D
	
	decfsz	GLCD_counter, A		; count down to zero
	bra	loop_num	; keep going until finished
	return
Write_num1:
        movlw	low highword(num1_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num1_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num1_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num2:
        movlw	low highword(num2_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num2_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num2_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num3:
        movlw	low highword(num3_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num3_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num3_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num4:
        movlw	low highword(num4_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num4_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num4_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num5:
        movlw	low highword(num5_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num5_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num5_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num6:
        movlw	low highword(num6_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num6_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num6_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num7:
        movlw	low highword(num7_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num7_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num7_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num8:
        movlw	low highword(num8_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num8_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num8_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num
Write_num9:
        movlw	low highword(num9_list)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(num9_list)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(num9_list)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	8	; bytes to read
	movwf 	GLCD_counter, A		; our counter register
	bra	loop_num

Draw_endscreen:
    Ggen:
    movlw   low highword(Game_over)
    movwf   TBLPTRU,A
    movlw   high(Game_over)
    movwf   TBLPTRH,A
    movlw   low(Game_over)
    movwf   TBLPTRL,A
    movlw   256
    movwf   GLCD_counter,A
    movlw   2
    movwf   pg,A
    movlw   0
    movwf   YADD,A
glooping:
    movf    YADD,W,A
    call    Set_display
    movf    pg,W,A
    call    Set_Xaddress
    tblrd*+ 
    movf    TABLAT,W,A
    call    GLCD_Send_Byte_D
    INCF    YADD,f,A
    DECFSZ  GLCD_counter,A ; skips if equal to zero
    bra	    gn2dloop
    return
gn2dloop:    
    movlw   128
    cpfseq  YADD,A
    bra	    glooping
    INCF    pg,f,A
    MOVLW   0
    MOVWF   YADD,A
    movlw   8
    cpfseq  pg,A
    bra	    glooping
    return

start_animation:
    movlw   0
    call    Set_Xaddress
    movlw   0
    movwf   YADD,A
l:    
    movf    YADD,W,A
    call    Set_display
    call    GLCD_Write_Enemy
    movlw   500
    call    GLCD_delay_ms
    movlw   8
    addwf   YADD,W,A
    movlw   128
    cpfseq  YADD,A
    bra	    l
    
end
