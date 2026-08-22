loop:
    ADDI x1, x1, 1
    ADDI x2, x0, 10
    BNE x1, x2, loop
    JAL x0, end
end:
    ADD x0, x0, x0