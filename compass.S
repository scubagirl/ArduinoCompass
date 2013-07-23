; compass.S - avr-gcc assembly language

.include "/tools/lib/atmega32U4.def"
        .global     main
        .extern		setCompass
        .extern		startCompass
        .extern     readCompass
        .extern		loadCompass
        .section    .text
        .org        0x00
main:
       
start:
        ; set stack to top of available ram
        ldi         r28, (RAMEND & 0x00ff)
        ldi         r29, (RAMEND >> 8)
        out         SPH, r29
        out         SPL, r28
        
init:
        
        ; clear flag register
        out         SREG, r1    

        ; set up the system clock
        ldi         r24, 0x80               ; set up prescaler
        sts         CLKPR, r24

.equ    IN_PIN, 0
        cbi         DDRD, IN_PIN       ; set pin 0 on port D for input
;        cbi         PORTD, IN_PIN      ; set pin 0 on port D off

.equ    OUT_PIN, 1
        sbi         DDRD, OUT_PIN       ; set pin 1 on port D for output
        cbi         PORTD, OUT_PIN      ; set pin 1 on port D off

.equ    CLK_PIN, 2
        sbi         DDRD, CLK_PIN       ; set pin 2 on port D for output
        cbi         PORTD, CLK_PIN      ; set pin 2 on port D off

.equ    EN_PIN, 3
        sbi         DDRD, EN_PIN       ; set pin 1 on port D for output
        sbi         PORTD, EN_PIN      ; set pin 1 on port D off

.equ    LED_PIN, 6
        sbi         DDRD, LED_PIN       ; set pin 6 on port D for output
        cbi         PORTD, LED_PIN      ; set pin 6 on port D off
        
.equ    GREEN_PIN, 7
        sbi         DDRD, GREEN_PIN       ; set pin 6 on port D for output
        cbi         PORTD, GREEN_PIN      ; set pin 6 on port D off

shift:
;		call		ledon
;		call		greenon
		call		resetCompass
;		call		ledon
		call		startCompass
;		call		ledon

check:
		call		readCompass
;		call		ledon
;		cpi			r19, 0x0c
;		brne		check
;		call		ledon
		call		loadCompass
;		call		ledon
		cpi			r18, 0
		brne		north
		rcall		south
		
north:		
		call		greenon
		jmp			shift
		
south:
		call		ledon
		jmp			shift

ledon:

		sbi			PORTD, LED_PIN
        call		delay
        cbi			PORTD, LED_PIN
        call		delay
        ret
        
greenon:

		sbi			PORTD, GREEN_PIN
        call		delay
        cbi			PORTD, GREEN_PIN
        call		delay
        ret

delay:
        ldi         r25, 0xff
1:     
		ldi			r26, 0xff
2:
		dec			r26
		brne		2b
        dec			r25
        brne        1b
        ret