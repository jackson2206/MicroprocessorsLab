#include <xc.inc>

global  GLCD_Setup

psect	udata_acs   ; named variables in access ram
LCD_cnt_l:	ds 1	; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1	; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms:	ds 1	; reserve 1 byte for ms counter
LCD_tmp:	ds 1	; reserve 1 byte for temporary use
LCD_counter:	ds 1	; reserve 1 byte for counting through nessage
LCD_cnt:        ds 1   ; one byte for data
PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
LCD_hex_tmp:	ds 1    ; reserve 1 byte for variable LCD_hex_tmp

GLCD_CS1    EQU 1
GLCD_CS2    EQU 2
GLCD_RS	    EQU 5
GLCD_E	    EQU 7	    

psect	lcd_code,class=CODE
    
GLCD_Setup:
	clrf    LATB, A
	movlw   11000000B	    ; RB0:5 all outputs
	movwf	TRISB, A
	movlw   40
	call	LCD_delay_ms	; wait 40ms for LCD to start up properly
	movlw	00111110B
	call	LCD_Send_Byte_I
	movlw	40
	call	LCD_delay_ms
	movlw	0x40
	call	LCD_Send_Byte_I
	movlw	40
	call	LCD_delay_ms
	movlw	0xC0
	call	LCD_Send_Byte_I
	movlw	0x3F
	call	LCD_Send_Byte_I
	return
	
	
;LCD_Write_Message:	    ; Message stored at FSR2, length stored in W
;	movwf   LCD_counter, A
;LCD_Loop_message:
;	movf    POSTINC2, W, A
;	call    LCD_Send_Byte_D
;	decfsz  LCD_counter, A
;	bra	LCD_Loop_message
;	return

LCD_Send_Byte_I:	    ; Transmits byte stored in W to instruction reg
	movwf   LCD_tmp, A
	swapf   LCD_tmp, W, A   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB, A	    ; output data bits to LCD
	bcf	LATB, GLCD_RS, A	; Instruction write clear RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movf	LCD_tmp, W, A   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB, A	    ; output data bits to LCD
	bcf	LATB, GLCD_RS, A	; Instruction write clear RS bit
        call    LCD_Enable  ; Pulse enable Bit 
	return


LCD_Enable:	    ; pulse enable bit LCD_E for 500ns
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
	bcf	LATB, GLCD_E, A	    ; Writes data to LCD
	return
;	

; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms:		    ; delay given in ms in W
	movwf	LCD_cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms, A
	bra	lcdlp2
	return
    
LCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l, A	; now need to multiply by 16
	swapf   LCD_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l, W, A ; move low nibble to W
	movwf	LCD_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	LCD_cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return


end
;
;
;#include <xc.inc>

global GLCD_Setup
;
;; Define control pins for GLCD
;GLCD_CS1   EQU 1       ; Chip Select 1 (CS1) connected to pin 1
;GLCD_CS2   EQU 2       ; Chip Select 2 (CS2) connected to pin 2
;GLCD_RS    EQU 5       ; Register Select (RS) connected to pin 5
;GLCD_E     EQU 7       ; Enable (E) connected to pin 7

; Define some variables in the data section
;psect udata_acs   ; named variables in access ram
;LCD_cnt_l:    ds 1    ; reserve 1 byte for variable LCD_cnt_l
;LCD_cnt_h:    ds 1    ; reserve 1 byte for variable LCD_cnt_h
;LCD_cnt_ms:   ds 1    ; reserve 1 byte for ms counter
;LCD_tmp:      ds 1    ; reserve 1 byte for temporary use
;LCD_counter:  ds 1    ; reserve 1 byte for counting through message
;LCD_cnt:      ds 1    ; one byte for data
;PSECT udata_acs_ovr, space=1, ovrld, class=COMRAM
;LCD_hex_tmp:  ds 1    ; reserve 1 byte for variable LCD_hex_tmp
;
;; Main program entry
;org 0x00           ; Reset vector, start from address 0x00
;goto Start         ; Jump to start of the program
;
;Start:
;    call GLCD_Setup  ; Initialize the GLCD
;    call WriteText    ; Write "HELLO" to the screen
;    loop:
;        goto loop    ; Infinite loop to keep the program running
;
;; Setup function for the GLCD
;GLCD_Setup:
;    ; Initialize control pins as outputs
;    bcf TRISC, GLCD_CS1  ; Set CS1 as output (Clear the corresponding bit in TRISC)
;    bcf TRISC, GLCD_CS2  ; Set CS2 as output (Clear the corresponding bit in TRISC)
;    bcf TRISC, GLCD_RS   ; Set RS as output (Clear the corresponding bit in TRISC)
;    bcf TRISC, GLCD_E    ; Set E as output (Clear the corresponding bit in TRISC)
;
;    ; Set PORTB as output for data lines
;    bcf TRISB, 0xFF      ; Set all bits of PORTB as output (PORTB for data)
;
;    ; Initialize the GLCD display (assuming command sequence for Winstar GLCD)
;    call SendCommand, 0x3F   ; Function Set Command (8-bit, 2 lines, 5x8 dots)
;    call SendCommand, 0x0C   ; Display ON, Cursor OFF
;    call SendCommand, 0x01   ; Clear Display
;    return
;
;; Function to send a command to the GLCD
;SendCommand:
;    bcf  GLCD_RS           ; Set RS to 0 for command mode
;    bcf  GLCD_CS1          ; Set CS1 low to select the GLCD
;    bcf  GLCD_CS2          ; Set CS2 low
;    movf  LCD_cnt, W       ; Load the command from LCD_cnt into W
;    call PulseEnable       ; Send pulse to enable to latch the data
;    return
;
;; Function to send data to the GLCD
;SendData:
;    bsf  GLCD_RS           ; Set RS to 1 for data mode
;    bcf  GLCD_CS1          ; Set CS1 low to select the GLCD
;    bcf  GLCD_CS2          ; Set CS2 low
;    movf  LCD_cnt, W       ; Load data from LCD_cnt into W
;    call PulseEnable       ; Send pulse to enable to latch the data
;    return
;
;; Function to pulse the Enable pin to latch data into the GLCD
;PulseEnable:
;    bsf  GLCD_E            ; Set E high (Enable)
;    nop                     ; Small delay
;    bcf  GLCD_E            ; Set E low (Disable)
;    nop                     ; Small delay
;    return
;
;; Function to write a string to the GLCD (e.g., "HELLO")
;WriteText:
;    ; Write the first character 'H'
;    movlw   'H'            ; Load ASCII value of 'H' into W
;    movwf   LCD_cnt        ; Store W into LCD_cnt
;    call    SendData       ; Send the character to the GLCD
;
;    ; Write the second character 'E'
;    movlw   'E'            ; Load ASCII value of 'E' into W
;    movwf   LCD_cnt        ; Store W into LCD_cnt
;    call    SendData       ; Send the character to the GLCD
;
;    ; Write the third character 'L'
;    movlw   'L'            ; Load ASCII value of 'L' into W
;    movwf   LCD_cnt        ; Store W into LCD_cnt
;    call    SendData       ; Send the character to the GLCD
;
;    ; Write the fourth character 'L'
;    movlw   'L'            ; Load ASCII value of 'L' into W
;    movwf   LCD_cnt        ; Store W into LCD_cnt
;    call    SendData       ; Send the character to the GLCD
;
;    ; Write the fifth character 'O'
;    movlw   'O'            ; Load ASCII value of 'O' into W
;    movwf   LCD_cnt        ; Store W into LCD_cnt
;    call    SendData       ; Send the character to the GLCD
;
;    return
