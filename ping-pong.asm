;1942218 Mehmet Mert KAN
	
	list P=18F8722

#include <p18f8722.inc>
	config OSC = HSPLL, FCMEN = OFF, IESO = OFF, PWRT = OFF, BOREN = OFF, WDT = OFF, MCLRE = ON, LPT1OSC = OFF, LVP = OFF, XINST = OFF, DEBUG = OFF


state_left	equ	0x00 
state_right	equ	0x01
state_ball_x    udata     0x03
state_ball_x
    
state_ball_y    udata     0x04
state_ball_y
    
goal_left_score	udata	0x15
goal_left_score
	
goal_right_score	udata	0x16
goal_right_score	
    
port_position	udata	0x0A
port_position
    
counter		equ	0x22
		
counter10	udata	0x20	
counter10
		
	
direction	udata	0x06 ;0->left, 1->right
direction 
		
w_temp  udata 0x23
w_temp

status_temp udata 0x24
status_temp
 
pclath_temp udata 0x25
pclath_temp

	org     0x00
	goto    init
	
	org	0x08
	goto	isr

init:
	
	clrf	TRISA
	clrf	TRISB
	clrf	TRISC
	clrf	TRISD
	clrf	TRISE
	clrf	TRISF	
	clrf	TRISG
	clrf	TRISH
	clrf	TRISJ
	
	
	
	movlw	b'00011100'
	movwf	LATA
	
	movlw	b'00001000'
	movwf	LATD
	
	movlw	d'3'
	movwf	state_ball_x
	
	movlw	d'8'
	movwf	state_ball_y
	
	movlw	b'00011100'
	movwf	LATF
	
	clrf	direction
	
	movlw	b'00001111'
	movwf	TRISG
	
	movlw	7Fh     ; Configure A/D 
	movwf	ADCON1  ; for digital inputs
	
	movlw	d'2'
	movwf	state_left
	movlw	d'2'
	movwf	state_right
	
	
	
	;Disable interrupts
	clrf	TMR0
	clrf    INTCON
	clrf    INTCON2
	
	
	bcf     INTCON2, 7 ;Pull-ups are enabled - clear INTCON2<7>
	
	;Initialize Timer0
	movlw   b'00001001' ;Disable Timer0 by setting TMR0ON to 0 (for now)
			    ;Configure Timer0 as an 8-bit timer/counter by setting T08BIT to 1
			    ;Timer0 increment from internal clock with a prescaler of 1:256.
	movwf   T0CON ; T0CON = b'01000111'

	;Enable interrupts
	movlw   b'10100100' ;Enable Global, peripheral, Timer0 and RB interrupts by setting GIE, PEIE, TMR0IE and RBIE bits to 1
	movwf   INTCON

	bsf     T0CON, 7    ;Enable Timer0 by setting TMR0ON to 1	
	
	movlw	b'01111001'
	movwf	T1CON
	
	goto	press_RG0
		

main:
	
	
state_left_0:
	movlw	b'00000111'
	movwf	LATA
	movlw	d'0'
	movwf	state_left
	goto	press_RG0
	
state_left_1:
	movlw	b'00001110'
	movwf	LATA
	movlw	d'1'
	movwf	state_left
	goto	press_RG0	
	
state_left_2:
	movlw	b'00011100'
	movwf	LATA
	movlw	d'2'
	movwf	state_left
	goto	press_RG0
	
state_left_3:
	movlw	b'00111000'
	movwf	LATA
	movlw	d'3'
	movwf	state_left
	goto	press_RG0
	
	
	
state_right_0:
	movlw	b'00000111'
	movwf	LATF
	movlw	d'0'
	movwf	state_right
	goto	press_RG0
	
state_right_1:
	movlw	b'00001110'
	movwf	LATF
	movlw	d'1'
	movwf	state_right
	goto	press_RG0	
	
state_right_2:
	movlw	b'00011100'
	movwf	LATF
	movlw	d'2'
	movwf	state_right
	goto	press_RG0
	
state_right_3:
	movlw	b'00111000'
	movwf	LATF
	movlw	d'3'
	movwf	state_right
	goto	press_RG0
	
	
	
