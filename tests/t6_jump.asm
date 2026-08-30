// Jump instructions (JAL, JALR)
ADDI x1, x0, 20
JAL  x2, MID
ADDI x3, x0, 999
MID: ADDI x4, x0, 111
JALR x5, x1, 0
