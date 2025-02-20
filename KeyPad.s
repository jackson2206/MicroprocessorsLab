#include <xc.inc>
    
global  Keypad_Setup, Keypad_Transmit_Message

psect	udata_acs   ; reserve data space in access ram
Keypad_counter: ds    1	    ; reserve 1 byte for variable UART_counter

psect	uart_code,class=CODE
Keypad_Setup:
    bsf	    SPEN	; enable
    bcf	    SYNC	; synchronous
    bcf	    BRGH	; slow speed
    bsf	    TXEN	; enable transmit
    bcf	    BRG16	; 8-bit generator only
    movlw   103		; gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	; set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	; TX1 pin is output on RC6 pin
					; must set TRISC6 to 1
    movlb   0xf					
    bsf     REPU; bit that allows use of pull up resistors
    clrf    LATE 
    movlw   0x0F                   
    movwf   TRISE
    return

Keypad_Transmit_Message:	    ; Message stored at FSR2, length stored in W
    movwf   Keypad_counter, A
Keypad_Loop_message:
    movf    POSTINC2, W, A
    call    Keypad_Transmit_Byte
    decfsz  Keypad_counter, A
    bra	    Keypad_Loop_message
    return

Keypad_Transmit_Byte:	    ; Transmits byte stored in W
    btfss   TX1IF	    ; TX1IF is set when TXREG1 is empty
    bra	    Keypad_Transmit_Byte
    movwf   TXREG1, A
    return



