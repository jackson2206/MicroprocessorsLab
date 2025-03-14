#include <xc.inc>
global	bullet_Setup,gen_bullet,move_all_bullets,count
extrn	Set_display,Set_Xaddress,GLCD_Write_bullet,clear_page,Clear_display 
psect	udata_acs
count:	    ds	1
temp:	    ds	1
temp2:	    ds	1    
bulletsy:   ds	1
bulletsx:   ds	1    
psect	bullets_code, class=CODE

bullet_Setup:
    movlw   0
    movwf   count,A
    return
gen_bullet:  ; takes yadd of player in WREG
    movwf   temp2,A 
    movlw   0
    cpfseq  count,A
    return
    movff   temp2,bulletsy
    movlw   6
    movwf   bulletsx,A
    incf    count,f,A
    movf    count,W,A
    return
move_all_bullets:; wreg goes to counter, returns 0 if no bullets
    movlw   1
    cpfseq  count,A
    return
    movf    bulletsy,W,A
    call    Set_display
    movf    bulletsx,W,A
    call    Set_Xaddress
    call    GLCD_Write_bullet
    decf    bulletsx,f,A
    movlw   6
    cpfsgt  bulletsx
    return
    decf    count,A
    return
    
keep_same:    
    
    
end

