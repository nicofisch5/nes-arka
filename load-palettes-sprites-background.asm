; The palettes start at PPU address $3F00 (background) and $3F10 (sprite).
; To write in a PPU address, we use PPU registers PPUADDR at address $2006
; This register must be written twice (16 bits), once for the high byte then for the low byte.

LoadPalettes:
  LDA PPUSTATUS    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA PPUADDR  ; write the high byte of $3F00 address
  LDA #$00
  STA PPUADDR  ; write the low byte of $3F00 address
  LDX #$00

; Loop to copy palette in the PPU.
; X register is used to count how many times the loop has repeated
; The loop starts at 0 and counts up to 32.
LoadPalettesLoop:
  LDA palette, x        ; PPUADDR is auto incremented each write in PPUDATA
                        ; load data from address (PaletteData + the value in x)
                        ; 1st time through loop it will load PaletteData+0
                        ; 2nd time through loop it will load PaletteData+1
                        ; 3rd time through loop it will load PaletteData+2, etc
  STA PPUDATA           ; write to PPU (using register PPUDATA)
  INX                   ; set index to next byte
  CPX #$20
  BNE LoadPalettesLoop  ; if x = $20, 32 bytes copied, all done

  ; Boucle qui affiche plusieurs sprites
LoadSprites:
  LDX #$00              ; start at 0

LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites + x)
  STA SPR_STICK_ADDR, x ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$18              ; Compare X to hex $10, decimal 16
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 16, continue down

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA PPUCTRL      ; PPUCTRL ca be access at $2000
                   ; Each bit has its importance

LoadBG:
  LDA PPUSTATUS         ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR           ; write the high byte of $2000 address
  LDA #$00
  STA PPUADDR           ; write the low byte of $2000 address

  LDX #$00
  LDY #$00

; Load entire BG
LoadBGLoop:
  lda [pointerLo], y	; can only be used with y
  sta $2007
  iny
  bne LoadBGLoop
  inc pointerHi
  inx
  cpx #$04
  bne LoadBGLoop

LoadAttribute:
  LDA PPUSTATUS         ; read PPU status to reset the high/low latch
  LDA #$23
  STA PPUADDR           ; write the high byte of $23C0 address
  LDA #$C0
  STA PPUADDR           ; write the low byte of $23C0 address
  LDX #$00

LoadAttributeLoop:
  LDA attribute, x      ; load data from address (attribute + the value in x)
  STA PPUDATA           ; write to PPU
  INX                   ; X = X + 1
  CPX #$40              ; Compare X to hex $40, decimal 64 - copying 8 bytes
  BNE LoadAttributeLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero

  LDX #$00
  LDY #$00
LoadBricksInRAM:
  lda [pointerLoMask], y	; can only be used with y
  STA bricks,y            ; vers la RAM
  iny
  CPY #4 * 31
  bne LoadBricksInRAM

;Set initial score value
InitialScoreValues:
  LDA #NB_BRICKS_IN_LEVEL_ONES
  STA scoreOnes
  LDA #NB_BRICKS_IN_LEVEL_TENS
  STA scoreTens

  LDA #NB_BRICKS_IN_LEVEL_TENS * 0
  ADC #NB_BRICKS_IN_LEVEL_ONES
  STA nbBricksLeft
