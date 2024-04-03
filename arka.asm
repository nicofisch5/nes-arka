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
  include "load-palettes-sprites-background.asm"
  include "init-game.asm"

;; Avant de rebrancher le PPU
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PPUMASK

Forever:
  JMP Forever     ;jump back to Forever, infinite loop


NMI:          ; also named VBL
  LDA #$00
  STA OAMADDR  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

; Erase brick if necessary
  ; Add a condition if(there is a brick to erase)
  LDA currenttileaddress  ;
  STA PPUADDR             ; write the high byte of the tile address
  LDA currenttileaddress+1
  STA PPUADDR             ; write the low byte of the tile address
  LDA #$ff                  ; tile ID
  STA PPUDATA

; Draw score into background
DrawScore:
  LDA $2002
  LDA #$20    ; start drawing the score at PPU $2021
  STA $2006
  LDA #$21
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

;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUCTRL
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PPUMASK
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA PPUSCROLL
  STA PPUSCROLL



;; Intelligence of the program
  JSR ReadController1  ;;get the current button data for player 1
  JSR CheckLeftbutton
  JSR CheckRightbutton
  JSR UpdateBallPosition  ;;set ball sprites from positions

  RTI        ; return from interrupt

;;;;;;;;;;;;;;

; ************** CONTROLLER READING ****************
  include "controller-reading.asm"

; ************** STICK MOVEMENT ****************
  include "stick-movement.asm"


; Move the ball and check for collisions
UpdateBallPosition:
  JSR CheckBallCollisionBrick
  JSR CheckBallCollisionCeiling
  JSR CheckBallCollisionLeftWall
  JSR CheckBallCollisionRightWall
  JSR CheckBallCollisionStick
  JSR CheckBallCollisionBottom

  ; Left/Right movement
  LDA SPR_BALL_ADDR+3        ; load data from address (sprites + x)
  CLC
  ADC ballright
  SEC
  SBC ballleft
  STA SPR_BALL_ADDR+3          ; store into RAM address ($0200 + x)

  ; Check ball angle
  LDA isBallSemiAngle
  BEQ UpDownMovement      ; No angle => normal movement
  BNE ManageBallSemiAngle

ManageBallSemiAngle:
  LDA switchBallSemiAngle
  BEQ ManageBallSemiAngleNoMovement      ; Switch = 0 => no movement

  LDA #$0
  STA switchBallSemiAngle
  JSR UpDownMovement                     ; Switch = 1 => movement
  RTS

ManageBallSemiAngleNoMovement:
  LDA #$1
  STA switchBallSemiAngle
  RTS

UpDownMovement:
  ; Up/Down movement
  LDA SPR_BALL_ADDR+0        ; load data from address (sprites + x)
  CLC
  ADC balldown
  SEC
  SBC ballup
  STA SPR_BALL_ADDR+0          ; store into RAM address ($0200 + x)

  RTS

