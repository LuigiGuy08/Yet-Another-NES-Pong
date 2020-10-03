WinCheck:
	lda P1Points
	cmp #$0A
	bcs WinScreenLoad
	lda P2Points
	cmp #$0A
	bcs WinScreenLoad
	
	bcc NotYetWon
	
NotYetWon:
	rts
	
WinScreenLoad:
	;Disable sprites and background
	lda #$00
	sta $2000
	sta $2001
	
	lda #$02
	sta GameMode
	
	lda #<WinScreen
	sta $03
	lda #>WinScreen
	sta $03+1
	
	lda $2002
	lda #$20 ;High byte of nametable address
	sta $2006
	lda #$00 ;Low byte of nametable address
	sta $2006
	
	
	ldx #$00
	ldy #$00
WinScreenLoadLoop:
	lda ($03),y
	sta $2007
	iny
	cpx #$04
	bne WinScreenInc
	cpy #$c0
	bne WinScreenFinished
	
WinScreenInc:	
	cpy #$00
	bne WinScreenLoadLoop
	inx
	inc $03+1
	jmp WinScreenLoadLoop
	
WinScreenFinished:
	ldx #$00
	
	;Load in finished background
	lda $2002
	lda #>$2000
	sta $2006
	lda #<$2000
	sta $2006
	lda #$00
	sta $2005
	sta $2005
	
	lda P1Points
	cmp P2Points
	bcc WinScreenPlayer2
	bcs WinScreenPlayer1
	
WinScreenPlayer1:
	lda #>$2090
	sta $2006
	lda #<$2090
	sta $2006
	
	lda #$01
	sta $2007
	
	;Re-enable drawing
	lda #%10010000
	sta $2000
	lda #%00001110
	sta $2001
	
	lda #>$2000
	sta $2006
	lda #<$2000
	sta $2006
	rts

WinScreenPlayer2:
	lda #>$2090
	sta $2006
	lda #<$2090
	sta $2006
	
	lda #$02
	sta $2007
	
	;Re-enable drawing
	lda #%10010000
	sta $2000
	lda #%00001110
	sta $2001
	
	lda #>$2000
	sta $2006
	lda #<$2000
	sta $2006
	rts
