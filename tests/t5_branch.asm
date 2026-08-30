// Conditional branches
ADDI x1, x0, 5
ADDI x2, x0, 5
BEQ  x1, x2, EQUAL
ADDI x3, x0, 999
EQUAL: ADDI x4, x0, 111
ADDI x1, x0, 5
ADDI x2, x0, 6
BNE  x1, x2, NOTEQ
ADDI x6, x0, 999
NOTEQ: ADDI x7, x0, 222
