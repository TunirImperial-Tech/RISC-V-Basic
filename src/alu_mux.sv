module alu_mux(
    input logic [31:0] rs2_data, 
    input logic [31:0] immediate, 

    input logic alu_src, 

    output logic alu_b
);

always_comb begin
    if (alu_src)
        alu_b = immediate;
    else
        alu_b = rs2_data; 
end
endmodule