press_RG0:
	;movff	goal_left_score, WREG	; prepare WREG before table lookup
	;CALL	TABLE	; 0's bit settings for 7-seg. disp. returned into WREG
	;MOVWF	LATJ	; apply correct bit settings to portJ (7-seg. disp.)
	
	;movff	goal_right_score, WREG	; prepare WREG before table lookup
	;CALL	TABLE	; 0's bit settings for 7-seg. disp. returned into WREG
	;MOVWF	LATJ	; apply correct bit settings to portJ (7-seg. disp.)
	
	;movff	goal_left_score, WREG
	
	
	
	bsf	LATH,1
	bcf	LATH,0
	bcf	LATH,2
	bcf	LATH,3
	
	movlw	d'0'
	cpfseq	goal_right_score
	goto	seven_dis_1
	movlw	b'00111111'
	movwf	LATJ
	goto	devam

seven_dis_1:
	movlw	d'1'
	cpfseq	goal_left_score
	goto	seven_dis_2
	movlw	b'00000110'
	movwf	LATJ
	goto	devam	
	
seven_dis_2:
	movlw	d'2'
	cpfseq	goal_left_score
	goto	seven_dis_3
	movlw	b'01011011'
	movwf	LATJ
	goto	devam
	
seven_dis_3:
	movlw	d'3'
	cpfseq	goal_left_score
	goto	seven_dis_4
	movlw	b'01001111'
	movwf	LATJ
	goto	devam
	
seven_dis_4:
	movlw	d'4'
	cpfseq	goal_left_score
	goto	devam
	movlw	b'01100110'
	movwf	LATJ
	goto	devam
	
seven_dis_5:
	movlw	d'5'
	cpfseq	goal_right_score
	goto	devam
	movlw	b'01101101'
	movwf	LATJ
	goto	devam	

	
devam:
	btfss	PORTG,0
	goto	press_RG1
	goto	release_RG0
release_RG0:
	btfsc	PORTG,0
	goto	release_RG0
	movlw	d'3'
	cpfseq	state_right
	incf	state_right
	call	state_chooser_right
	
press_RG1:
	btfss	PORTG,1
	goto	press_RG2
	goto	release_RG1
release_RG1:
	btfsc	PORTG,1
	goto	release_RG1
	tstfsz	state_right
	decf	state_right
	call	state_chooser_right
	
press_RG2:
	btfss	PORTG,2
	goto	press_RG3
	goto	release_RG2
release_RG2:
	btfsc	PORTG,2
	goto	release_RG2
	movlw	d'3'
	cpfseq	state_left
	incf	state_left
	call	state_chooser_left
	
press_RG3:
	btfss	PORTG,3
	goto	press_RG0
	goto	release_RG3
release_RG3:
	btfsc	PORTG,3
	goto	release_RG3
	tstfsz	state_left
	decf	state_left
	call	state_chooser_left
	
	
	
	
state_chooser_left:
	movlw	d'0'
	cpfsgt	state_left
	goto	state_left_0
	incf	WREG
	cpfsgt	state_left
	goto	state_left_1
	incf	WREG
	cpfsgt	state_left
	goto	state_left_2
	incf	WREG
	cpfsgt	state_left
	goto	state_left_3
	
	
	
state_chooser_right:
	movlw	d'0'
	cpfsgt	state_right
	goto	state_right_0
	incf	WREG
	cpfsgt	state_right
	goto	state_right_1
	incf	WREG
	cpfsgt	state_right
	goto	state_right_2
	incf	WREG
	cpfsgt	state_right
	goto	state_right_3
	
	
move_ball:
	movlw	d'0'
	cpfseq	state_ball_x
	goto	hello
	bsf	direction,0
	
hello:	
	movlw	d'5'
	cpfseq	state_ball_x
	goto	hello2
	bcf	direction,0
	
	
hello2:	
	btfss	direction,0
	goto	hello3
	incf	state_ball_x
	goto	hello4
	
hello3:
	decf	state_ball_x
	
	
hello4:	
	clrf	WREG
	subwf	TMR0,0
	subwf	TMR1,0
	movwf	counter10 ;counter10's last two bits decide direction selection algorithm.
	btfss	counter10,1
	goto	check
	btfss	counter10,0
	goto	go_down
	goto	myreturn
	
check:
	btfss	counter10,0
	goto	myreturn
	goto	go_up

go_up:
	movlw	b'000001'
	cpfseq	state_ball_y
	rrncf	state_ball_y
	goto	myreturn
go_down:
	movlw	b'100000'
	cpfseq	state_ball_y
	rlncf	state_ball_y
	goto	myreturn
	
myreturn:
	call	supur
	call	yak
	call	check_light
	return
	
	
check_light:
	movlw	d'0'
	cpfseq	state_ball_x
	goto	check_light_5
	movff	PORTA, WREG
	cpfseq	port_position
	call	goal_right
	return

