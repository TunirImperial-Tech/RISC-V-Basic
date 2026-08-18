module imem(
    input logic [31:0] address, 
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255]; //256 instructions

 initial begin
        // ADDI x1, x0, 10
        memory[0] = 32'h00A00093;

        // ADDI x2, x0, 20
        memory[1] = 32'h01400113;

        // ADD x3, x1, x2
        memory[2] = 32'h002081B3;

        // SUB x4, x3, x1
        memory[3] = 32'h40118233;

        // AND x5, x1, x2
        memory[4] = 32'h0020F2B3;

        // OR x6, x1, x2
        memory[5] = 32'h0020E333;

        // XOR x7, x1, x2
        memory[6] = 32'h0020C3B3;

        // NOPs
        memory[7] = 32'h00000013;
        memory[8] = 32'h00000013;
        memory[9] = 32'h00000013;
    end

    always_comb begin 
        instruction = memory[address>>2]; //address shift right 2
    end
endmodule