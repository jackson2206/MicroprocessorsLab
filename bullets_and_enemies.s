#include <xc.inc>
global	bullet_Setup,gen_bullet,move_all_bullets,count,enemies_gen,move_enemies,game_over_check,collisions
extrn	Set_display,Set_Xaddress,GLCD_Write_bullet,clear_page,Clear_display,GLCD_Write_Enemy
psect	udata_acs 	
count:	    ds	1
temp:	    ds	1
temp2:	    ds	1
temp3:	    ds	1    
bulletsy:   ds	1
bulletsx:   ds	1
rand_num:   ds	1    
enemy_count:ds	1
score:	    ds	1
	    
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
    movlw   0
    movwf   enemy_count,A
    clrf    enemX,A
    clrf    enemY,A
    clrf    enemINC,A
;    lfsr    1,enemX
;    lfsr    2,enemY
;    lfsr    0,enemINC
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
    ;--------------------------------------------------------
gen_bullet:  ; takes yadd of player in WREG
    movwf   temp,A 
    movlw   0
    cpfseq  count,A
    return
    movff   temp,bulletsy
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
    
    
    
    
increment_fsr: ; increment fsr for number of enemies
    movff   enemy_count,temp2
    movlw   0
    cpfseq  enemy_count,A
    bra	    inc
    return
inc:
    movlw   POSTINC0
    movlw   POSTINC1
    movlw   POSTINC2
    decfsz  temp2,f,A
    bra	    inc
    return
enemies_gen:
    lfsr    1,enemX ; point to start of the table
    lfsr    2,enemY
    lfsr    0,enemINC
    call    increment_fsr
    movlw   0
    cpfseq  enemy_count,A
    bra	    extra_enemy 
    movlw   0
    movwf   POSTINC0,A
    movlw   0
    movwf   POSTINC1,A
    call    random_gen
    movwf   POSTINC2,A
    incf    enemy_count,f,A
    return
extra_enemy:  ;if score condition is met adds one more enemy
    call    score_check
    movwf   temp,A ; if temp is 0 no extra enemy is generated
    movlw   0
    cpfseq  temp,A
    bra	    add_enemy
    return
add_enemy:    
    movff   enemy_count,temp2
    movlw   4
    cpfslt  enemy_count,A
    return
add:    
    movlw   0
    movwf   POSTINC0,A
    movlw   0
    movwf   POSTINC1,A
    call    random_gen
    movwf   POSTINC2,A
    incf    enemy_count,f,A
    decfsz  temp,f,A
    bra	    add    
    return 
    
    
    
move_enemies:
    lfsr    1,enemX ; point to start of the table
    lfsr    2,enemY
    lfsr    0,enemINC
    movff   enemy_count,temp
hold_time:
    movlw   10
    cpfseq  INDF0,A
    bra	    increment_all
    movlw   0
    movwf   POSTINC0,A
    DECF    POSTINC1,f,A
    movf    POSTINC2,W,A
    decfsz  temp,f,A
    bra	    hold_time
    return
increment_all:
    incf    POSTINC0,f,A
    movf    POSTINC1,W,A
    call    Set_Xaddress
    movf    POSTINC2,W,A
    call    Set_display
    call    GLCD_Write_Enemy
    decfsz  temp,f,A
    bra	    hold_time
    return
game_over_check:    ;;returns 1 if game_over
    lfsr    1,enemX ; point to start of the table
    movff   enemy_count,temp
check:    
    movlw   7
    cpfseq  POSTINC1,A
    bra	    try_all
    retlw   1
try_all:
    decfsz  temp,f,A
    bra	    check
    retlw   0
score_check:
    movlw   3
    cpfsgt  score,A
    retlw   0
    retlw   1

collisions:
    lfsr    1,enemX ; point to start of the table
    lfsr    2,enemY
    lfsr    0,enemINC
    movff   enemy_count,temp
check_x:
    movf    bulletsx,W,A
    cpfseq  INDF1,A
    bra	    check_all
    movf    bulletsy,W,A
    cpfseq  INDF2,A
    bra	    check_all
    movlw   0
    movwf   POSTINC0,A
    movwf   POSTINC1,A
    call    random_gen
    movwf   POSTINC2,A
    decf    count,f,A ; decriment bullet
    return
check_all:
    movf    POSTINC0,W,A
    movf    POSTINC1,W,A
    movf    POSTINC2,W,A
    decfsz  temp,f,A
    bra	    check_x
    return
    
end

