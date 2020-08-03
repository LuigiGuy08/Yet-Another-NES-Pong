;Vertical Movement
AIMoveDown:
	lda AIDir
	bne AIMoveDownDone
	inc P2PaddlePos
	;OAM paddle addresses
	inc $218
	inc $21C
	inc $220
	inc $224
	inc $228
	
	;Collision
	lda $228
	cmp #$D0
	bcc AIMoveDownDone
	lda #$01
	sta AIDir
AIMoveDownDone:

AIMoveUp:
	lda AIDir
	beq AIMoveUpDone
	dec P2PaddlePos
	;OAM paddle addresses
	dec $218
	dec $21C
	dec $220
	dec $224
	dec $228
	
	;Collision
	lda $218
	cmp #$10
	bcs AIMoveUpDone
	lda #$00 ;Facing down
	sta AIDir
AIMoveUpDone:

AIMoveDone:	
	rts