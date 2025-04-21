#include <xc.inc>
global	bullet_Setup,gen_bullet,move_all_bullets,count,enemies_gen,move_enemies,game_over_check,collisions,random_gen,score
extrn	Set_display,Set_Xaddress,GLCD_Write_bullet,clear_page,Clear_display,GLCD_Write_Enemy,GLCD_delay_x4us,score_H,score_L,scoreconverter,Writing_score,Sound_setup,sound_loop,rand_num
psect	udata_acs 	
count:	    ds	1
temp:	    ds	1
temp2:	    ds	1
temp3:	    ds	1    
bulletsy:   ds	1
bulletsx:   ds	1    
enemy_count:ds	1
score:	    ds	2
com_score:  ds	2 
enem_speed: ds	1    
max_enem:   ds	1	    
psect	udata_bank4	
enemX:	    ds	10
enemY:	    ds	10
enemINC:    ds	10    
psect	bullets_and_enemies_code, class=CODE    
bullet_Setup:
    movlw   0
    movwf   count,A
    movlw   0
    movwf   score,A
    movlw   0
    movwf   enemy_count,A
    clrf    enemX,A
    clrf    enemY,A
    clrf    enemINC,A
    lfsr    1,enemX
    lfsr    2,enemY
    lfsr    0,enemINC
    movff   score,com_score
    MOVLW   15
    movwf   enem_speed,A
    movlw   7
    movwf   max_enem,A
    return
random_gen:
    movf    rand_num,W,A
    mullw   77
    movf    PRODL,W,A
    addlw   17
    movwf   rand_num,A
    movlw   12
    cpfslt  rand_num,A
    bra	    random_gen
    movf    rand_num,W,A
    mullw   8
    movff   PRODL,PORTH
    movf    PRODL,W,A
    return
    ;--------------------------------------------------------
gen_bullet:  ; takes yadd of player in WREG
    movwf   temp,A 
    movlw   0
    cpfseq  count,A
    return
    movff   temp,bulletsy
    movlw   7
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
inc:
    movf    POSTINC0,W,A
    movf    POSTINC1,W,A
    movf    POSTINC2,W,A
    decfsz  temp2,f,A
    bra	    inc
    return
enemies_gen:
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
score_check:
    movf    com_score,W,A
    cpfseq  score,A
    bra	    score_changed
    retlw   0
score_changed:
    movff   score,com_score
    retlw   1
extra_enemy:  ;if score condition is met adds one more enemy
    movf    max_enem,W,A
    cpfslt  enemy_count,A
    return
    call    score_check ; if score does not change return out
    movwf   temp3,A
    movlw   1
    cpfseq  temp3,A
    return
    call    INC_condition
    movwf   temp3,A
    movlw   1
    cpfseq  temp3,A
    return
    lfsr    1,enemX
    lfsr    2,enemY
    lfsr    0,enemINC
    call    increment_fsr
    movlw   0
    movwf   POSTINC0,A
    movlw   0
    movwf   POSTINC1,A
    call    random_gen
    movwf   POSTINC2,A
    incf    enemy_count,f,A
    return
INC_condition: ; condition to increase score
    movlw   3
    cpfsgt  score,A
    retlw   0
    retlw   1
    
move_enemies:
    call    draw
    lfsr    1,enemX ; point to start of the table
    lfsr    0,enemINC
    movff   enemy_count,temp3
hold_time:
    movf    enem_speed,W,A
    cpfseq  INDF0,A
    bra	    increment_all
    movlw   0
    movwf   POSTINC0,A
    incf    POSTINC1,f,A
    decfsz  temp3,f,A
    bra	    hold_time
    return
increment_all:
    incf    POSTINC0,f,A
    movf    POSTINC1,W,A
    decfsz  temp3,f,A
    bra	    hold_time
    return
draw:
    movff   high(score),score_H
    movff   low(score),score_L
    call    scoreconverter
    call    Writing_score
    movff   enemy_count,temp2
    lfsr    1,enemX ; point to start of the table
    lfsr    2,enemY
    lfsr    0,enemINC
dr:    
    movf    POSTINC0,W,A
    movf    POSTINC2,W,A
    call    Set_display
    movf    POSTINC1,W,A
    call    Set_Xaddress
    call    GLCD_Write_Enemy
    decfsz  temp2,A
    bra	    dr
    return
;    movlw   1
;    call    GLCD_delay_x4us
    return
game_over_check:    ;;returns 1 if game_over
    lfsr    1,enemX ; point to start of the table
    movff   enemy_count,temp3
check:    
    movlw   7
    cpfseq  POSTINC1,A
    bra	    try_all
    retlw   1
try_all:
    decfsz  temp3,f,A
    bra	    check
    retlw   0

collisions:
    lfsr    1,enemX ; point to start of the table
    lfsr    2,enemY
    lfsr    0,enemINC
    movff   enemy_count,temp3
check_x:
    movf    INDF1,W,A
    cpfseq  bulletsx,A
    bra	    check_just_above
    movf    INDF2,W,A
    cpfseq  bulletsy,A
    bra	    check_just_above
    movlw   0
    movwf   POSTINC0,A
    movlw   0
    movwf   POSTINC1,A
    call    random_gen
    movwf   POSTINC2,A
    decf    count,f,A ; decriment bullet
    incf    score,f,A
    call    sound_loop
    return
check_just_above:
    movf    INDF1,W,A
    addlw   1
    cpfseq  bulletsx,A
    bra	    check_all
    movf    INDF2,W,A
    cpfseq  bulletsy,A
    bra	    check_all
    movlw   0
    movwf   POSTINC0,A
    movlw   0
    movwf   POSTINC1,A
    call    random_gen
    movwf   POSTINC2,A
    decf    count,f,A ; decriment bullet
    incf    score,f,A
    call    sound_loop
    return
check_all:
    movf   POSTINC0,W,A
    movf   POSTINC1,W,A
    movf   POSTINC2,W,A
    movlw   0
    decfsz  temp3,f,A
    bra	    check_x
    return
    
end

