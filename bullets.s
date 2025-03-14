#include <xc.inc>
global	bullet_Setup,gen_bullet,move_all_bullets,count
extrn	Set_display,Set_Xaddress,GLCD_Write_bullet,clear_page,Clear_display 
psect	udata_acs
count:	    ds	1
temp:	    ds	1
temp2:	    ds	1    
psect	udata_bank4
bulletsy:   ds	10
bulletsx:   ds	10    
psect	bullets_code, class=CODE

bullet_Setup:
    movlw   0
    movwf   count,A
    lfsr    0,bulletsy ; intialises bullet yaddressaddress
    lfsr    1,bulletsx ; xaddrees of bullet
    return
gen_bullet:  ; takes yadd of player in WREG
    movwf   POSTINC0,A ;  talk to neil about how to use postinc 
    movlw   6
    movwf   POSTINC1,A
    incf    count,f,A
    lfsr    1,bulletsy ; postdec0 to get earliest
    movf    count,W,A
    return
move_all_bullets:; wreg goes to counter, returns 0 if no bullets
    movff   count,temp
    movlw   0
    cpfseq  temp,A
    bra	    gen
    return
gen: 
    lfsr    0,bulletsy
    lfsr    1,bulletsx
gen_sprite:
    movlw   7
    cpfsgt  INDF1,A
    bra	    check2
    bra	    en
check2:
    movlw   0
    cpfseq  INDF1,A
    bra	    repet
    bra	    en
repet:
    movlw   120
    cpfsgt  INDF0,A
    bra	    re
    movlw   0
    movwf   INDF0,A
re:    
    movff   POSTINC0,temp2
    movf    temp2,W,A
    call    Set_display
    movf    INDF1,W,A
    call    Set_Xaddress
    decf    POSTINC1,f,A
    call    GLCD_Write_bullet
    decfsz  temp,f,A
    bra	    gen_sprite
    return
    
en:
    movf    POSTINC0,W,A
    movf    POSTINC1,W,A
    decfsz  temp,f,A
    bra	    gen_sprite
    return
delete_bullets:
    movlw   6
    cpfsgt  INDF1,A
    return
    clrf    INDF0,A
    clrf    INDF1
    return
    
keep_same:    
    
    
end

