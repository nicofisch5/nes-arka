; Erase brick if necessary, replace by a black tile
  ; Add a condition if(there is a brick to erase)
  LDA currenttileaddress  ;
  STA PPUADDR             ; write the high byte of the tile address
  LDA currenttileaddress+1
  STA PPUADDR             ; write the low byte of the tile address
  LDA #$ff                  ; tile ID
  STA PPUDATA
