module imem(
    input logic [31:0] address, 
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255]; //256 instructions
    
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) memory[i] = 32'h00000013;
        $readmemh("sim/prog.hex", memory); 
    end

    always_comb begin 
        instruction = memory[address>>2]; //address shift right 2
    end
endmodule