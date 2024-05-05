PutBallOnStick:
  LDA #$CC
  STA SPR_BALL_ADDR
  LDA #$82
  STA SPR_BALL_ADDR+3

  ; Ball is stopped
  LDA #$00
  STA ballSpeed
  STA ballup
  STA balldown
  STA ballleft
  STA ballright

  ; Stick in the middle
  LDA #$70
  STA SPR_STICK_ADDR+3
  LDA #$79
  STA SPR_STICK_ADDR+3+4
  LDA #$82
  STA SPR_STICK_ADDR+3+8
  LDA #$8B
  STA SPR_STICK_ADDR+3+12
  LDA #$94
  STA SPR_STICK_ADDR+3+16

  RTS
EndPutBallOnStick:
