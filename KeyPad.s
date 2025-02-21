#include <xc.inc>
    
global  Keypad_Setup, Keypad_read

psect	udata_acs   ; reserve data space in access ram
Keypad_counter: ds    1	    ; reserve 1 byte for variable Keypad_counter
delay_count:    ds    1
col:            ds    1
row:            ds    1
combination:    ds    1
psect	Keypad_code,class=CODE
Keypad_Setup:
    movlb   0x0F
    clrf    TRISH,A
    clrf    TRISJ,A
    clrf    TRISF,A
    clrf    PORTH,A
    clrf    PORTJ,A
    clrf    TRISD,A
    bsf     REPU; bit that allows use of pull up resistors
    movlb   0x0
    clrf    LATE,A
    clrf    PORTF,A
    return

Keypad_read:
    movlw   0x0F               
    movwf   TRISE,A
    call    delay
    movff   PORTE,combination
    call    delay
    movlw   0xF0  
    movwf   TRISE,A
    call    delay
    movf    PORTE,W,A
    addwf   combination,f,A
    call Keypad_combine
    return
    
Keypad_combine:
    movff   combination,PORTH
    call    compare
    clrf    combination,A
    return
compare:
    return
    
    
    
delay:
    
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return
    


