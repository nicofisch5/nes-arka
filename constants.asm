; PPU registers addresses
PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
OAMADDR   = $2003
OAMDATA   = $2004
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007

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
WALL_LIMIT_RIGHT      = $F6
WALL_LIMIT_TOP        = $04
WALL_LIMIT_BOTTOM     = $CD
SPR_BALL_ADDR         = $214
TILE_SIZE             = $08

; For bricks
NB_BRICKS_IN_LEVEL    = 25
