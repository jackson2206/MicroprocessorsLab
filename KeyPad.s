#include <xc.inc>
    
global  Keypad_Setup,Keypad_Move_Char,Keypad_Shoot_Key,Keypad_Start
psect	udata_acs   ; reserve data space in access ram
Keypad_counter: ds    1	    ; reserve 1 byte for variable Keypad_counter
delay_count:    ds    1
col:            ds    1
combination:    ds    1
playeryadd:	ds    1 
b_:		ds    1    
psect	udata_bank5 ; reserve data anywhere in RAM (here at 0x400)
bullet:    ds 0x80 ; reserve 128 bytes for message data
    
 
psect	Keypad_code,class=CODE
      
Keypad_Setup:
    movlb   b_
    bsf     REPU; bit that allows use of pull up resistors
    movlb   0x0
    clrf    LATE,A
    clrf    PORTH,A
    clrf    TRISH,A
    movlw   56
    movwf   playeryadd,A
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
    movff   combination,PORTH
Keypad_combine:
    movff    combination,col
    clrf    combination,A
    return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Keypad_Move_Char:
    call    Keypad_read
Compare_r:
    movlw   01111101B
    cpfseq  col,A
    bra	    Compare_l
    movlw   8
    addwf   playeryadd,f,A
    movlw   120
    cpfsgt  playeryadd,A
    bra	    ret
    movlw   120
    movwf   playeryadd,A
    movf    playeryadd,W,A
    return

Compare_l:
    movlw   11011101B
    cpfseq  col,A
    bra	    none
    movlw   8
    subwf   playeryadd,f,A
    movf    playeryadd,W,A
    movlw   120
    cpfsgt  playeryadd,A
    bra	    ret
    movlw   0
    movwf   playeryadd,A
    movf    playeryadd,W,A
    return
ret:
    movf    playeryadd,W,A
    return
none:
    movf    playeryadd,W,A
    return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

    
Keypad_Shoot_Key:
    call    Keypad_read
check_shoot:
    ; choose button to shoot
Keypad_Start: ; press 8 to start
    call    Keypad_read
    movlw   01111011B
    cpfseq  col,A
    bra	    Keypad_Start
    return
delay:
    
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return
    

end
