  ; iNES Header
  ; The 16 byte iNES header gives the emulator all the information about the game
  ; including mapper, graphics mirroring, and PRG/CHR sizes

  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring
