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
  LDA #$00
  STA balldown
  STA ballleft
  STA isBallSemiAngle
  STA switchBallSemiAngle

;Number of lifes
  LDA #$03
  STA nbLife

;Tile with brick
  LDA #$ff
  STA curAdjTileIndex

;Set initial score value
  LDA #NB_BRICKS_IN_LEVEL_ONES
  STA scoreOnes
  LDA #NB_BRICKS_IN_LEVEL_TENS
  STA scoreTens

  LDX #0
LoadBricksInRAM:
  LDA bricks_mask,x    ; depuis la ROM
  STA bricks,x         ; vers la RAM
  INX
  CPX #4 * 31          ; 124 octets à copier
  BNE LoadBricksInRAM

  LDA #NB_BRICKS_IN_LEVEL_TENS * 10
  ADC #NB_BRICKS_IN_LEVEL_ONES
  STA nbBricksLeft
