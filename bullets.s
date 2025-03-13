#include <xc.inc>
psect	udata_acs
bullets:    ds	0x40
bullet_sprite:
	    ds	0x40
psect	data
bullet_mp:
	db	0x00,0x00,0x00,0x0F,0x0F,0x00,0x00,0x00
	align	2
	b	EQU 8
psect	bullets_code,class=Code

gen_bullet:
	    


