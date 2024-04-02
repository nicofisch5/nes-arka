;Init ball
  LDA #$01
  STA ballup
  STA ballright
  LDA #$00
  STA balldown
  STA ballleft
  STA isBallSemiAngle
  STA switchBallSemiAngle

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

  ; nbBricksLeft = NB_BRICKS_IN_LEVEL
  ;LDA #NB_BRICKS_IN_LEVEL
  LDA #NB_BRICKS_IN_LEVEL_TENS * 10
  ADC #NB_BRICKS_IN_LEVEL_ONES
  STA nbBricksLeft
