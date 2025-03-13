#include <xc.inc>
psect	udata_acs
count:	    ds	1
temp:	    ds	1    
psect	udata_bank4
bulletsy:   ds	128
bulletsx:   ds	128    
psect	bullets_code,class=Code

bullet_Setup:
    movlw   0
    movwf   count,Aw
    lfsr    0,bulletsy ; intialises bullet address
    lfsr    2,bulletsx
    return
gen_bullet:  ; takes yadd of player in WREG
    movwf   POSTINC0,A ;  talk to neil about how to use postinc 
    movlw   6
    movwf   POSTINC2,A
    incf    count,f,A
    lfsr    1,bulletsy ; postdec0 to get earliest
    movf    count,W,A
    return
move_bullets:; wreg goes to counter
    movwf   temp,A
    
end

