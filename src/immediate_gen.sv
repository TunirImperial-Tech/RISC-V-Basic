module immediate_gen(
    input logic [31:0] instructions, 
    output logic [31:0] immediate
);

    assign immediate =
        //U-Type instructions
        (instructions[6:0] == 7'b0110111 || instructions[6:0] == 7'b0010111)
        ?{instructions[31:12], 12'b0}
        //JAL instructions
        : (instructions[6:0] == 7'b1101111)
        ?{{11{instructions[31]}}, instructions[31], instructions[19:12], 
        instructions[20], instructions[30:21],1'b0}
        //Branching instructions
        : (instructions[6:0] == 7'b1100011)
        ? {{19{instructions[31]}}, instructions[31], instructions[7], instructions[30:25], 
        instructions[11:8], 1'b0}
        //Store instruction
        : (instructions[6:0] == 7'b0100011)
        ? {{20{instructions[31]}}, instructions[31:25], instructions[11:7]}
        //Load, R-type, I-type instructions, JALR
        : {{20{instructions[31]}}, instructions[31:20]};
endmodule