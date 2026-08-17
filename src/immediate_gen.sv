module immediate_gen(
    input logic [31:0] instructions, 
    output logic [31:0] immediate
);

assign immediate = {{20{instructions[31]}}, instructions[31:20]}; 

endmodule