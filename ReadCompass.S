; 
.include "/tools/lib/atmega32U4.def"

        .section    .text

        .global     readCompass

readCompass:

.equ    IN_PIN, 0
.equ    OUT_PIN, 1
.equ    CLK_PIN, 2
.equ    EN_PIN,  3
.equ    LED_PIN, 7


		; Pulse /EN.
        sbi         PORTD, EN_PIN      ; set pin 1 on port D on
        ldi			r25, 0xff
        call		delay
        call		delay
        call		delay
        call		delay
		cbi         PORTD, EN_PIN      ; set pin 1 on port D off

        ldi			r25, 0xff
        call		delay

		ldi			r17, 2				;counter

;moves b11 into the compass
oneOut:		
		
        sbi         PORTD, CLK_PIN      ; set clock off
        
		sbi			PORTD, OUT_PIN
		call		delay3
		
		cbi			PORTD, CLK_PIN		;set clock on
		call		delay3

		dec			r17
		brne		oneOut

		
		ldi			r17, 2				;counter
		
;moves b00 into the compas		
zeroOut:
        sbi         PORTD, CLK_PIN      ; set clock bit on
        
		cbi			PORTD, OUT_PIN		; send a 0	
		call		delay3
		
		cbi			PORTD, CLK_PIN		; set clock bit off
		call		delay3

		dec			r17
		brne		zeroOut
		
		ldi			r17, 4

		eor			r19,r19
;should read in 1100		
inLoop:
		lsl			r19
		
		sbi			PORTD, CLK_PIN
		call		delay3
		
		in			r18, PIND
		and			r18, 0x01
		or			r19,r18

		cbi			PORTD, CLK_PIN
		call		delay3
		
		dec			r17
		brne		inLoop
		
test:
		cpi			r19, 0x0c
		breq		leave
		call		readCompass
leave:
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
        
ledon:

		in      	r24, PORTD          ; get current port D values
        ldi    		r25, (1 << LED_PIN) ; LED pin number
        eor     	r24, r25            ; toggle bit
        out     	PORTD, r25          ; write it back in place
        call		delayLED
        cbi			PORTD, LED_PIN
        call		delayLED
        ret

delayLED:
        ldi         r25, 0xff
1:     
		ldi			r26, 0xff
2:
		dec			r26
		brne		2b
        dec			r25
        brne        1b
        ret

		
 