module cpu(
    input logic clk, 
    input logic reset
);

    //Program Counter
    logic [31:0] pc; 
    logic [31:0] next_pc; 

    assign next_pc = pc + 32'd4; 

    program_counter pc_unit(
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    //Instruction memory
    logic [31:0] instruction; 

    imem imem_unit(
        .address(pc), 
        .instruction(instruction)
    );

    //Control unit
    logic [3:0] alu_control; 

    logic reg_write; 
    logic alu_src; 
    logic mem_read; 
    logic mem_write; 
    logic mem_to_reg; 
    logic branch; 
    logic jump; 


    control_unit decoder(
        .instructions(instruction),
        .alu_control(alu_control), 
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write), 
        .mem_to_reg(mem_to_reg), 
        .branch(branch), 
        .jump(jump)
    );

    //Register file
    logic [31:0] read_data_1;
    logic [31:0] read_data_2;
    
    logic [4:0] rs1; 
    logic [4:0] rs2; 
    logic [4:0] rd; 

    assign rs1 = instruction[19:15]; 
    assign rs2 = instruction[24:20]; 
    assign rd = instruction[11:7]; 

    regfile regfile_unit(
        .clk(clk), 
        .reg_write(reg_write), 
        .rs1(rs1), 
        .rs2(rs2),
        .rd(rd), 
        .write_data(alu_result),
        .read_data_1(read_data_1), 
        .read_data_2(read_data_2)
    );

    //Immediate generator
    logic [31:0] immediate; 

    immediate_gen immediate_unit(
        .instructions(instruction), 
        .immediate(immediate)
    );

    //ALU Mux
    logic [31:0] alu_input_b; 

    always_comb begin
        if (alu_src)
            alu_input_b = immediate;
        else
            alu_input_b = read_data_2; 
    end

    //ALU
    logic [31:0] alu_result; 

    alu alu_unit(
        .a(read_data_1), 
        .b(alu_input_b), 
        .alu_control(alu_control),
        .result(alu_result)
    );

endmodule