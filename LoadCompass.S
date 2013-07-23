; x MSB = r18, y MSB = r19
.include "/tools/lib/atmega32U4.def"

        .section    .text

        .global     loadCompass

loadCompass:

.equ    IN_PIN, 0
.equ    CLK_PIN, 2
.equ    EN_PIN,  3

		ldi		r16, 10 ;load counter

		eor			r18, r18
		eor			r19, r19
readXMSB:
		sbi			PORTD, CLK_PIN
		in			r18, PIND
		and			r18, 0x01	
			
pass:		
		call		read10

readYMSB:
		sbi			PORTD, CLK_PIN
		in			r19, PIND
		and			r19, 0x01
		call		read10
		
read10:
		call		delay3
		cbi			PORTD, CLK_PIN
		call		delay3
		sbi			PORTD, CLK_PIN
		in			r17, PIND	
		
		dec			r16
		cpi			r16, 0
		brne		read10
		
		sbi			PORTD, EN_PIN
		
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
