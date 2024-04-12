; Draw score into background
DrawScore:
  LDA $2002
  LDA #$20    ; start drawing the score at PPU $2022
  STA $2006
  LDA #$22
  STA $2006

  LDA scoreTens      ; first digit
  CLC
  ADC #$20           ; Get the right tiles (number starts at $10 in arka.chr)
  STA $2007
  LDA scoreOnes      ; last digit
  CLC
  ADC #$20
  STA $2007
EndDrawScore:

; Draw life into background
DrawLife:
  LDA $2002
  LDA #$20    ; start drawing the score at PPU $2040
  STA $2006
  LDA #$3B
  STA $2006

  LDA #$35      ; first digit
  STA $2007
  LDA nbLife    ; Get the right tiles (number starts at $10 in arka.chr)
  CLC
  ADC #$20
  STA $2007
EndDrawLife:
