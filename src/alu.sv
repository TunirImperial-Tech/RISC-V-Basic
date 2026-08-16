module alu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] alu_control,

    output logic [31:0] result
);

localparam logic [3:0] ALU_ADD = 4'b0000;
localparam logic [3:0] ALU_SUB = 4'b0001; 

always_comb begin
    case(alu_control)
        ALU_ADD: begin
            result = a + b;
        end 
        ALU_SUB: begin
            result = a - b;
        end
        default: begin
            result = 32'b0;
        end
    endcase
end

endmodule