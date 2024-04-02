; NESASM arranges everything in 8KB code and 8KB graphics banks.
; To fill the 16KB PRG space 2 banks are needed 0 and 1
; NESASM needs these directives in order to know how many 8KB banks your ROM has

; .bank and .org control two completely different things
; .bank controls the location of the data in your output file (i.e. your ROM image)
; .org specifies the address range in which the 6502 is actually going to see that data.

  ; $C000 is often the address where the CPU starts executing instructions
  ; when the NES is powered on.

  ; Pour les cartouches (ROM - code et données, hors données graphiques) de 16 Ko,
  ; le code est tout à la fin de l'espace d'adressage du CPU, soit de $C000 à $FFFF
