module immediate_gen(
    input logic [31:0] instructions, 
    output logic [31:0] immediate
);

    assign immediate =
        //Branching instructions
        (instructions[6:0] == 7'b1100011)
        ? {{19{instructions[31]}}, instructions[31], instructions[7], instructions[30:25], 
        instructions[11:8], 1'b0}
        //Store instruction
        : (instructions[6:0] == 7'b0100011)
        ? {{20{instructions[31]}}, instructions[31:25], instructions[11:7]}
        //Load, R-type, I-type instructions
        : {{20{instructions[31]}}, instructions[31:20]};
endmodule