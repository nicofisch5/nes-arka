; chadk start button
CheckLaunchBall:
  LDY #0
  LDX #0
  LDA joypad1        ; Load controller state
  AND #BUTTON_UP   ; AND with UP button mask
  BNE LaunchBall
  JMP EndCheckLaunchBall

  LaunchBall:
    LDA #$01
    STA ballSpeed
    STA ballup
    STA ballleft
  EndLaunchBall:

EndCheckLaunchBall:
  RTS
