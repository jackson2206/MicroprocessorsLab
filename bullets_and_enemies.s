#include <xc.inc>
global	bullet_Setup,gen_bullet,move_all_bullets,count,enemies_gen,move_enemies,game_over_check,collisions
extrn	Set_display,Set_Xaddress,GLCD_Write_bullet,clear_page,Clear_display,GLCD_Write_Enemy
psect	udata_acs 	
count:	    ds	1
temp:	    ds	1
temp2:	    ds	1    
bulletsy:   ds	1
bulletsx:   ds	1  
;psect	 udata
rand_num:    ds	1
enemies_X:  ds	1
enemies_Y:  ds	1
enemy_count:
	    ds	1
score:	    ds	2
movement_inc:
	    ds	1
	    
psect	udata_bank4	
enemX:	    ds	6
enemY:	    ds	6
enemINC:    ds	6    
psect	bullets_and_enemies_code, class=CODE    
bullet_Setup:
    movlw   0
    movwf   count,A
    movlw   2
    movwf   rand_num,A
    movlw   0
    movwf   score,A
    movwf   enemy_count,A
    movwf   movement_inc,A
;    clrf    enemX,A
;    clrf    enemY,A
;    clrf    enemINC,A
    lfsr    0,enemX
    lfsr    1,enemY
    lfsr    2,enemINC
    return
random_gen:
    movf    rand_num,W,A
    mullw   77
    movf    PRODL,W,A
    addlw   17
    movwf   rand_num,A
    movlw   16
    cpfslt  rand_num,A
    bra	    random_gen
    movf    rand_num,W,A
    mullw   8
    movf    PRODL,W,A
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
    cpfsgt  bulletsx,A
    return
    decf    count,A
    return
enemies_gen:
make_starting_enemy:
    movlw   0
    cpfseq  enemy_count,A
    return
    movlw   0
    movwf   POSTINC0,A
    call    random_gen
    movwf   POSTINC1,A
    movlw   0
    movwf   POSTINC2,A
    incf    enemy_count,f,A
    return
add_enemy:
    movlw   3
    cpfsgt  score,A
    return
    movlw   6
    cpfslt  enemy_count,A
    return
    movlw   0
    movwf   POSTINC0,A
    call    random_gen
    movwf   POSTINC1,A
    movlw   0
    movwf   POSTINC2,A
    incf    enemy_count,f,A
    return
    
    
    
move_enemies:
    lfsr    1,enemX
    lfsr    2,enemY
    lfsr    0,enemINC
    movff   enemy_count,temp2
check_increment:
    movlw   10
    cpfseq  INDF0,A
    bra	    increment
    movlw   0
    movwf   POSTINC0,A
    movlw   1
    addwf   POSTINC1,f,A
    movf    POSTINC2,W,A
    decfsz  temp2,f,A
    bra	    check_increment
    return
increment:
    movlw   1
    addwf   POSTINC0,f,A
    movf    POSTINC1,W,A
    call    Set_Xaddress
    movf    POSTINC2,W,A
    call    Set_display
    call    GLCD_Write_Enemy
    decfsz  temp2,f,A
    bra	    check_increment
    return
    
    
game_over_check:
    lfsr    1,enemX
    movff   enemy_count,temp2
check:
    movlw   7
    cpfseq  POSTINC1,A
    bra	    checker
    retlw   1
checker:
    decfsz  temp2,f,A
    bra	    check
    retlw   0
collisions:
    lfsr    0,enemX
    lfsr    1,enemY
    lfsr    2,enemINC
    movff   enemy_count,temp2
collider:
    movf    bulletsx,W,A
    cpfseq  INDF0,A
    bra	    check_rst
    movf    bulletsy,W,A
    cpfseq  INDF1,A ; if true branch skipped
    bra	    check_rst
    movlw   0
    movwf   POSTINC0,A
    movwf   POSTINC2,A
    call    random_gen
    movwf   POSTINC1,A
    incf    score,f,A
    decfsz  temp2,f,A
    bra	    collider
    return
check_rst:
    movlw   POSTINC0
    movlw   POSTINC1
    movlw   POSTINC2
    decfsz  temp2,f,A
    bra	    collider
    return
end

