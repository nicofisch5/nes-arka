; ************** iNES HEADERS ****************
  include "_ines-header.asm"


; ************** VARIABLES ****************
  .rsset $0000  ;;start variables at ram location 0

joypad1    .rs 1  ; player 1 gamepad buttons, one bit per button
ballx      .rs 1  ; ball horizontal position
bally      .rs 1  ; ball vertical position
ballup     .rs 1  ; 1 = ball moving up
balldown   .rs 1  ; 1 = ball moving down
ballright  .rs 1  ; 1 = ball moving right
ballleft   .rs 1  ; 1 = ball moving left

; ************** CONSTANTS ****************
; For joypad
BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

; For sprites
SPR_STICK_ADDR        = $200
SPR_STICK_SIZE        = $20
WALL_LIMIT_LEFT       = $00
WALL_LIMIT_RIGHT      = $D5
SPR_BALL_ADDR         = $214


; ************** ABOUT BANKING ****************
; NESASM arranges everything in 8KB code and 8KB graphics banks.
; To fill the 16KB PRG space 2 banks are needed 0 and 1)
; NESASM needs these directives in order to know how many 8KB banks your ROM has

; .bank and .org control two completely different things
; .bank controls the location of the data in your output file (i.e. your ROM image)
; .org specifies the address range in which the 6502 is actually going to see that data.

  ; $C000 is often the address where the CPU starts executing instructions
  ; when the NES is powered on.

  ; Pour les cartouches (ROM - code et données, hors données graphiques) de 16 Ko,
  ; le code est tout à la fin de l'espace d'adressage du CPU, soit de $C000 à $FFFF

  .bank 0
  .org $C000

  ;
; ************** CODE NECESSARY FOR ALL NES GAMES ****************
  include "_reset-vblank-clearmem.asm"


; ************** REAL CODE HERE ****************

; The palettes start at PPU address $3F00 (background) and $3F10 (sprite).
; To write in a PPU address, we use PPU registers PPUADDR at address $2006
; This register must be written twice (16 bits), once for the high byte then for the low byte.

LoadPalettes:
  LDA $2002    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006    ; write the low byte of $3F00 address
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
  STA $2007             ; write to PPU (using register PPUDATA)
  INX                   ; set index to next byte
  CPX #$20
  BNE LoadPalettesLoop  ; if x = $20, 32 bytes copied, all done

  ;Init ball
  LDA #$40
  STA ballx
  LDA #$50
  STA bally
  LDA #$01
  STA ballup
  STA ballright
  LDA #$00
  STA balldown
  STA ballleft

  ; Boucle qui affiche plusieurs sprites
LoadSprites:
  LDX #$00              ; start at 0

LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites + x)
  STA SPR_STICK_ADDR, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$18              ; Compare X to hex $10, decimal 16
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 16, continue down

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000        ; PPUCTRL ca be access at $2000
                   ; Each bit has its importance


LoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  LDY #$00

LoadBackgroundLoopLin:
  LDX #$00              ; start out at 0

  LoadBackgroundLoopCol:
    LDA background, x     ; load data from address (background + the value in x)
    STA $2007             ; write to PPU
    INX                   ; X = X + 1
    CPX #$20              ; Compare X to hex $20, decimal 32
    BNE LoadBackgroundLoopCol  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero

  INY                   ; Y = Y + 1
  CPY #$1E              ; Compare X to hex $1E, decimal 30
  BNE LoadBackgroundLoopLin

LoadAttribute:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDY #$00

LoadAttributeLoopLin:
  LDX #$00

  LoadAttributeLoopCol:
    LDA attribute, x      ; load data from address (attribute + the value in x)
    STA $2007             ; write to PPU
    INX                   ; X = X + 1
    CPX #$08              ; Compare X to hex $08, decimal 8 - copying 8 bytes
    BNE LoadAttributeLoopCol  ; Branch to LoadAttributeLoop if compare was Not Equal to zero

  INY                   ; Y = Y + 1
  CPY #$08
  BNE LoadAttributeLoopLin



  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop



NMI:
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA $2005
  STA $2005




  JSR ReadController1  ;;get the current button data for player 1
  JSR CheckLeftbutton
  JSR CheckRightbutton
  JSR UpdateBallPosition  ;;set ball sprites from positions




  RTI        ; return from interrupt

;;;;;;;;;;;;;;

; Initialize controller reading
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

; Check the state of the Left and Right button
CheckLeftbutton:
  LDY #0
  LDX #0
  LDA joypad1  ; Load controller state
  AND #BUTTON_LEFT   ; Perform bitwise AND with LEFT button mask
  BNE CheckCollisionLeftWall
    ; Left button is not pressed
    ; Your code here
  RTS

CheckCollisionLeftWall:
  LDA SPR_STICK_ADDR+3
  CMP #WALL_LIMIT_LEFT
  BEQ CollisionLeftWall

MoveStickLeftLoop:
  LDA SPR_STICK_ADDR+3,y     ; load sprite X position
  SEC             ; make sure the carry flag is clear
  SBC #$01        ; A = A - 1
  STA SPR_STICK_ADDR+3,y     ; save sprite X position
  INY             ; add the offset of 4
  INY
  INY
  INY             ; (one sprite is 4 bytes)
  INX
  CPX #$05        ; loop 4 time because of 4 sprites to move
  BNE MoveStickLeftLoop
  RTS

CollisionLeftWall:
  ; no code, just no move

CheckRightbutton:
  LDY #0
  LDX #0
  LDA joypad1  ; Load controller state
  AND #BUTTON_RIGHT   ; Perform bitwise AND with LEFT button mask
  BNE CheckCollisionRightWall
    ; Left button is not pressed
    ; Your code here
  RTS

CheckCollisionRightWall:
  LDA SPR_STICK_ADDR+3
  CMP #WALL_LIMIT_RIGHT
  BEQ CollisionRightWall

MoveStickRightLoop:
  LDA SPR_STICK_ADDR+3,y     ; load sprite X position
  CLC             ; make sure the carry flag is clear
  ADC #$01        ; A = A + 1
  STA SPR_STICK_ADDR+3,y     ; save sprite X position
  INY             ; add the offset of 4
  INY
  INY
  INY             ; (one sprite is 4 bytes)
  INX
  CPX #$05        ; loop 4 time because of 4 sprites to move
  BNE MoveStickRightLoop
  RTS

CollisionRightWall
  ; no code, just no move

UpdateBallPosition:
  LDA SPR_BALL_ADDR+0        ; load data from address (sprites + x)
  CLC
  ADC ballright
  SEC
  SBC ballleft
  STA SPR_BALL_ADDR+0          ; store into RAM address ($0200 + x)

  LDA SPR_BALL_ADDR+3        ; load data from address (sprites + x)
  CLC
  ADC balldown
  SEC
  SBC ballup
  STA SPR_BALL_ADDR+3          ; store into RAM address ($0200 + x)

  RTS



  ; $E000: refers to the start of the ROM bank that contains additional program code or data

  .bank 1
  .org $E000
  .include "palette-sprites-background.asm"


  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial


;;;;;;;;;;;;;;

  ; CHR graphics are part of the PPU memory, which starts at $0000
  ; Les cartouche NES contiennes une ROM 8 Ko dédiée aux données graphiques
  ; Le PPU « verra » cette ROM aux adresses de $0000 à $1FFF dans sa mémoire à lui.

  .bank 2
  .org $0000
  .incbin "arka.chr"   ;includes 8KB graphics file from SMB1
