// Remaining conditional branches: BLT, BGE
ADDI x1, x0, 3
ADDI x2, x0, 8
BLT  x1, x2, LESS
ADDI x3, x0, 999
LESS: ADDI x4, x0, 111
ADDI x1, x0, 8
ADDI x2, x0, 3
BGE  x1, x2, GEQ
ADDI x6, x0, 999
GEQ: ADDI x7, x0, 222
