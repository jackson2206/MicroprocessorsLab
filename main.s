#include <xc.inc>
global	rand_num
extrn   Keypad_Setup, Keypad_Move_Char
extrn	GLCD_Setup,Set_Xaddress,Set_Yaddress,GLCD_Send_Byte_D,Set_display,clear_page,Set_display,Clear_display,GLCD_delay_ms
extrn	GLCD_Write_player,GLCD_Write_Title,Keypad_Start,Keypad_Shoot_Key
extrn	bullet_Setup,gen_bullet,move_all_bullets ,enemies_gen,move_enemies,GLCD_Write_Enemy,game_over_check,collisions,game_over_score
extrn	multi_setup,scoreconverter,Writing_score,score_H,score_L,Draw_endscreen,score,start_animation,Sound_setup,sound_loop,frames,draw_high_score
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds	1    ; reserve one byte for a counter variable
counter_2:  ds	1
count1:	    ds	2    
delay_count:ds	1    ; reserve one byte for counter in the delay routine
high_score: ds	2
rand_num:   ds	1
Hi_scoreH   EQU	1
Hi_scoreL   EQU	0	    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:
	movlw   3 ; defining the starting random seed so that subsequent games will have a different start
	movwf   rand_num,A
	movlw	0x0
	movwf	high_score,A
start:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	multi_setup
	call	bullet_Setup
	call	GLCD_Setup
	call    Keypad_Setup
	call	Sound_setup
	clrf	counter,A
	clrf	counter_2,A
	movlw	0
	movwf	count1,A	
	goto	GLCD
	
	
GLCD:
    call    GLCD_Write_Title
    ;call    start_animation
    call    Keypad_Start ; waits till button press to run
character_move:
    call    enemies_gen
    call    GLCD_Write_player
    movwf   counter_2,A
;    movff   high(count1),score_H                  uncomment for frame rate
;    movff   low(count1),score_L
;    call    scoreconverter
;    call    frames
    call    Keypad_Shoot_Key
    movwf   counter,A	; stores boolean 1 or 0
    movlw   1
    cpfseq  counter,A
    goto    move_everything
    movf    counter_2,W,A
    call    gen_bullet
move_everything:
    call    move_enemies
    call    move_all_bullets
    call    collisions
    call    game_over_check
    movwf   counter,A
    movlw   0
    cpfseq  counter,A
    goto    end_screen
    movlw   90
    call    GLCD_delay_ms
;    incf    count1,f,A
    goto    character_move

end_screen:
    call    Clear_display
    call    Draw_endscreen
    movff   high(score),score_H
    movff   low(score),score_L
    call    scoreconverter
    call    game_over_score
    call    save_hi_score
    movff   high(high_score),score_H
    movff   low(high_score),score_L
    call    scoreconverter
    call    draw_high_score
    call    Keypad_Start
    goto    start
;test:
;    movlw   high(4566)
;    movwf   score_H,A
;    movlw   low(4566)
;    movwf   score_L,A
;    call    scoreconverter
;    call    Writing_score
;    call    Keypad_Start
;    goto    setup
save_hi_score:
    movf    high(high_score),W,A
    cpfseq  high(score),A
    bra	    check_high
    movf    low(high_score),W,A
    cpfsgt  low(score),A
    return
    movff   score,high_score
    return
check_high:
    movf    high(high_score),W,A
    cpfsgt  high(score),A
    return
    movff   score,high_score
    
    return
    
       
;write_to_eeprom:            attempt to write to eeprom
;    movwf   high_score_L,A
;    movwf   high_score_H,A
;    movlw   high(Hi_scoreL)
;    movwf   EEADRH,A
;    movlw   low(Hi_scoreL)
;    movwf   EEADR,A
;    movff   high_score_L,EEDATA
;    bcf	    EEPGD
;    bcf	    CFGS
;    bsf	    WREN
;    
;    bcf	    GIE
;    movlw   0x55
;    movwf   EECON2,A
;    movlw   0XAA
;    movwf   EECON2,A
;    bsf	    WR
;    btfsc   WR
;    bsf	    GIE
;    movlw   40
;    call    GLCD_delay_ms
;    bcf	    WREN
;    bcf	    EEIF
;    movlw   40
;    call    GLCD_delay_ms
;highl:    
;    movlw   high(Hi_scoreH)
;    movwf   EEADRH,A
;    movlw   low(Hi_scoreH)
;    movwf   EEADR,A
;    movff   high_score_H,EEDATA
;    bcf	    EEPGD
;    bcf	    CFGS
;    bsf	    WREN
;    
;    bcf	    GIE
;    movlw   0x55
;    movwf   EECON2,A
;    movlw   0XAA
;    movwf   EECON2,A
;    bsf	    WR
;    btfsc   WR
;    bsf	    GIE
;    movlw   40
;    call    GLCD_delay_ms
;    bcf	    WREN
;    bcf	    EEIF
;    movlw   40
;    call    GLCD_delay_ms
;    return
;    
;Read_High_score:
;    movlw   high(Hi_scoreL)
;    movwf   EEADRH,A
;    movlw   low(Hi_scoreL)
;    movwf   EEADR,A
;    bcf	    EEPGD
;    bcf	    CFGS
;    bsf	    RD
;    nop
;    movff   EEDATA,high_score_L
;    bcf	    RD
;    movlw   40
;    call    GLCD_delay_ms
;    movlw   high(Hi_scoreH)
;    movwf   EEADRH,A
;    movlw   low(Hi_scoreH)
;    movwf   EEADR,A
;    bcf	    EEPGD
;    bcf	    CFGS
;    bsf	    RD
;    nop  
;    movff   EEDATA,high_score_H
;    return

delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst
