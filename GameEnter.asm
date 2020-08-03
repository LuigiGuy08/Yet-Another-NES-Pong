GameLoad:
	
	;Change Game Mode
	lda #$01
	sta GameMode
	
	;Take no controller input
	lda #$00
	sta $4016
	
	;Disable backgrounds and sprites while changing background
	lda #$00
	sta $2000
	sta $2001
	
	;Set up game variables
	
	;Enable ball direction
	lda #$00 ;Down
	sta BallVDir
	sta AIDir
	
	;Initial Paddle position
	lda #$70
	sta P1PaddlePos
	sta P2PaddlePos
	lda #$80
	sta BallPosX
	sta BallPosY
	
	;Clear score
	lda #$00
	sta P1Points
	sta P2Points
	
PlayfieldLoad:
	lda #<Playfield
	sta $03
	lda #>Playfield
	sta $03+1
	
	lda $2002
	lda #$20 ;High byte of nametable address
	sta $2006
	lda #$00 ;Low byte of nametable address
	sta $2006
	
	
	ldx #$00
	ldy #$00
PlayfieldLoadLoop:
	lda ($03),y
	sta $2007
	iny
	cpx #$04
	bne PlayfieldInc
	cpy #$c0
	bne PlayfieldFinished

PlayfieldInc:	
	cpy #$00
	bne PlayfieldLoadLoop
	inx
	inc $03+1
	jmp PlayfieldLoadLoop
	
PlayfieldFinished:
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
	
	jmp SpriteLoad ;Finish initalization routine