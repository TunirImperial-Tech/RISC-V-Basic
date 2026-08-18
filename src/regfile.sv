module regfile(
    input logic clk,
    input logic reg_write,

    //5 bits for 32 registers
    input logic [4:0] rs1, 
    input logic [4:0] rs2, 
    input logic [4:0] rd, 

    input logic [31:0] write_data,

    output logic [31:0] read_data_1, 
    output logic [31:0] read_data_2
);

logic [31:0] registers [0:31];

// Initialise registers to zero
integer i;

initial begin
    for (i = 0; i < 32; i = i + 1)
        registers[i] = 32'b0;
end

//Read Registers
assign read_data_1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1]; 
assign read_data_2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

//Write Register
always_ff @( posedge clk ) begin 
    if (reg_write && rd != 5'b00000)
        registers[rd] <= write_data;
    
end


endmodule