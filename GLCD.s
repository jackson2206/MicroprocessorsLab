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
PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM

GLCD_CS1    EQU 0
GLCD_CS2    EQU 1
GLCD_RS	    EQU 2
GLCD_E	    EQU 4
GLCD_RST    EQU 5	    

psect	Glcd_code,class=CODE

GLCD_Setup:	
	movlw	64
	movwf	YADD,A
	clrf    LATB, A
	clrf	LATD,A
	clrf	TRISB,A
	clrf	TRISD,A
	bsf	LATB,GLCD_RST,A
	bsf	LATB,GLCD_CS1,A
	bsf	LATB,GLCD_CS2,A
	movlw	20
	
	movlw	0x0
	call	Display_on_off
	movlw	0x0
	call	Set_Xaddress
	movlw	0
	call	Set_yaddress
	movlw	0
	call	Set_zaddress
	movlw	1
	call	Display_on_off
	
	
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
	movwf   LATD, A	    ; output data bits to LCD
	bcf	LATB, GLCD_RS, A	; Instruction write clear RS bit
	call    GLCD_Enable  ; Pulse enable Bit 
	
	return
GLCD_Send_Byte_D:
	movwf	LATD,A
	bsf	LATB,GLCD_RS,A
	call	GLCD_Enable
	movlw	10	    ; delay 40us
	call	GLCD_delay_x4us
Display_on_off:
	    addlw   0x0
	    call    GLCD_Send_Byte_I
	    call    GLCD_delay
	    return
	
Set_zaddress:
	    addlw   0xC0
	    call    GLCD_Send_Byte_I
	    call    GLCD_delay
	    return
Set_Xaddress: ; takes the page number in WREG
	    addlw   0xB8
	    call    GLCD_Send_Byte_I
	    call    GLCD_delay
	    return
Set_yaddress:
	    ; takes y address, if yaddress is greater than 63 cs2 pin enabled
	    cpfslt  YADD,A
	    bra	    nd_display
st_display: 
	    bsf	    LATB,GLCD_CS1,A
	    bcf	    LATB,GLCD_CS2,A
	    call    GLCD_Enable
	    addlw   0x40
	    call    GLCD_Send_Byte_I
	    call    GLCD_delay
	    return 
nd_display:
	    bsf	    LATB,GLCD_CS2,A
	    bcf	    LATB,GLCD_CS1,A
	    call    GLCD_Enable
	    sublw   64
	    addlw   0x40
	    call    GLCD_Send_Byte_I
	    call    GLCD_delay
	    return    
GLCD_Enable:	    ; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	LATB, GLCD_E, A	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	call	GLCD_delay
	call	GLCD_delay
	bcf	LATB, GLCD_E, A	    ; Writes data to LCD
	return
;	
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
