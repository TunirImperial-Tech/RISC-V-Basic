`ifndef INSTRUCTION_SET_SVH
`define INSTRUCTION_SET_SVH
    
localparam logic [6:0] R_TYPE = 7'b0110011; 
localparam logic [6:0] I_TYPE = 7'b0010011;

// funct3 values
localparam logic [2:0] FUNCT3_ADD = 3'b000;
localparam logic [2:0] FUNCT3_XOR = 3'b100;
localparam logic [2:0] FUNCT3_OR  = 3'b110;
localparam logic [2:0] FUNCT3_AND = 3'b111;

// funct7 values
localparam logic [6:0] FUNCT7_ADD = 7'b0000000;
localparam logic [6:0] FUNCT7_SUB = 7'b0100000;

//Operation Identifiers
localparam logic [3:0] OP_ADD = 4'b0000;
localparam logic [3:0] OP_SUB = 4'b0001;
localparam logic [3:0] OP_AND = 4'b0010;
localparam logic [3:0] OP_OR  = 4'b0011;
localparam logic [3:0] OP_XOR = 4'b0100;

//Function to encode an R-Type instruction
function automatic [31:0] encode_r_type(
    input logic [3:0] op,
    input logic [4:0] rd,
    input logic [4:0] rs1,
    input logic [4:0] rs2
);

    logic [6:0] funct7;
    logic [2:0] funct3;

    begin
        //Default values
        funct7 = FUNCT7_ADD;
        funct3 = FUNCT3_ADD;

        case(op)
            OP_ADD: begin
                funct7 = FUNCT7_ADD;
                funct3 = FUNCT3_ADD;
            end
            OP_SUB: begin
                funct7 = FUNCT7_SUB;
                funct3 = FUNCT3_ADD;
            end
            OP_AND: begin
                funct7 = FUNCT7_ADD;
                funct3 = FUNCT3_AND;
            end
            OP_OR: begin
                funct7 = FUNCT7_ADD;
                funct3 = FUNCT3_OR;
            end
            OP_XOR: begin
                funct7 = FUNCT7_ADD;
                funct3 = FUNCT3_XOR;
            end
        endcase

        encode_r_type = {
            funct7, rs2, rs1, funct3, rd, R_TYPE
        }; 
    end
endfunction

// Function to encode an I-Type instruction
function automatic [31:0] encode_i_type(
    input logic [3:0] op,
    input logic [4:0] rd,
    input logic [4:0] rs1,
    input logic [11:0] immediate
);
    logic [2:0] funct3; 

    begin
        funct3 = FUNCT3_ADD; 

        case(op)
            OP_ADD: funct3 = FUNCT3_ADD; 
            OP_AND: funct3 = FUNCT3_AND;
            OP_OR:  funct3 = FUNCT3_OR; 
            OP_XOR: funct3 = FUNCT3_XOR; 

        endcase
        encode_i_type = {immediate, rs1, funct3, rd, I_TYPE}; 
    end
endfunction
`endif