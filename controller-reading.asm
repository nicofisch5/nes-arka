ReadController1:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
ReadController1Loop:
  LDA $4016
  LSR A            ; bit0 -> Carry
  ROL joypad1      ; bit0 <- Carry
  DEX
  BNE ReadController1Loop
  RTS
