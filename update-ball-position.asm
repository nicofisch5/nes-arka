; Move the ball and check for collisions
UpdateBallPosition:
  JSR CheckBallCollisionBrick
  JSR CheckBallCollisionCeiling
  JSR CheckBallCollisionLeftWall
  JSR CheckBallCollisionRightWall
  JSR CheckBallCollisionStick
  JSR CheckBallCollisionBottom
  JMP BallMovement

CheckBallCollisionBrick:
  ;;; Vérifier que la balle touche une brique
  ;;; 4 possibilités : la balle touche le bas, le haut ou les côtés de la brique
  ;;; Pour des raisons de simplicités, on ne traite (pour l'instant) que la coordonnée gauche/haut

GetBallTilePosition;
  ; Save coordinates in variables
  LDA SPR_BALL_ADDR+3
  STA ballposxleft
  ADC #TILE_SIZE
  STA ballposxright

  LDA SPR_BALL_ADDR
  STA ballposytop
  ADC #TILE_SIZE
  STA ballposybottom

  ; Look for tile position at ballposxleft x ballposytop
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

  ; TODO Look for tile at ballposxright x ballposytop - NON TRAITÉ POUR L'INSTANT
  ; TODO Look for tile at ballposxleft x ballposybottom - NON TRAITÉ POUR L'INSTANT
  ; TODO Look for tile at ballposxright x ballposybottom - NON TRAITÉ POUR L'INSTANT
EndGetBallTilePosition;

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
  JMP EndUpdateBallPosition  ; Si pas == 0 alors pas de brique, pas de collision, on a terminé de traiter tout ça.
EndCheckIfBrickInTile:

 ; There is a brick in the tile, therefore collision between Ball and Brick
BallCollisionWithBrick:
  ; Need to replace  1 by 0 in the bricks table in RAM
  LDA current_mask    ;
  EOR #$ff            ; Mask reverse to have 1 everywhere except for the place of the brick
  STA current_mask
  LDA bricks,x
  AND current_mask    ; Use the mask to erase this bit
  STA bricks,x
EndBallCollisionWithBrick:

 ; Find current tile address to erase
PrepareEraseBrickFromBg:
  ; Calculate the ID of the tile and add it to $2000 - `$2000 + (y * 32) + x`
  ; First part for high weight
  LDA currenttileposy ; We know the coordinates of the brick tile
  CLC                 ;
  LSR A               ; Divide by 8 (divide 3 times by 2)
  LSR A
  LSR A               ; to have the high weight of the adress octet
  CLC
  ADC #$20            ; Add this to the base, address will start at $20.. $21.., $22.. or $23..
  STA currenttileaddress

  ; Second part for low weight
  LDA currenttileposy
  ASL A                 ; Multiply by 32 (multiply 5 times by 2)
  ASL A
  ASL A
  ASL A
  ASL A
  CLC
  ADC currenttileposx  ; add left position
  STA currenttileaddress + 1
EndPrepareEraseBrickFromBg:

DecrementScore:
  DEC nbBricksLeft    ; Minus one
  CLC
  ; TODO If nb bricks = 0 then end of level
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

EndDecrementScore:

BounceBallWithBrick:
  ; Gestion du rebondissement de la balle contre la brique
  LDA ballup
  CMP #1
  BEQ BallCollisionCeiling
  BNE BallCollisionBottom
EndBounceBallWithBrick:

EndCheckBallCollisionBrick:


CheckBallCollisionCeiling:
  LDA SPR_BALL_ADDR
  CMP #WALL_LIMIT_TOP
  BEQ BallCollisionCeiling
  JMP EndUpdateBallPosition

BallCollisionCeiling:  ; change the direction top/down of the ball
  LDA #$0
  STA ballup
  LDA #$1
  STA balldown
  JMP EndUpdateBallPosition

CheckBallCollisionBottom:
  LDA SPR_BALL_ADDR
  CMP #WALL_LIMIT_BOTTOM
  BEQ BallOutOfBounds
  JMP EndUpdateBallPosition

BallOutOfBounds: ; The player should loose a life, for now we just move the ball
  LDA #$10
  STA SPR_BALL_ADDR
  LDA #$20
  STA SPR_BALL_ADDR+3
  JMP EndUpdateBallPosition

BallCollisionBottom:  ; change the direction top/down of the ball
  LDA #$1
  STA ballup
  LDA #$0
  STA balldown
  JMP EndUpdateBallPosition

CheckBallCollisionStick:
  ;;; Vérifier que la balle, au moment où elle touche la limite basse,
  ;;; se trouve entre la partie gauche et droite du baton
  LDA SPR_BALL_ADDR
  CMP #STICK_LIMIT_BOTTOM
  BEQ CheckBallLeftCollisionStk   ; If bottom limit is not reached => nothing to do
  JMP EndUpdateBallPosition

  CheckBallLeftCollisionStk:
    LDA SPR_BALL_ADDR+3
    CMP SPR_STICK_ADDR+3
    BPL CheckBallRightCollisionStk
    JMP EndUpdateBallPosition   ; If ball is over the left limit of the stick => nothing to do
  EndCheckBallLeftCollisionStk:

  CheckBallRightCollisionStk:
    LDA SPR_STICK_ADDR+3
    ADC #SPR_STICK_SIZE
    CMP SPR_BALL_ADDR+3
    BPL BallCollisionStick
    JMP EndUpdateBallPosition   ; If ball is over the right limit of the stick => nothing to do
  EndCheckBallRightCollisionStk:

EndCheckBallCollisionStick:

BallCollisionStick:
  ; Collision ball & stick, ball movement from down to up
  LDA #$1
  STA ballup
  LDA #$0
  STA balldown
  STA isBallSemiAngle   ; Ball angle is always put to 0 and can be change to 1 afterwards

  ; Collision ball & stick, check stick position to define ball angle
  LDA SPR_STICK_ADDR+3
  ADC #4                 ; Far left part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallSemiAngleLeft

  LDA SPR_STICK_ADDR+3
  ADC #10                 ; Left part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallNoAngleLeft

  LDA SPR_STICK_ADDR+3
  ADC #18                 ; Middle part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallNoAngleMiddle

  LDA SPR_STICK_ADDR+3
  ADC #26                 ; Right part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallNoAngleRight

  LDA SPR_STICK_ADDR+3
  ADC #32                 ; Far right part of the stick
  CMP SPR_BALL_ADDR+3
  BPL BallSemiAngleRight

BallSemiAngleLeft:
  LDA #$1
  STA isBallSemiAngle
  STA ballleft
  LDA #$0
  STA ballright
  JMP EndUpdateBallPosition

BallNoAngleLeft:
  LDA #$1
  STA ballleft
  LDA #$0
  STA ballright
  JMP EndUpdateBallPosition

BallNoAngleMiddle:
  ; Nothing to do
  JMP EndUpdateBallPosition

BallNoAngleRight:
  LDA #$1
  STA ballright
  LDA #$0
  STA ballleft
  JMP EndUpdateBallPosition

BallSemiAngleRight:
  LDA #$1
  STA isBallSemiAngle
  STA ballright
  LDA #$0
  STA ballleft
  JMP EndUpdateBallPosition

CheckBallCollisionLeftWall:
  LDA SPR_BALL_ADDR+3
  CMP #WALL_LIMIT_LEFT
  BEQ BallCollisionLeftWall
  JMP EndUpdateBallPosition

BallCollisionLeftWall:  ; change the direction left/right of the ball
  LDA #$0
  STA ballleft
  LDA #$1
  STA ballright
  JMP EndUpdateBallPosition

CheckBallCollisionRightWall:
  LDA SPR_BALL_ADDR+3
  CMP #WALL_LIMIT_RIGHT
  BEQ BallCollisionRightWall
  JMP EndUpdateBallPosition

BallCollisionRightWall:  ; change the direction right/left of the ball
  LDA #$1
  STA ballleft
  LDA #$0
  STA ballright
  JMP EndUpdateBallPosition


BallMovement:
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
  JMP UpDownMovement                     ; Switch = 1 => movement

ManageBallSemiAngleNoMovement:
  LDA #$1
  STA switchBallSemiAngle
  JMP EndUpdateBallPosition

UpDownMovement:
  ; Up/Down movement
  LDA SPR_BALL_ADDR+0        ; load data from address (sprites + x)
  CLC
  ADC balldown
  SEC
  SBC ballup
  STA SPR_BALL_ADDR+0          ; store into RAM address ($0200 + x)
  JMP EndUpdateBallPosition


EndUpdateBallPosition:
  RTS
