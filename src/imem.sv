module imem(
    input logic [31:0] address, 
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255]; //256 instructions
    
    initial begin
        $readmemh("sim/prog.hex", memory); 
    end

    always_comb begin 
        instruction = memory[address>>2]; //address shift right 2
    end
endmodule