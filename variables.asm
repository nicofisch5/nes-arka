  .rsset $0000  ;;start variables at ram location 0

joypad1    .rs 1  ; player 1 gamepad buttons, one bit per button

ballup     .rs 1  ; 1 = ball moving up
balldown   .rs 1  ; 1 = ball moving down
ballright  .rs 1  ; 1 = ball moving right
ballleft   .rs 1  ; 1 = ball moving left
ballSpeed  .rs 1
ballposxleft    .rs 1  ;
ballposxright   .rs 1  ;
ballposytop     .rs 1  ;
ballposybottom  .rs 1  ;

isBallSemiAngle       .rs 1  ;
switchBallSemiAngle   .rs 1  ;

curAdjTilePosX  .rs 4
curAdjTilePosY  .rs 4
exAdjTilePosX  .rs 4
exAdjTilePosY  .rs 4
curAdjTileIndex .rs 1

currenttileaddress .rs 2      ; Adresse dans la mémoire du PPU de la tuile courant

nbBricksLeft  .rs 1
scoreOnes     .rs 1
scoreTens     .rs 1
nbLife        .rs 1

level         .rs 1

bricks .rs 4 * 31 ; Copie en RAM des positions des briques (champ de bits)
tmpvar .rs 2
current_mask .rs 1

gamestate   .rs 1
pointerLo	  .rs 1
pointerHi	  .rs 1

pointerLoMask	  .rs 1
pointerHiMask	  .rs 1
bricksMask      .rs 1
