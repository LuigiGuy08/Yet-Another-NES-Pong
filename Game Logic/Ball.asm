BallMove:
	;Horizontal Movement
	BallMoveRight:
		lda BallDir
		beq BallMoveRightDone
		inc BallPosX
		inc $217 ;OAM Ball X Pos
		
		;Collision
		lda $217
		cmp #$FD
		bcc BallMoveRightDone
		lda #$00 ;Facing Left
		sta BallDir
		
		;Reset ball
		lda #$80
		sta $217
		sta $214
		sta BallPosX
		lda #$00
		sta BallVDir
		
		jmp P1Score
	BallMoveRightDone:
	
	BallMoveLeft:
		lda BallDir
		bne BallMoveLeftDone
		dec BallPosX
		dec $217 ;OAM Ball X Pos
		
		;Collision
		lda $217
		cmp #$02
		bcs BallMoveLeftDone
		lda #$01 ;Facing right
		sta BallDir
		
		;Reset ball
		lda #$80
		sta $217
		sta $214
		sta BallPosX
		lda #$00
		sta BallVDir
		
		jmp P2Score
	BallMoveLeftDone:
	
	;Vertical Movement
	BallMoveUp:
		lda BallVDir
		beq BallMoveUpDone
		dec BallPosY
		dec $214 ;OAM Ball Y Pos
		
		;Collision
		lda $214
		cmp #$10
		bcs BallMoveUpDone
		lda #$00 ;Facing down
		sta BallVDir
	BallMoveUpDone:
	
	BallMoveDown:
		lda BallVDir
		bne BallMoveDownDone
		inc BallPosY
		inc $214 ;OAM Ball Y Pos
		
		;Collision
		lda $214
		cmp #$D0
		bcc BallMoveDownDone
		lda #$01 ;Facing up
		sta BallVDir
	BallMoveDownDone:
	
	BallMoveDone:
		rts
	
P1Score:
	inc P1Points
	;Loads score tile address
	lda #>$2085
	sta $2006
	lda #<$2085
	sta $2006
	
	lda P1Points ;Load numerical tile based on score
	sta $2007
	
	;Restore background
	lda #>$2000
	sta $2006
	lda #<$2000
	sta $2006
	
	jsr WinCheck
	rts
P2Score:
	inc P2Points
	
	;Loads score tile address
	lda #>$209A
	sta $2006
	lda #<$209A
	sta $2006
	
	lda P2Points ;Load numerical tile based on score
	sta $2007
	
	;Restore background
	lda #>$2000
	sta $2006
	lda #<$2000
	sta $2006
	
	lda #$00
	sta AIDir
	
	jsr WinCheck ;Checks if the win screen should be loaded
	rts
	
P1PaddleCollider:
	lda $214 ;Ball X Position
	cmp P1PaddlePos
	bcs P1PaddleRange ;Checks if ball is in paddle's reach
	bcc NotColliding
	
P1PaddleRange:
	lda $214
	cmp $210;Bottom of paddle
	bcc BallXPosCollision ;Next step of Collision
	beq BallXPosCollision
	bcs NotColliding ;End Collision
	
BallXPosCollision:
	lda $217
	cmp #$38 ;Paddle 1 X position
	bne NotColliding
	beq ChangeBallDirCheck
	
ChangeBallDirCheck:
	lda BallDir
	cmp #$01 ;Is the ball moving left?
	beq MoveLeft
	bne MoveRight
	
MoveRight:
	lda #$01
	sta BallDir
	jmp BallMoveLeft
MoveLeft:
	lda #$00
	sta BallDir
	jmp BallMoveRight
	
	
P2PaddleCollider:
	lda $214
	cmp P2PaddlePos
	bcs P2PaddleRange
	bcc NotColliding
	
P2PaddleRange:
	lda $214
	cmp $228;Bottom of paddle
	bcc BallXPosCollisionP2 ;Next step of Collision
	beq BallXPosCollisionP2
	bcs NotColliding ;End Collision
	
BallXPosCollisionP2:
	lda $217
	cmp #$C8 ;Paddle 2 X position
	bne NotColliding
	beq ChangeBallDirCheck

NotColliding:
	rts