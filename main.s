#include <xc.inc>
extrn   Keypad_Setup, Keypad_Move_Char
extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
;extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex,LCD_Send_Byte_D,LCD_Clear,LCD_Shift_down,LCD_Shift_up,LCD_up_down
extrn	GLCD_Setup,Set_Xaddress,Set_Yaddress,GLCD_Send_Byte_D,Set_display,clear_page,Set_display,Clear_display,GLCD_delay_ms
 ; external LCD subroutines
extrn	write,write_title,Keypad_Start
	
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
	call	UART_Setup	; setup UART
;	call	LCD_Setup	; setup UART
;	call    ADC_Setup   ; setup ADC
	call    Keypad_Setup
	call	GLCD_Setup
	goto	GLCD
	
	
GLCD:
    call    write_title
    call    Keypad_Start
character_move:
    call    write
    movlw   100
    call    GLCD_delay_ms
    goto    character_move
    
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst
