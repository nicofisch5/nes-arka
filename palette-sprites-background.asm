palette:
  .db $0F,$1C,$2B,$39,  $0F,$36,$17,$22,  $0F,$1C,$15,$14,  $0F,$27,$17,$22   ;;background palette
  .db $0F,$1C,$2B,$39,  $0F,$02,$38,$3C,  $0F,$1C,$15,$14,  $0F,$02,$38,$3C   ;;sprite palette

sprites:
  ;   vert tile attr       horiz
  .db $D4, $00, %00000000, $70   ;stick left
  .db $D4, $01, %00000000, $79   ;stick middle
  .db $D4, $01, %00000000, $82   ;stick middle
  .db $D4, $01, %00000000, $8B   ;stick middle
  .db $D4, $00, %01000000, $94   ;stick right
  .db $00, $02, %00000000, $00   ;ball
  ;There are 4 bytes per sprite, each on one line.

  ;Sprite Attributes
  ;76543210
  ;|||   ||
  ;|||   ++- Color Palette of sprite
  ;|||
  ;||+------ Priority (0: in front of background; 1: behind background)
  ;|+------- Flip sprite horizontally
  ;+-------- Flip sprite vertically

background:
  .db $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  ;;row 1
  .db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00  ;;row 1

attribute:
  .db %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %10101010