CheckBallCollisionBrick:
  ;;; Vérifier que la balle touche une brique
  ;;; 4 possibilités : la balle touche le bas, le haut ou les côtés de la brique

  ;;; Pour des raisons de simplicités, on ne traite (pour l'instant) que la coordonnée gauche/haut

  LDA SPR_BALL_ADDR+3
  STA ballposxleft
  ADC #TILE_SIZE
  STA ballposxright

  LDA SPR_BALL_ADDR
  STA ballposytop
  ADC #TILE_SIZE
  STA ballposybottom

  ; Look for tile at ballposxleft x ballposytop
  LDA ballposxleft
  LSR A                ; Axis to be divided by 8 since a tile is 8x8
  LSR A
  LSR A
  STA currenttileposx

  LDA ballposytop
  LSR A                ; Axis to be divided by 8 since a tile is 8x8
  LSR A
  LSR A
  STA currenttileposy


  ; Look for tile at ballposxright x ballposytop - NON TRAITÉ POUR L'INSTANT

  ; Look for tile at ballposxleft x ballposybottom - NON TRAITÉ POUR L'INSTANT

  ; Look for tile at ballposxright x ballposybottom - NON TRAITÉ POUR L'INSTANT



  ; Is there a brick at this tile?
CheckIfBrickInTile:
  ; Look for the right bit inside our octet
  LDA currenttileposx
  AND #7              ; (x modulo 8)
  TAX                 ; Tranfert de A vers X
  LDA bits,x          ; et on convertit ça en un bit, pour pouvoir tester facilement
  STA current_mask    ; current_mask contient alors %01000000 ou %00010000 par exemple.

  ; Look for the right octet of the brick table
  ; There are 32 tiles per lines, shaped in 4 octets in our table, so we need to divide by 8
  LDA currenttileposx
  LSR A
  LSR A
  LSR A
  STA tmpvar
  ; Y told us which line, we will multiply by 4 (4 octets (=32 bits) per line)
  LDA currenttileposy  ; Et en multipliant Y par 4
  ASL A
  ASL A
  CLC
  ADC tmpvar         ; tmpvar = (X / 8) + (Y * 4)
  TAX

  ; Get the value of the right bit in the right octet!
  LDA bricks,x
  AND current_mask    ; et on test s'il y a un 1 ou pas à cette position.
  BNE BallCollisionWithBrick ; Si != de 0 alors il s'agit d'une brique
  RTS                 ;  et on a terminé de traiter tout ça.

BallCollisionWithBrick:
  ; Remplacer le 1 par un 0 dans la table des briques en RAM
  LDA current_mask    ; On inverse le mask
  EOR #$ff            ;  pour avoir des 1 partout sauf à l'emplacement de la pilule
  STA current_mask
  LDA bricks,x         ; Et on utilise cette valeur pour
  AND current_mask    ;  n'effacer éventuellement que ce bit.
  STA bricks,x

  ; Décrémentation du nombres de briques dans le compteur pour la fin du niveau
  DEC nbBricksLeft
  CLC
  ; Si nb de briques = 0 alors niveau terminé
  ;BEQ LevelFinished

  LDA scoreOnes
  BEQ DecrementTens
  BNE DecrementOnes

DecrementTens:
  DEC scoreTens
  LDA #10       ; Anticipate DecrementOnes that follows
  STA scoreOnes
DecrementOnes:
  DEC scoreOnes

  ; Comptage de points

  ; Suppression de la brique (remplacement par une tuile noire)
  ; Calculate the ID of the tile and add it to $2000 - `$2000 + (y * 32) + x`
  LDA currenttileposy  ; On commence par déterminer si on
  CLC                 ;
  LSR A                ; Diviser la position par 8
  LSR A                ;  en divisant 3 fois par 2
  LSR A                ; pour avoir l'octet de poids fort de l'adresse
  CLC                 ; (les lignes font 32 octets et 32*8 = 256)
  ADC #$20            ; Ajout de la base, l'adresse commencera alors par $20.. $21.., $22.. ou $23..
  STA currenttileaddress

  ; Calcul de l'octet de poids faible de la position de la pilule à effacer
  LDA currenttileposy
  ASL A                 ; Et on multiplie par 32
  ASL A                 ; en multipliant
  ASL A                 ;  5 fois de suite par 2
  ASL A
  ASL A
  CLC
  ADC currenttileposx  ; avant d'ajouter la position de Pacman en X
  STA currenttileaddress + 1

  ; Gestion du rebondissement de la balle contre la brique
  LDA ballup
  CMP #1
  BEQ BallCollisionCeiling
  BNE BallCollisionBottom

CheckBallCollisionCeiling:
  LDA SPR_BALL_ADDR
  CMP #WALL_LIMIT_TOP
  BEQ BallCollisionCeiling
  RTS

BallCollisionCeiling:  ; change the direction top/down of the ball
  LDA #$0
  STA ballup
  LDA #$1
  STA balldown
  RTS

CheckBallCollisionBottom:
  LDA SPR_BALL_ADDR
  CMP #WALL_LIMIT_BOTTOM
  BEQ BallOutOfBounds
  RTS

BallOutOfBounds: ; The player should loose a life, for now we just move the ball
  LDA #$10
  STA SPR_BALL_ADDR
  LDA #$20
  STA SPR_BALL_ADDR+3

BallCollisionBottom:  ; change the direction top/down of the ball
  LDA #$1
  STA ballup
  LDA #$0
  STA balldown
  RTS

CheckBallCollisionStick:
  ;;; Vérifier que la balle, au moment où elle touche la limite basse,
  ;;; se trouve entre la partie gauche et droite du baton
  LDA SPR_BALL_ADDR
  CMP #STICK_LIMIT_BOTTOM
  BNE CheckBallCollisionCeiling   ; If bottom limit is not reached => nothing to do

  LDA SPR_BALL_ADDR+3
  CMP SPR_STICK_ADDR+3
  BMI CheckBallCollisionCeiling   ; If ball is over the left limit of the stick => nothing to do

  LDA SPR_STICK_ADDR+3
  ADC #SPR_STICK_SIZE
  CMP SPR_BALL_ADDR+3
  BMI CheckBallCollisionCeiling   ; If ball is over the right limit of the stick => nothing to do

  ; Collision ball & stick, ball movement from down to up
  LDA #$1
  STA ballup
  LDA #$0
  STA balldown
  STA isBallSemiAngle

  ; Collision ball & stick, check stick position to define ball angle
  LDA SPR_STICK_ADDR+3
  ADC #8                  ; Left part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallSemiAngleLeft

  LDA SPR_STICK_ADDR+3
  ADC #24                 ; Middle part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallSemiAngleMiddle

  LDA SPR_STICK_ADDR+3
  ADC #32                 ; Right part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallSemiAngleRight

BallSemiAngleLeft:
  LDA #$1
  STA isBallSemiAngle
  STA ballleft
  LDA #$0
  STA ballright
  RTS

BallSemiAngleMiddle:
  ; Nothing to do
  RTS

BallSemiAngleRight:
  LDA #$1
  STA isBallSemiAngle
  STA ballright
  LDA #$0
  STA ballleft
  RTS

CheckBallCollisionLeftWall:
  LDA SPR_BALL_ADDR+3
  CMP #WALL_LIMIT_LEFT
  BEQ BallCollisionLeftWall
  RTS

BallCollisionLeftWall:  ; change the direction left/right of the ball
  LDA #$0
  STA ballleft
  LDA #$1
  STA ballright
  RTS

CheckBallCollisionRightWall:
  LDA SPR_BALL_ADDR+3
  CMP #WALL_LIMIT_RIGHT
  BEQ BallCollisionRightWall
  RTS

BallCollisionRightWall:  ; change the direction right/left of the ball
  LDA #$1
  STA ballleft
  LDA #$0
  STA ballright
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
  .incbin "arka.chr"   ;includes 8KB graphics file
