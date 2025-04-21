#include <xc.inc>
global	multi_setup,scoreconverter,Writing_score,score_H,score_L,game_over_score,frames,draw_high_score
extrn	Set_Xaddress,Set_display,Write_num0,Write_num1,Write_num2,Write_num3,Write_num4
extrn	Write_num5,Write_num6,Write_num7,Write_num8,Write_num9      
psect	udata_acs
ARG1H:	ds  1
ARG1L:	ds  1
ARG2H:	ds  1
ARG2L:	ds  1
RES0:	ds  1
RES1:	ds  1
RES2:	ds  1
RES3:   ds  1
RESx0:	ds  1
RESx1:	ds  1
RESx2:	ds  1
RESx3:  ds  1    
part1:	ds  1
part2:	ds  1
part3:	ds  1
part4:	ds  1
score_H:ds  1
score_L:ds  1    
psect	multiplication_code, class=CODE 

multi_setup:
    movlw   0x8A
    movwf   ARG1L,A
    movlw   0x41
    movwf   ARG1H,A
    movlw   0
    movwf   RES0,A
    movwf   RES1,A
    movwf   RES2,A
    movwf   RES3,A
    return
x16bit: ;   multiplies value in arg 1 and 2
    movlw   0x8A
    ;movf    ARG1L,W,A ; mul low bits
    mulwf   ARG2L,A
    
    movff   PRODL,RES0
    movff   PRODH,RES1
    
    movlw   0x41
    ;movf    ARG1H,W,A
    mulwf   ARG2H,A
    
    movff   PRODL,RES2
    movff   PRODH,RES3
    
    movlw   0x8A
    ;movf    ARG1L,W,A
    mulwf   ARG2H,A
    
    movf    PRODL,W,A
    addwf   RES1,f,A
    movf    PRODH,W,A
    addwfc  RES2,f,A
    clrf    WREG,A
    addwfc  RES3,f,A
    
    movlw   0x41
    ;movf    ARG1H,W,A
    mulwf   ARG2L,A
    
    movf    PRODL,W,A
    addwf   RES1,f,A
    movf    PRODH,W,A
    addwfc  RES2,f,A
    clrf    WREG,A
    addwfc  RES3,f,A
    
    return
scoreconverter:
    ; should take in a 16 bit number in FSR0 
    ; stores answer in part1:part4 32 bit address
    ; converts to decimal
    ;movwf   score_check,A
    movff   score_H,ARG2H
    movff   score_L,ARG2L
    call    x16bit
    movf    RES3,W,A
    movff   RES3,part1
    call    x24bit
    movff   RESx3,part2
    movff   RESx0,RES0
    movff   RESx1,RES1
    movff   RESx2,RES2
    call    x24bit
    
    movff   RESx3,part3
    movff   RESx0,RES0
    movff   RESx1,RES1
    movff   RESx2,RES2
    call    x24bit
    
    movff   RESx3,part4
    ;movff   RESx0,RES0
    ;movff   RESx1,RES1
    ;movff   RESx2,RES2
    return

Writing_score:
    movlw   0
    call    Set_Xaddress
    movlw   96
    call    Set_display
    call    choose_1st_digi
    call    choose_2nd_digi
    call    choose_3rd_digi
    call    choose_4th_digi
    return
game_over_score:
    movlw   5
    call    Set_Xaddress
    movlw   64
    call    Set_display
    call    choose_1st_digi
    call    choose_2nd_digi
    call    choose_3rd_digi
    call    choose_4th_digi
x24bit:
    movlw   0
    movwf   RESx0,A
    movwf   RESx1,A
    movwf   RESx2,A
    movwf   RESx3,A
    movlw   0x0A
    mulwf   RES0,A ; RES0*0XA -> PRODH:PRODL
    ;
    movff   PRODL,RESx0
    movff   PRODH,RESx1
    ;
    movlw   0x0A   ; 0x0A * RES1 -> PRODH:PRODL
    mulwf   RES1,A ;
    ;
    movf    PRODL,W,A
    addwf   RESx1,F,A
    movf    PRODH,W,A
    addwfc  RESx2,F,A
    clrf    WREG,A
    addwfc  RESx3,F,A
    ;
    movlw   0x0A
    mulwf   RES2,A ; 0x0A * RES2 -> PRODH:PRODL
    ;
    movf    PRODL,W,A
    addwf   RESx2,F,A
    movf    PRODH,W,A
    addwfc  RESx3,F,A         
    return
    
    
choose_1st_digi:
    movlw   0
    cpfseq  part1,A
    bra	    num_1
    call    Write_num0
    return
num_1:
    movlw   1
    cpfseq  part1,A
    bra	    num_2
    call    Write_num1
    return
num_2:
    movlw   2
    cpfseq  part1,A
    bra	    num_3
    call    Write_num2
    return
