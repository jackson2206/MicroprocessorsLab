#include <xc.inc>
global	 Sound_setup,sound_loop
extrn	 GLCD_delay_x4us
    
psect	udata_acs
count1:	    ds	1
count2:	    ds	1    

psect	sound, class=CODE      

Sound_setup:
    
    bsf	    PORTB,6,A
    clrf    TRISB,A
    
;    ; setup timer2
;    movlw   00000111B
;    movwf   T2CON,A
;    
;    movlw   250
;    movwf   PR2,A
;    
;    movlw   00111100B
;    movwf   CCP1CON,A
;    
;    movlw   125
;    movwf   CCPR1L,A
;    bcf    PORTB,6,A
    
sound_loop:
    movlw   20
    movwf   count2,A
lool:
    bsf	    PORTB,6,A
    movlw   70
    call    GLCD_delay_x4us
    bcf	    PORTB,6,A
    movlw   70
    call    GLCD_delay_x4us
    bsf	    PORTB,6,A
    movlw   70
    call    GLCD_delay_x4us
    decfsz  count2,f,A
    bra	    lool
    return
    
    bra	    lool
    return