check_light_5:
	movlw	d'5'
	cpfseq	state_ball_x
	return
	movff	PORTF, WREG
	cpfseq	port_position
	call	goal_left
	return
	
goal_left:
	incf	goal_left_score
	movlw	d'5'
	cpfseq	goal_left_score
	goto	init
	goto	game_over
	
goal_right:
	incf	goal_right_score
	movlw	d'5'
	cpfseq	goal_right_score
	goto	init
	goto	game_over
	
yak:
	movlw	d'0'
	cpfseq	state_ball_x
	goto	yak2
	movff	PORTA, port_position
	movff	PORTA, WREG
	iorwf	state_ball_y,0
	movwf	PORTA
	
yak2:
	movlw	d'1'
	cpfseq	state_ball_x
	goto	yak3
	movff	state_ball_y, PORTB	
yak3:
	movlw	d'2'
	cpfseq	state_ball_x
	goto	yak4
	movff	state_ball_y, PORTC
	
yak4:
	movlw	d'3'
	cpfseq	state_ball_x
	goto	yak5
	movff	state_ball_y, PORTD
	
yak5:
	movlw	d'4'
	cpfseq	state_ball_x
	goto	yak6
	movff	state_ball_y, PORTE
	
yak6:
	movlw	d'5'
	cpfseq	state_ball_x
	return	
	movff	PORTF, port_position
	movff	PORTF, WREG
	iorwf	state_ball_y,0
	movwf	PORTF
	
supur:
	clrf	LATB
	clrf	LATC
	clrf	LATD
	clrf	LATE
	return
	
game_over:	
	clrf	INTCON
	clrf	T0CON
	clrf	T1CON
	clrf	LATA
	clrf	LATB
	clrf	LATC
	clrf	LATD
	clrf	LATE
	clrf	LATF
	
	bsf	LATH,1
	bcf	LATH,0
	bcf	LATH,2
	bcf	LATH,3
	
	clrf	TRISG
	clrf	LATG
	movlw	d'5'
	cpfseq	goal_left_score
	goto	func1
	movlw	b'01101101'
	movwf	LATJ
	clrf	TRISH
	clrf	TRISJ
		
func1:	
	

	goto	game_over
	

isr:
    call    save_registers  ;Save current content of STATUS and PCLATH registers to be able to restore them late
    btfss   INTCON, 2       ;Is this a timer interrupt?
    return			;No. return
    goto    timer_interrupt ;Yes. Goto timer interrupt handler part

;;;;;;;;;;;;;;;;;;;;;;;; Timer interrupt handler part ;;;;;;;;;;;;;;;;;;;;;;;;;;
timer_interrupt:
    incf	counter, f              ;Timer interrupt handler part begins here by incrementing count variable
    movf	counter, w              ;Move count to Working register
    sublw	d'185'    ;185c                ;Decrement 5 from Working register
    btfss	STATUS, Z               ;Is the result Zero?
    goto	timer_interrupt_exit    ;No, then exit from interrupt service routine
    call	move_ball
    clrf	counter                 ;Yes, then clear count variable
    
timer_interrupt_exit:
	bcf     INTCON, 2		;Clear TMROIF
	movlw	d'250'               ;256-=195; 195*256*5 = 249600 instruction cycle;
	movwf	TMR0
	
	call	restore_registers   ;Restore STATUS and PCLATH registers to their state before interrupt occurs
	retfie

	
;;;;;;;;;;;; Register handling for proper operation of main program ;;;;;;;;;;;;
save_registers:
    movwf 	w_temp          ;Copy W to TEMP register
    swapf 	STATUS, w       ;Swap status to be saved into W
    clrf 	STATUS          ;bank 0, regardless of current bank, Clears IRP,RP1,RP0
    movwf 	status_temp     ;Save status to bank zero STATUS_TEMP register
    movf 	PCLATH, w       ;Only required if using pages 1, 2 and/or 3
    movwf 	pclath_temp     ;Save PCLATH into W
    clrf 	PCLATH          ;Page zero, regardless of current page
    return

restore_registers:
    movf 	pclath_temp, w  ;Restore PCLATH
    movwf 	PCLATH          ;Move W into PCLATH
    swapf 	status_temp, w  ;Swap STATUS_TEMP register into W
    movwf 	STATUS          ;Move W into STATUS register
    swapf 	w_temp, f       ;Swap W_TEMP
    swapf 	w_temp, w       ;Swap W_TEMP into W
    return
	

    	
	
	end
	