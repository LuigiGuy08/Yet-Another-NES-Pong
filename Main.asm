;Variables
include "Variables.asm"

;Header
	.db 'NES',$1a,2,1,0,0
	.db 0,0,0,0,0,0,0,0
	
	.org $8000 ;Start of ROM
	
Reset:
	sei
	cld
	ldx #$40
	stx $4017
	ldx #$FF
	txs ;Sets up stack
	inx ;Clears x
	stx $2000 ;Disables backgrounds/NMI
	stx $2001 ;Disables sprites
	stx $4010
	
	bit $2002

@vblankwait1:
	bit $2002
	bpl @vblankwait1

@clearmem:
	lda #$00
	sta $000,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	cpx #$00
	bne @clearmem
	
@vblankwait2:
	bit $2002
	bpl @vblankwait2
	
PaletteLoad:
	lda $2002
	lda #$3F ;Address high byte
	sta $2006
	lda #$00 ;Address low byte
	sta $2006
	ldx #$00 ;Clear X
PaletteLoadLoop:
	lda Palette,x
	sta $2007
	inx
	cpx #$20
	bne PaletteLoadLoop
	
BackgroundLoad:
	lda #<Demo
	sta $03
	lda #>Demo
	sta $03+1
	
	lda $2002
	lda #$20 ;High byte of nametable address
	sta $2006
	lda #$00 ;Low byte of nametable address
	sta $2006
	
	
	ldx #$00
	ldy #$00
BackgroundLoadLoop:
	lda ($03),y
	sta $2007
	iny
	cpx #$04
	bne BackgroundInc
	cpy #$c0
	bne BackgroundFinished

BackgroundInc:	
	cpy #$00
	bne BackgroundLoadLoop
	inx
	inc $03+1
	jmp BackgroundLoadLoop
	
BackgroundFinished:
	ldx #$00
	
LoadCheck:
	lda GameMode
	cmp #$00 ;Don't load sprites on the title screen
	bne SpriteLoad
	beq SoundGFXEnable ;Skips over sprite load routine
	
SpriteLoad:
	lda GameMode
	cmp #$02
	beq SoundGFXEnable
	ldx #$00
	ldy #$00
	
SpriteLoadLoop:
	lda Sprites,x
	sta $200,x
	inx
	cpx #$40 ;Are 64 sprites loaded?
	bne SpriteLoadLoop
	
SoundGFXEnable:
	;Enable sound
	lda #%00001111 ;Toggles all channels but DMC on
	sta $4015
	
	lda #%10010000 ;Enable NMI and backgrounds
	sta $2000
	
	lda GameMode
	cmp #$01
	bcc TitleScreenSpriteToggle
	
	lda #%00011110 ;Enable sprites
	sta $2001
	
	;Mirror bottom tile of paddle
	lda #%10100000
	sta $212 ;Paddle 1
	sta $22A ;Paddle 2
	
	lda #%00100000 ;Behind background
	sta $202
	sta $206
	sta $20A
	sta $20E
	jmp Main
TitleScreenSpriteToggle:
	lda #%00001110
	sta $2001

Main:
	jsr ScoreCapP1
	jsr ScoreCapP2
	jmp Main

NMI:
	;Register backup
	pha
	txa
	pha
	txy
	pha 
	
	lda #$00
	sta $2003
	lda #$02
	sta $4014
		
	jsr LatchController ;Button fetching routine
	jsr ReadController ;Actual Read Routine
	jsr GameStatusCheck ;Checks if Paddle 2 can be controlled
	jsr BallMoveReady
	jsr P1PaddleCollider
	jsr P2PaddleCollider
	
	;Draw AI sprites
	lda MultiplayerFlag
	cmp #$00
	bne FlagFailed
	beq FlagWon
	
	FlagWon:
		jsr AIMoveDown ;Start of AI move routine
	
	FlagFailed:
		
	
	;Register recovery
	pla
	tax
	pla
	tay
	pla
	
	rti

;Subroutine files	
include "Controller.asm"
include "GameEnter.asm"

GameStatusCheck:
	lda GameMode
	cmp #$01 ;Are we in the main game?
	bcc CheckEnd
	beq Player2Check
	
Player2Check:
	lda MultiplayerFlag
	cmp #$01
	bcc CheckEnd
	beq P2Controller
	
P2Controller:
	jsr LatchControllerP2
	jsr ReadControllerP2
	
CheckEnd:
	rts
	
BallMoveReady:
	lda GameMode
	cmp #$01 ;Are we in the game?
	bne BallCheckFail
	beq BallMoveStart
	
BallMoveStart:
	jsr BallMove
	
BallCheckFail:
	rts
	
ScoreCapP1:
	lda P1Points
	cmp #$0A
	bcc BelowCapP1
	lda #$09
	sta P1Points
	rts
	
BelowCapP1:
	rts
	
ScoreCapP2:
	lda P2Points
	cmp #$0A
	bcc BelowCapP2
	lda #$09
	sta P2Points
	rts
	
BelowCapP2:
	rts

;Object code
include "Game Logic\Ball.asm"
include "Game Logic\AI.asm"
include "Game Logic\Winning.asm"

;Sound Effects
include "SFX.asm"

;Graphics Defines	
	.org $E000
	
include "Demo.asm" ;Title Screen
include "Playfield.asm" ;Game Screen
include "WinScreen.asm" ;The "You win" screen

Palette:
	.db $0f,$20,$10,$00, $0f,$16,$0f,$0f, $0f,$0f,$0f,$0f, $0f,$0f,$0f,$0f ;Background colors
	.db $0f,$20,$10,$00, $0f,$27,$28,$18, $0f,$0f,$0f,$0f, $0f,$0f,$0f,$0f ;Sprite colors

Sprites:
	;Paddle 1
	.db $70,$02,$00,$30
	.db $78,$01,$00,$30
	.db $80,$01,$00,$30
	.db $88,$01,$00,$30
	.db $90,$02,$00,$30
	
	;Ball
	.db $80,$00,$00,$80
	
	;Paddle 2
	.db $70,$02,$00,$D0
	.db $78,$01,$00,$D0
	.db $80,$01,$00,$D0
	.db $88,$01,$00,$D0
	.db $90,$02,$00,$D0
	
;CPU interrupt vectors
	.org $FFFA
	.dw NMI
	.dw Reset
	.dw 0
	
incbin "Demo.chr" ;Graphics file