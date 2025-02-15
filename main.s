	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto setup
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  (bit clear f)
	bsf	EEPGD 	; access Flash program memory (bit set f)
	movlw	0x0
	movwf	TRISC, A
	goto	start
	; ******* My data and where to put it in RAM *
myTable:
	db	'T','h','i','s',' ','i','s',' ','j','u','s','t'
	db	' ','s','o','m','e',' ','d','a','t','a'
	myArray EQU 0x400	; Address in RAM for data (EQU defines const number for use in assembler)
	counter EQU 0x10	; Address of counter variable
	align	2		; ensure alignment of subsequent instructions 
	; ******* Main programme *********************
delay:
	decfsz 0x20, A
	bra delay
	return
start:	
	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM (highword is upper 16 of 32 bits, low is lower 8 bits -> this gives us the upper 8 bits)
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU (store it in table pointer upper)
	movlw	high(myTable)	; address of data in PM ()
	movwf	TBLPTRH, A	; load high byte to TBLPTRH (store it in table pointer higher)
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	22		; 22 bytes to read (letters of data in db)
	movwf 	counter, A	; our counter register
loop:
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move read data from TABLAT to (FSR0), increment FSR0	
	movff	TABLAT, PORTC
	movlw	0x10
	movwf	0x20, A
	goto	delay
	decfsz	counter, A	; count down to zero (Same as i)
	bra	loop		; keep going until finished
	
	goto	0

	end	main
