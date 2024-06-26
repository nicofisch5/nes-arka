; Move the ball and check for collisions
CheckBallCollisionBrick:
  ;;; Vérifier que la balle touche une brique
  ;;; 4 possibilités : la balle touche le bas, le haut ou les côtés de la brique
  ;;; Pour des raisons de simplicités, on ne traite (pour l'instant) que la coordonnée gauche/haut

  ExTilesPositions:
    LDX #$00
    ExTilesPositionsLoop:
      LDA curAdjTilePosX,x
      STA exAdjTilePosX,x
      LDA curAdjTilePosY,x
      STA exAdjTilePosY,x
    EndExTilesPositionsLoop:
    INX
    CPX #$04
    BNE ExTilesPositionsLoop
  EndExTilesPositions:

  GetBallTilesPosition:
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
    STA curAdjTilePosX+0
    STA curAdjTilePosX+3

    LDA ballposxright
    LSR A                ; Axis to be divided by 8 since a tile is 8x8
    LSR A
    LSR A
    STA curAdjTilePosX+1
    STA curAdjTilePosX+2

    LDA ballposytop
    LSR A                ; Axis to be divided by 8 since a tile is 8x8
    LSR A
    LSR A
    STA curAdjTilePosY+0
    STA curAdjTilePosY+1

    LDA ballposybottom
    LSR A                ; Axis to be divided by 8 since a tile is 8x8
    LSR A
    LSR A
    STA curAdjTilePosY+2
    STA curAdjTilePosY+3

  EndGetBallTilesPosition:

  ; Is there a brick at one of the 4 adjacent tiles of the ball?
  CheckIfBrickInTiles:
    LDY #$00

    CheckIfBrickInTilesLoop:
      STY curAdjTileIndex

      ; Look for the right bit inside our octet
      LDA curAdjTilePosX,y    ; We store the current tile with the brick for later
      AND #7              ; (x modulo 8)
      TAX                 ; Tranfert de A vers X
      LDA bits,x          ; et on convertit ça en un bit, pour pouvoir tester facilement
      STA current_mask    ; current_mask contient alors %01000000 ou %00010000 par exemple.

      ; Look for the right octet of the brick table
      ; There are 32 tiles per lines, shaped in 4 octets in our table, so we need to divide by 8
      LDA curAdjTilePosX,y
      LSR A
      LSR A
      LSR A
      STA tmpvar
      ; PosY told us which line, we will multiply by 4 (4 octets (=32 bits) per line)
      LDA curAdjTilePosY,y  ; Et en multipliant Y par 4
      ASL A
      ASL A
      CLC
      ADC tmpvar         ; tmpvar = (X / 8) + (Y * 4)
      TAX

      ; Get the value of the right bit in the right octet!
      LDA bricks,x
      AND current_mask    ; et on test s'il y a un 1 ou pas à cette position.
      BNE BallCollisionWithBrick ; Si != de 0 alors il s'agit d'une brique
    EndCheckIfBrickInTilesLoop:

    INY
    CPY #$04
    BNE CheckIfBrickInTilesLoop

    JMP EndCheckBallCollisionBrick  ; If arrived here, there is no brick in adjacent tiles
  EndCheckIfBrickInTiles:


 ; There is a brick in a tile, therefore collision between Ball and Brick
  BallCollisionWithBrick:
    ; Need to replace 1 by 0 in the bricks table in RAM
    LDA current_mask    ;
    EOR #$ff            ; Mask reverse to have 1 everywhere except for the place of the brick
    STA current_mask
    LDA bricks,x
    AND current_mask    ; Use the mask to erase this bit
    STA bricks,x
  EndBallCollisionWithBrick:

  ; Find current tile address to erase
  PrepareEraseBrickFromBg:
    LDY curAdjTileIndex

    ; Calculate the ID of the tile and add it to $2000 => `$2000 + (y * 32) + x`
    ; First part for high weight
    LDA curAdjTilePosY,y ; We know the coordinates of the brick tile
    CLC                 ;
    LSR A               ; Divide by 8 (divide 3 times by 2)
    LSR A
    LSR A               ; to have the high weight of the adress octet
    CLC
    ADC #$20            ; Add this to the base, address will start at $20.. $21.., $22.. or $23..
    STA currenttileaddress

    ; Second part for low weight
    LDA curAdjTilePosY,y
    ASL A                 ; Multiply by 32 (multiply 5 times by 2)
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC curAdjTilePosX,y  ; add left position
    STA currenttileaddress + 1
  EndPrepareEraseBrickFromBg:

  DecrementScore:
    DEC nbBricksLeft    ; Minus one
    CLC

    ; If nb bricks = 0 then end of level
    LDA nbBricksLeft
    CMP #$0
    BEQ PrepareEndLevel

    LDA scoreOnes
    BEQ DecrementTens
    BNE DecrementOnes

    DecrementTens:
      DEC scoreTens
      LDA #10       ; Anticipate DecrementOnes that follows
      STA scoreOnes
    DecrementOnes:
      DEC scoreOnes

    JMP BounceBallWithBrick

  EndDecrementScore:

  PrepareEndLevel:
    LDA #GAMESTATE_ENDLEVEL
    STA gamestate

    LDA #%00000000 ; disable NMI
    STA $2000
    LDA #%00000000 ; disable rendering
    STA $2001

    LDA #LOW(BGEndLevel)
    STA pointerLo
    LDA #HIGH(BGEndLevel)
    STA pointerHi
    JSR LoadBG

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPUCTRL
    LDA #%00001010   ; disable sprites, enable background, no clipping on left side
    STA PPUMASK

  EndPrepareEndLevel:

  BounceBallWithBrick:
    ; Pour déterminer le rebondissement de la balle on vérifie sa provenance
    ; en comparant les anciennes tuiles où la ballse était présentes avec les tuiles actuelles
    CLC
    LDX #$00
    LDA exAdjTilePosX,x
    INX
    ADC exAdjTilePosX,x
    INX
    ADC exAdjTilePosX,x
    INX
    ADC exAdjTilePosX,x
    STA tmpvar

    CLC
    LDX #$00
    LDA curAdjTilePosX,x
    INX
    ADC curAdjTilePosX,x
    INX
    ADC curAdjTilePosX,x
    INX
    ADC curAdjTilePosX,x

    CMP tmpvar
    BEQ BallComeFromTheTopOrBottom
    JMP BallComeFromTheRightOrLeft

  EndBounceBallWithBrick:

  BallComeFromTheTopOrBottom:
    LDA ballup
    STA tmpvar
    LDA balldown
    STA ballup
    LDA tmpvar
    STA balldown

    JMP EndCheckBallCollisionBrick

  EndBallComeFromTheTopOrBottom:

  BallComeFromTheRightOrLeft:
    LDA ballleft
    STA tmpvar
    LDA ballright
    STA ballleft
    LDA tmpvar
    STA ballright

    JMP EndCheckBallCollisionBrick
  EndBallComeFromTheLeft:

EndCheckBallCollisionBrick:
  RTS
