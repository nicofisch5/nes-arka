; ************** iNES HEADERS ****************
  include "_ines-header.asm"

; ************** VARIABLES ****************
  include "variables.asm"

; ************** CONSTANTS ****************
  include "constants.asm"

; ************** ABOUT BANKING ****************
  include "_about_banking.asm"

  .bank 0
  .org $C000

; ************** CODE NECESSARY FOR ALL NES GAMES ****************
  include "_reset-vblank-clearmem.asm"

; ************** REAL CODE HERE ****************
  include "init-game.asm"

  include "load-palettes-sprites-background.asm"





;; Avant de rebrancher le PPU
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PPUMASK

Forever:
  JMP Forever     ;jump back to Forever, infinite loop







NMI:          ; Begin interrup (also named VBL)
  LDA #$00
  STA OAMADDR  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer


  LDA #$00        ;;tell the ppu there is no background scrolling
  STA PPUSCROLL
  STA PPUSCROLL


; ************** GAME ENGINE ****************
  include "game-engine.asm"

; ************** DRAW SCORE ****************
  include "draw-score.asm"

; ************** ERASE BRICK ****************
  include "erase-brick.asm"


;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PPUMASK
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA PPUSCROLL
  STA PPUSCROLL


; ************** HERE START INTELLIGENCE OF THE GAME ****************
  JSR ReadController1  ;;get the current button data for player 1
  JSR CheckLaunchBall

  JSR CheckLeftbutton
  JSR CheckRightbutton
  JSR CheckBallCollisionBrick
  JSR UpdateBallPosition

  ; x2 to make speed x2
  JSR CheckLeftbutton
  JSR CheckRightbutton
  JSR CheckBallCollisionBrick
  JSR UpdateBallPosition


EndGameEnginePlaying:

EndGameEngine:


  RTI        ; return from interrupt


; ************** CONTROLLER READING ****************
  include "controller-reading.asm"

; ************** START GAME ****************
  include "launch-ball.asm"

; ************** STICK MOVEMENT ****************
  include "stick-movement.asm"

; ************** BALL COLLISION ****************
  include "ball-collision-brick.asm"

; ************** BALL POSITION ****************
  include "update-ball-position.asm"



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
  .incbin "arka.chr"   ;includes 8KB graphics file
