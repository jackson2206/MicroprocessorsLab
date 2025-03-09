#include <xc.inc>
    
global  Keypad_Setup, Keypad_read

psect	udata_acs   ; reserve data space in access ram
Keypad_counter: ds    1	    ; reserve 1 byte for variable Keypad_counter
delay_count:    ds    1
col:            ds    1
combination:    ds    1
psect	udata_bank5 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data
    
 
psect	Keypad_code,class=CODE
      
Keypad_Setup:
    movlb   0x0F
    bsf     REPU; bit that allows use of pull up resistors
    movlb   0x0
    clrf    LATE,A
    clrf    PORTF,A
    clrf    TRISF,A
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
Keypad_combine:
    ;movff   combination,PORTF
    movlw   0xBB
    movff    combination,col
    clrf    combination,A
Compare_up:
    cpfseq  col,A
    bra	    Compare_down
    movlw   0x0
    return

Compare_down:
    movf    col,W,A
    sublw   10111101B
    BNZ	    Keypad_read
    movlw   0x40
    return
start_button:
    
    
delay:
    
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return
    

end
