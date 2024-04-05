; Draw score into background
DrawScore:
  LDA $2002
  LDA #$20    ; start drawing the score at PPU $2021
  STA $2006
  LDA #$22
  STA $2006

  LDA scoreTens      ; first digit
  CLC
  ADC #$10           ; Get the right tiles (number starts at $10 in arka.chr)
  STA $2007
  LDA scoreOnes      ; last digit
  CLC
  ADC #$10
  STA $2007
EndDrawScore:
