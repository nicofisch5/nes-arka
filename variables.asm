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

;currenttileposx  .rs 1
;currenttileposy  .rs 1

;curAdjTile1PosX  .rs 1
;curAdjTile1PosY  .rs 1
;curAdjTile2PosX  .rs 1
;curAdjTile2PosY  .rs 1
;curAdjTile3PosX  .rs 1
;curAdjTile3PosY  .rs 1
;curAdjTile4PosX  .rs 1
;curAdjTile4PosY  .rs 1

;exAdjTile1PosX  .rs 1
;exAdjTile1PosY  .rs 1
;exAdjTile2PosX  .rs 1
;exAdjTile2PosY  .rs 1
;exAdjTile3PosX  .rs 1
;exAdjTile3PosY  .rs 1
;exAdjTile4PosX  .rs 1
;exAdjTile4PosY  .rs 1

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

bricks .rs 4 * 31 ; Copie en RAM des positions des briques (champ de bits)
tmpvar .rs 2
current_mask .rs 1

gamestate   .rs 1
pointerLo	  .rs 1
pointerHi	  .rs 1
