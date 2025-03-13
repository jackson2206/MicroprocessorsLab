#include <xc.inc>
extrn   Keypad_Setup, Keypad_Move_Char
extrn	GLCD_Setup,Set_Xaddress,Set_Yaddress,GLCD_Send_Byte_D,Set_display,clear_page,Set_display,Clear_display,GLCD_delay_ms
extrn	GLCD_Write_player,GLCD_Write_Title,Keypad_Start
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
counter_2:  ds 1    
delay_count:ds 1    ; reserve one byte for counter in the delay routine
playerYadd: ds 1  
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call    Keypad_Setup
	call	GLCD_Setup
	goto	GLCD
	
	
GLCD:
    call    GLCD_Write_Title
    call    Keypad_Start
character_move:
    call    GLCD_Write_player
    movlw   100
    call    GLCD_delay_ms
    goto    character_move
    
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst
