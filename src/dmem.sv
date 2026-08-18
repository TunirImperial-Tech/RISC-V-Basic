module dmem(
    input logic clk, 

    input logic mem_read,
    input logic mem_write, 

    input logic [31:0] address, 
    input logic [31:0] write_data, 

    output logic [31:0] read_data
);

    logic [31:0] memory [0:255]; 

    assign read_data = mem_read ? memory[address>>2] : 32'b0; 

    always_ff @( posedge clk ) begin 
        if (mem_write)
            memory[address>>2] <= write_data; 
    end
endmodule