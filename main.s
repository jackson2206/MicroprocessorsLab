#include <xc.inc>
extrn   Keypad_Setup, Keypad_Move_Char
extrn	GLCD_Setup,Set_Xaddress,Set_Yaddress,GLCD_Send_Byte_D,Set_display,clear_page,Set_display,Clear_display,GLCD_delay_ms
extrn	GLCD_Write_player,GLCD_Write_Title,Keypad_Start,YADD,Keypad_Shoot_Key,count
extrn	bullet_Setup,gen_bullet,move_all_bullets    
	
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
	call    Keypad_Setup
	call	GLCD_Setup
	call	bullet_Setup
	goto	GLCD
	
	
GLCD:
    call    GLCD_Write_Title
    call    Keypad_Start
character_move:
    call    GLCD_Write_player
    movwf   counter_2,A
    call    Keypad_Shoot_Key
    movwf   counter,A
    movlw   1
    cpfseq  counter,A
    bra	    generating_bullets
    movf    counter_2,W,A
    call    gen_bullet
generating_bullets:
    call    move_all_bullets
    movlw   350
    call    GLCD_delay_ms
    movlw   0
    call    clear_page
    goto    character_move
    
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst
