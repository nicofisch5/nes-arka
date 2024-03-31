; ************** iNES HEADERS ****************
  include "_ines-header.asm"


; ************** VARIABLES ****************
  .rsset $0000  ;;start variables at ram location 0

joypad1    .rs 1  ; player 1 gamepad buttons, one bit per button
ballup     .rs 1  ; 1 = ball moving up
balldown   .rs 1  ; 1 = ball moving down
ballright  .rs 1  ; 1 = ball moving right
ballleft   .rs 1  ; 1 = ball moving left
ballposxleft    .rs 1  ;
ballposxright   .rs 1  ;
ballposytop     .rs 1  ;
ballposybottom  .rs 1  ;
currenttileposx  .rs 1  ;
currenttileposy  .rs 1  ;
currenttileaddress .rs 2      ; Adresse dans la mémoire du PPU de la tuile courant

nbBricksLeft  .rs 1
scoreOnes     .rs 1
scoreTens     .rs 1

bricks .rs 4 * 31 ; Copie en RAM des positions des briques (champ de bits)
tmpvar .rs 2
current_mask .rs 1

; ************** CONSTANTS ****************
  include "constants.asm"


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

;Init ball
  LDA #$01
  STA ballup
  STA ballright
  LDA #$00
  STA balldown
  STA ballleft

;Set initial score value
  LDA #NB_BRICKS_IN_LEVEL_ONES
  STA scoreOnes
  LDA #NB_BRICKS_IN_LEVEL_TENS
  STA scoreTens

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


LoadBackground:
  LDA PPUSTATUS         ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR           ; write the high byte of $2000 address
  LDA #$00
  STA PPUADDR           ; write the low byte of $2000 address

  ; On veut copier 30 lignes de 32 colonnes
  ; Soit 960 octets = 3 * 256 + 192
  LDX #0      ; Copie des 256

LoopBackground1
  LDA background,x  ;  premiers octets
  STA PPUDATA ;   depuis "murs"
  INX         ; Après 256 incrémentations...
  BNE LoopBackground1       ;  X revient à 0

LoopBackground2
  LDA background+256,x ; Copie des 256
  STA PPUDATA    ;   octets suivants
  INX
  BNE LoopBackground2

LoopBackground3
  LDA background+512,x ; Puis encore 256 octets
  STA PPUDATA
  INX
  BNE LoopBackground3

LoopBackground4
  LDA background+768,x ; Et Finalement les 192 derniers
  STA PPUDATA
  INX
  CPX #192
  BNE LoopBackground4

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

; Draw score
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$21
  STA $2006          ; start drawing the score at PPU $2020

  ;STA $2007          ; draw to background
  LDA scoreTens      ; next digit
  CLC
  ADC #$10           ; Get the right tiles (number starts at $10 in arka.chr)
  STA $2007
  LDA scoreOnes      ; last digit
  CLC
  ADC #$10
  STA $2007


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
  LDA SPR_STICK_ADDR+3       ; load sprite X position
  CMP #(WALL_LIMIT_RIGHT-SPR_STICK_SIZE)    ; the stick is large, we check the wall with le right border by adding its size
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
  CPX #$05        ; loop 5 time because stick is 5 sprites to move
  BNE MoveStickRightLoop
  RTS

CollisionRightWall
  ; no code, just no move for the stick

; Move the ball and check for collisions
UpdateBallPosition:
  JSR CheckBallCollisionBrick
  JSR CheckBallCollisionStick
  JSR CheckBallCollisionCeiling
  JSR CheckBallCollisionLeftWall
  JSR CheckBallCollisionRightWall
  JSR CheckBallCollisionBottom

  LDA SPR_BALL_ADDR+3        ; load data from address (sprites + x)
  CLC
  ADC ballright
  SEC
  SBC ballleft
  STA SPR_BALL_ADDR+3          ; store into RAM address ($0200 + x)

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

CheckBallCollisionStick:
  ;;; Vérifier que la balle, au moment où elle touche la limite basse,
  ;;; se trouve entre la partie gauche et droite du baton
  LDA SPR_BALL_ADDR
  CMP #STICK_LIMIT_BOTTOM
  BNE CheckBallCollisionCeiling

  LDA SPR_BALL_ADDR+3
  CMP SPR_STICK_ADDR+3
  BMI CheckBallCollisionCeiling

  LDA SPR_STICK_ADDR+3
  ADC #SPR_STICK_SIZE
  CMP SPR_BALL_ADDR+3
  BMI CheckBallCollisionCeiling

  LDA #$1
  STA ballup
  LDA #$0
  STA balldown
  RTS

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
  .incbin "arka.chr"   ;includes 8KB graphics file from SMB1
