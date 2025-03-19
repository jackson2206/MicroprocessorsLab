#include <xc.inc>
 
psect	udata_acs
ARG1H:	ds  1
ARG1L:	ds  1
ARG2H:	ds  1
    
psect	multiplication_code, class=CODE 

x16bit:
	movf	ARG1L,W,A

end	


