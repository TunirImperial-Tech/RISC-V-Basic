module decoder(
    input logic [31:0] instructions, //Recieved 32-bit instruction

    output logic [3:0] alu_control, //4-bit alu operation

    output logic       reg_write, 
    output logic       alu_src, //1-bit used to decide second instruction
    output logic       mem_read, 
    output logic       mem_write,
    output logic       mem_to_reg, 
    output logic       branch, 
    output logic       jump
);

logic [6:0] opcode; 
logic [2:0] funct3;
logic [6:0] funct7; 

assign opcode = instructions[6:0];
assign funct3 = instructions[14:12];
assign funct7 = instructions[31:25]; 

always_comb begin

    alu_control = ALU_ADD; 
    reg_write   = 1'b0;
    alu_src     = 1'b0;
    mem_read    = 1'b0;
    mem_write   = 1'b0;
    mem_to_reg  = 1'b0;
    branch      = 1'b0;
    jump        = 1'b0;

    case(opcode)
        7'b0110011: begin
            case (funct3)
                3'b000 begin

                if (funct7 == 7'b0000000)
                    alu_control = ALU_ADD;

                else if (funct7 == 7'b0100000)
                    alu_control = ALU_SUB;
                    
                end
            endcase
            reg_write = 1'b1;
        end
    endcase
end
endmodule
