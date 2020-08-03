LatchController:
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	ldx #$08
ControllerLoop:
	lda $4016
	lsr a
	rol Buttons1 ;Current button address
	dex ;Reads each succesive button
	bne ControllerLoop
	rts
	
LatchControllerP2:
	lda #$01
	sta $4017
	lda #$00
	sta $4017

	ldx #$08
ControllerLoopP2:
	lda $4017
	lsr a
	rol Buttons2 ;Current button address
	dex ;Reads each succesive button
	bne ControllerLoopP2
	rts

ReadController:

StartPressed:
	lda Buttons1
	cmp #ButtonStart
	bne StartDone
	beq ModeCheck
StartDone:

UpPressed:
	lda Buttons1
	cmp #ButtonUp
	bne UpDone
	dec P1PaddlePos ;Variable the game uses for calculations
	dec $200
	dec $204
	dec $208
	dec $20C
	dec $210
UpDone:

DownPressed:
	lda Buttons1
	cmp #ButtonDown
	bne DownDone
	inc P1PaddlePos
	inc $200
	inc $204
	inc $208
	inc $20C
	inc $210
DownDone:

SelectPressed:
	lda Buttons1
	cmp #ButtonSelect
	bne SelectDone
	beq GameCheck
SelectDone:
	rts	
ModeCheck:
	lda GameMode
	cmp #$01 ;Are we on the title screen?
	bcc GameLoadReady
	bcs WinScreenReturn	
WinScreenReturn:
	lda GameMode
	cmp #$02
	bcc Null
	beq TitleScreenReturn	
Null:
	rts
TitleScreenReturn:
	lda #$00
	sta $2000
	sta $2001
	lda #$00 ;Title Screen game mode
	sta GameMode
	jmp BackgroundLoad	
GameCheck:
	lda GameMode
	cmp #$01
	bcc MultiplayerSet ;Enable mode if on title screen
	bcs ModeCheckEnd
	
GameLoadReady:
	jmp GameLoad
	
ModeCheckEnd:
	rts
	
MultiplayerSet:
	lda #$01
	sta MultiplayerFlag
	jsr CursorTile
	rts
	
CursorTile:
	;Tile Address
	lda #>$218B
	sta $2006
	lda #<$218B
	sta $2006
	
	lda #$2f ;Blank Tile
	sta $2007
	
	;Tile Address
	lda #>$21CB
	sta $2006
	lda #<$21CB
	sta $2006
	
	lda #$2A ;Cursor tile
	sta $2007
	
	;Reload background
	lda #>$2000
	sta $2006
	lda #<$2000
	sta $2006
	rts
	
ReadControllerP2:

UpPressedP2:
	lda Buttons2
	cmp #ButtonUp
	bne UpDoneP2
	dec P2PaddlePos
	dec $218
	dec $21C
	dec $220
	dec $224
	dec $228
UpDoneP2:

DownPressedP2:
	lda Buttons2
	cmp #ButtonDown
	bne DownDoneP2
	inc P2PaddlePos
	inc $218
	inc $21C
	inc $220
	inc $224
	inc $228

DownDoneP2:

	rts