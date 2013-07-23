; 
.include "/tools/lib/atmega32U4.def"

        .section    .text

        .global     startCompass
        
startCompass:

.equ    OUT_PIN, 1
.equ    CLK_PIN, 2
.equ    EN_PIN,  3

		cbi			PORTD, EN_PIN
		
oneOut:		
		
        sbi         PORTD, CLK_PIN      ; set clock off
        
		sbi			PORTD, OUT_PIN
		call		delay3
		
		cbi			PORTD, CLK_PIN		;set clock on
		call		delay3

		
		ldi			r17, 3				;counter
		
;moves 00 into the compas		
zeroOut:
        sbi         PORTD, CLK_PIN      ; set clock bit on
        
		cbi			PORTD, OUT_PIN		; send a 0	
		call		delay3
		
		cbi			PORTD, CLK_PIN		; set clock bit off
		call		delay3

		dec			r17
		brne		zeroOut
		
		ret
		
; delay 9 cycles
delay3:
		ldi			r25, 0x04
		call		delay
		ret
		
delay:
        dec         r25
        brne        delay
        ret
