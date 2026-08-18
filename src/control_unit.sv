module control_unit(
    input logic [31:0] instructions, //Recieved 32-bit instruction

    output logic [3:0] alu_control, //4-bit alu operation

    output logic       reg_write, 
    output logic       alu_src, //1-bit used to decide second instruction source
    output logic       mem_read, 
    output logic       mem_write,
    output logic       mem_to_reg, 
    output logic       branch, 
    output logic       jump
);

localparam logic [3:0] ALU_ADD = 4'b0000;
localparam logic [3:0] ALU_SUB = 4'b0001;
localparam logic [3:0] ALU_AND = 4'b0010;
localparam logic [3:0] ALU_OR  = 4'b0011;
localparam logic [3:0] ALU_XOR = 4'b0100;
localparam logic [3:0] ALU_SLT = 4'b0101; 

localparam logic [6:0] R_TYPE = 7'b0110011;
localparam logic [6:0] I_TYPE = 7'b0010011;
localparam logic [6:0] LOAD   = 7'b0000011;
localparam logic [6:0] STORE  = 7'b0100011;
localparam logic [6:0] BRANCH = 7'b1100011; 

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
        R_TYPE: begin
            case (funct3)
                3'b000: begin

                if (funct7 == 7'b0000000)
                    alu_control = ALU_ADD;

                else if (funct7 == 7'b0100000)
                    alu_control = ALU_SUB;
                    
                end

                3'b100: alu_control = ALU_XOR;
                3'b110: alu_control = ALU_OR;
                3'b111: alu_control = ALU_AND;

                default: begin
                    alu_control = ALU_ADD; 
                end
            endcase
            reg_write = 1'b1;
        end

        I_TYPE: begin
            case(funct3)
                3'b000: alu_control = ALU_ADD; // ADDI
                3'b111: alu_control = ALU_AND; // ANDI
                3'b110: alu_control = ALU_OR;  // ORI
                3'b100: alu_control = ALU_XOR; // XORI

                default: alu_control = ALU_ADD; 
            endcase
            reg_write = 1'b1; 
            alu_src = 1'b1; 
        end

        LOAD : begin
            if (funct3 == 3'b010) begin
                alu_control = ALU_ADD;
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                mem_read    = 1'b1;
                mem_to_reg  = 1'b1;
            end
        end

        STORE: begin
            if (funct3 == 3'b010) begin
                alu_control = ALU_ADD;
                alu_src     = 1'b1;
                mem_write   = 1'b1;
            end
        end

        BRANCH: begin
            branch = 1'b1; 
            reg_write = 1'b0; 
            alu_src = 1'b0; 
            if (funct3 == 3'b000) alu_control = ALU_SUB; //BEQ

            if (funct3 == 3'b001) alu_control = ALU_SUB; //BNE

            if (funct3 == 3'b100) alu_control = ALU_SLT; //BLT

            if (funct3 == 3'b101) alu_control = ALU_SLT; //BGE
        end
    endcase
end
endmodule