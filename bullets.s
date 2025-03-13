#include <xc.inc>
psect	udata_bank5
bullets:    ds	0x40
psect	data
bullet_mp:
	db	0x00,0x00,0x00,0x0F,0x0F,0x00,0x00,0x00
	align	2
	bull	EQU 8
psect	bullets_code,class=Code

gen_bullet:
	    


