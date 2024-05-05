;State
  LDA #GAMESTATE_TITLE
  STA gamestate

;Init BG
  lda #LOW(BGTitle)
  sta pointerLo
  lda #HIGH(BGTitle)
  sta pointerHi

;Init ball
  LDA #$00
  STA ballSpeed
  STA ballup
  STA ballright
  STA balldown
  STA ballleft
  STA isBallSemiAngle
  STA switchBallSemiAngle
  STA level

;Number of lifes
  LDA #$03
  STA nbLife

;Tile with brick
  LDA #$ff
  STA curAdjTileIndex
