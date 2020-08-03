;System Defines
Buttons1 = $00 ;Currently pressed controller button
Buttons2 = $01
MultiplayerFlag = $02
PlayAgainFlag = $03 ;This flag actually checks if you DON'T want to play again
GameMode = $10 ;Detects if in title screen or main game
P1Points = $11
P2Points = $12

;Game Variables
P1PaddlePos = $20
P2PaddlePos = $21
BallPosX = $22
BallPosY = $23
BallDir = $24 ;Is the ball left or right?
BallVDir = $25 ;Is the ball up or down?
AIDir = $26

;Button Tracking
ButtonA = #$80
ButtonB = #$40
ButtonSelect = #$20
ButtonStart = #$10
ButtonUp = #$08
ButtonDown = #$04
ButtonLeft = #$02
ButtonRight = #$01