num_3:
    movlw   3
    cpfseq  part1,A
    bra	    num_4
    call    Write_num3
    return
num_4:
    movlw   4
    cpfseq  part1,A
    bra	    num_5
    call    Write_num4
    return    
num_5:
    movlw   5
    cpfseq  part1,A
    bra	    num_6
    call    Write_num5
    return
num_6:
    movlw   6
    cpfseq  part1,A
    bra	    num_7
    call    Write_num6
    return
num_7:
    movlw   7
    cpfseq  part1,A
    bra	    num_8
    call    Write_num7
    return    
num_8:
    movlw   8
    cpfseq  part1,A
    bra	    num_9
    call    Write_num8
    return 
num_9:
    movlw   9
    cpfseq  part1,A
    return
    call    Write_num9
    return
;----------------------------
choose_2nd_digi:
    movlw   0
    cpfseq  part2,A
    bra	    num2_1
    call    Write_num0
    return
num2_1:
    movlw   1
    cpfseq  part2,A
    bra	    num2_2
    call    Write_num1
    return
num2_2:
    movlw   2
    cpfseq  part2,A
    bra	    num2_3
    call    Write_num2
    return
num2_3:
    movlw   3
    cpfseq  part2,A
    bra	    num2_4
    call    Write_num3
    return
num2_4:
    movlw   4
    cpfseq  part2,A
    bra	    num2_5
    call    Write_num4
    return    
num2_5:
    movlw   5
    cpfseq  part2,A
    bra	    num2_6
    call    Write_num5
    return
num2_6:
    movlw   6
    cpfseq  part2,A
    bra	    num2_7
    call    Write_num6
    return
num2_7:
    movlw   7
    cpfseq  part2,A
    bra	    num2_8
    call    Write_num7
    return    
num2_8:
    movlw   8
    cpfseq  part2,A
    bra	    num2_9
    call    Write_num8
    return  
num2_9:
    movlw   9
    cpfseq  part2,A
    return
    call    Write_num9
    return

;-------------------------------
choose_3rd_digi: 
    movlw   0
    cpfseq  part3,A
    bra	    num3_1
    call    Write_num0
    return
num3_1:
    movlw   1
    cpfseq  part3,A
    bra	    num3_2
    call    Write_num1
    return
num3_2:
    movlw   2
    cpfseq  part3,A
    bra	    num3_3
    call    Write_num2
    return
num3_3:
    movlw   3
    cpfseq  part3,A
    bra	    num3_4
    call    Write_num3
    return
num3_4:
    movlw   4
    cpfseq  part3,A
    bra	    num3_5
    call    Write_num4
    return    
num3_5:
    movlw   5
    cpfseq  part3,A
    bra	    num3_6
    call    Write_num5
    return
num3_6:
    movlw   6
    cpfseq  part3,A
    bra	    num3_7
    call    Write_num6
    return
num3_7:
    movlw   7
    cpfseq  part3,A
    bra	    num3_8
    call    Write_num7
    return    
num3_8:
    movlw   8
    cpfseq  part3,A
    bra	    num3_9
    call    Write_num8
    return  
num3_9:
    movlw   9
    cpfseq  part3,A
    return
    call    Write_num9
    return
;-------------------------------
choose_4th_digi: 
    movlw   0
    cpfseq  part4,A
    bra	    num4_1
    call    Write_num0
    return
num4_1:
    movlw   1
    cpfseq  part4,A
    bra	    num4_2
    call    Write_num1
    return
num4_2:
    movlw   2
    cpfseq  part4,A
    bra	    num4_3
    call    Write_num2
    return
num4_3:
    movlw   3
    cpfseq  part4,A
    bra	    num4_4
    call    Write_num3
    return
num4_4:
    movlw   4
    cpfseq  part4,A
    bra	    num4_5
    call    Write_num4
    return    
num4_5:
    movlw   5
    cpfseq  part4,A
    bra	    num4_6
    call    Write_num5
    return
num4_6:
    movlw   6
    cpfseq  part4,A
    bra	    num4_7
    call    Write_num6
    return
num4_7:
    movlw   7
    cpfseq  part4,A
    bra	    num4_8
    call    Write_num7
    return    
num4_8:
    movlw   8
    cpfseq  part4,A
    bra	    num4_9
    call    Write_num8
    return  
num4_9:
    movlw   9
    cpfseq  part4,A
    return
    call    Write_num9
    return
frames:
    movlw   1
    call    Set_Xaddress
    movlw   96
    call    Set_display
    call    choose_1st_digi
    call    choose_2nd_digi
    call    choose_3rd_digi
    call    choose_4th_digi
    return
draw_high_score:
    movlw   6
    call    Set_Xaddress
    movlw   64
    call    Set_display
    call    choose_1st_digi
    call    choose_2nd_digi
    call    choose_3rd_digi
    call    choose_4th_digi
    return
end