#include <xc.inc>
global	bullet_Setup,gen_bullet,move_all_bullets,count,enemies_gen,move_enemies,game_over_check,collisions
extrn	Set_display,Set_Xaddress,GLCD_Write_bullet,clear_page,Clear_display,GLCD_Write_Enemy
psect	udata_acs 	
count:	    ds	1
temp:	    ds	1
temp2:	    ds	1    
bulletsy:   ds	1
bulletsx:   ds	1
rand_num:    ds	1
enemies_X:  ds	1
enemies_Y:  ds	1
enemy_count:
	    ds	1
score:	    ds	2
movement_inc:
	    ds	1	    
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
    movlw   0
    cpfseq  enemy_count,A
    return
    movlw   0
    movwf   enemies_X,A
    call    random_gen
    movwf   enemies_Y,A
    incf    enemy_count,F,A
    return
game_over_check: ; returns 1 if game_over
    movlw   7
    cpfseq  enemies_X,A
    retlw   0
    retlw   1
move_enemies:
    movlw   10
    cpfseq  movement_inc,A
    bra	    increments    
    incf    enemies_X,f,A
    movf    enemies_Y,W,A
    call    Set_display
    movf    enemies_X,W,A
    call    Set_Xaddress
    movlw   0
    movwf   movement_inc,A
    return
increments:
    incf    movement_inc,f,A
    movf    enemies_Y,W,A
    call    Set_display
    movf    enemies_X,W,A
    call    Set_Xaddress
    call    GLCD_Write_Enemy
    return
collisions:
    movf    enemies_X,W,A
    cpfseq  bulletsx,A
    return
    movf    enemies_Y,W,A
    cpfseq  bulletsy,A
    return
    decf    enemy_count,F,A
    decf    count,F,A
    incf    score,F,A
    return
end

