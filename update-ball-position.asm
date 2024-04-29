; Move the ball and check for collisions
UpdateBallPosition:

CheckBallCollisionCeiling:
  LDA SPR_BALL_ADDR
  CMP #WALL_LIMIT_TOP
  BEQ BallCollisionCeiling
  JMP EndCheckBallCollisionCeiling

  BallCollisionCeiling:  ; change the direction top/down of the ball
    LDA #$0
    STA ballup
    LDA #$1
    STA balldown
    JMP EndCheckBallCollisionCeiling

EndCheckBallCollisionCeiling:




CheckBallCollisionLeftWall:
  LDA SPR_BALL_ADDR+3
  CMP #WALL_LIMIT_LEFT
  BEQ BallCollisionLeftWall
  JMP EndCheckBallCollisionLeftWall

  BallCollisionLeftWall:  ; change the direction left/right of the ball
    LDA #$0
    STA ballleft
    LDA #$1
    STA ballright
    JMP EndCheckBallCollisionLeftWall

EndCheckBallCollisionLeftWall:




CheckBallCollisionRightWall:
  LDA SPR_BALL_ADDR+3
  CMP #WALL_LIMIT_RIGHT
  BEQ BallCollisionRightWall
  JMP EndCheckBallCollisionRightWall

  BallCollisionRightWall:  ; change the direction right/left of the ball
    LDA #$1
    STA ballleft
    LDA #$0
    STA ballright
    JMP EndCheckBallCollisionRightWall

EndCheckBallCollisionRightWall:




CheckBallCollisionStick:
  ;;; Vérifier que la balle, au moment où elle touche la limite basse,
  ;;; se trouve entre la partie gauche et droite du baton
  LDA SPR_BALL_ADDR
  CMP #STICK_LIMIT_BOTTOM
  BEQ CheckBallLeftCollisionStk   ; If bottom limit is not reached => nothing to do
  JMP EndCheckBallCollisionStick

  CheckBallLeftCollisionStk:
    LDA SPR_BALL_ADDR+3
    CMP SPR_STICK_ADDR+3
    BPL CheckBallRightCollisionStk
    JMP EndCheckBallCollisionStick   ; If ball is over the left limit of the stick => nothing to do
  EndCheckBallLeftCollisionStk:

  CheckBallRightCollisionStk:
    LDA SPR_STICK_ADDR+3
    ADC #SPR_STICK_SIZE
    CMP SPR_BALL_ADDR+3
    BPL BallCollisionStick
    JMP EndCheckBallCollisionStick   ; If ball is over the right limit of the stick => nothing to do
  EndCheckBallRightCollisionStk:

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
    JMP EndCheckBallCollisionStick

  BallNoAngleLeft:
    LDA #$1
    STA ballleft
    LDA #$0
    STA ballright
    JMP EndCheckBallCollisionStick

  BallNoAngleMiddle:
    ; Nothing to do
    JMP EndCheckBallCollisionStick

  BallNoAngleRight:
    LDA #$1
    STA ballright
    LDA #$0
    STA ballleft
    JMP EndCheckBallCollisionStick

  BallSemiAngleRight:
    LDA #$1
    STA isBallSemiAngle
    STA ballright
    LDA #$0
    STA ballleft
    JMP EndCheckBallCollisionStick

EndCheckBallCollisionStick:




CheckBallCollisionBottom:
  LDA SPR_BALL_ADDR
  CMP #WALL_LIMIT_BOTTOM
  BEQ BallOutOfBounds
  JMP EndCheckBallCollisionBottom

  BallOutOfBounds:
    DEC nbLife

    CheckEndOfLife:
      LDA nbLife
      CMP #$0
      BEQ PrepareGameOver
    EndCheckEndOfLife:

    ; <START> Partie à remplacer par le fait que la balle soit collée au stick comme au départ
    LDA #$CC
    STA SPR_BALL_ADDR
    LDA #$82
    STA SPR_BALL_ADDR+3

    ; Ball is stopped
    LDA #$00
    STA ballSpeed
    STA balldown
    STA ballleft
    STA ballright

    ; Stick in the middle
    LDA #$70
    STA SPR_STICK_ADDR+3
    LDA #$79
    STA SPR_STICK_ADDR+3+4
    LDA #$82
    STA SPR_STICK_ADDR+3+8
    LDA #$8B
    STA SPR_STICK_ADDR+3+12
    LDA #$94
    STA SPR_STICK_ADDR+3+16
    ; <END> Partie à remplacer par le fait que la balle soit collée au stick comme au départ

    JMP EndCheckBallCollisionBottom

  PrepareGameOver:
    LDA #GAMESTATE_GAMEOVER
    STA gamestate

    LDA #%00000000 ; disable NMI
    STA PPUCTRL
    LDA #%00000000 ; disable rendering
    STA PPUMASK

    LDA #LOW(BGGameOver)
    STA pointerLo
    LDA #HIGH(BGGameOver)
    STA pointerHi
    JSR LoadBG

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPUCTRL
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK

  EndPrepareGameOver:

  JMP EndCheckBallCollisionBottom

EndCheckBallCollisionBottom:




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
    JMP EndBallMovement

  UpDownMovement:
    ; Up/Down movement
    LDA SPR_BALL_ADDR+0        ; load data from address (sprites + x)
    CLC
    ADC balldown
    SEC
    SBC ballup
    STA SPR_BALL_ADDR+0          ; store into RAM address ($0200 + x)
    JMP EndBallMovement

EndBallMovement:

EndUpdateBallPosition:
  RTS
