#include <xc.inc>
extrn   Keypad_Setup, Keypad_Move_Char
extrn	GLCD_Setup,Set_Xaddress,Set_Yaddress,GLCD_Send_Byte_D,Set_display,clear_page,Set_display,Clear_display,GLCD_delay_ms
extrn	GLCD_Write_player,GLCD_Write_Title,Keypad_Start,Keypad_Shoot_Key
extrn	bullet_Setup,gen_bullet,move_all_bullets ,enemies_gen,move_enemies,GLCD_Write_Enemy,game_over_check,collisions
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
counter_2:  ds 1    
delay_count:ds 1    ; reserve one byte for counter in the delay routine 
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	bullet_Setup
	call	GLCD_Setup
	call    Keypad_Setup
	goto	GLCD
	
	
GLCD:
    call    GLCD_Write_Title
    call    Keypad_Start ; waits till button press to run
character_move:
    call    enemies_gen
    call    GLCD_Write_player
    movwf   counter_2,A
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
    goto    GLCD
    movlw   100
    call    GLCD_delay_ms
    goto    character_move
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst
