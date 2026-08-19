module cpu(
    input logic clk, 
    input logic reset
);

    //Program Counter
    logic [31:0] pc; 
    logic [31:0] next_pc; 

    always_comb begin
        if (jump) next_pc = pc + immediate; 
        else if (jump_reg) next_pc = (read_data_1 + immediate) & 32'hFFFFFFFE; 
        else if (branch_taken) next_pc = branch_target;
        else next_pc = pc + 32'd4; 
    end

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

    //Data memory
    logic [31:0] memory_read_data; 
    logic [31:0] write_back_data; 

    dmem dmem_unit(
        .clk(clk), 
        .mem_read(mem_read), 
        .mem_write(mem_write), 
        .address(alu_result), 
        .write_data(read_data_2), 
        .read_data(memory_read_data)
    ); 

    always_comb begin
        if (jump || jump_reg)
            write_back_data = pc + 32'd4; 
        else if (mem_to_reg)
            write_back_data = memory_read_data; 
        else
            write_back_data = alu_result; 
    end

    //Control unit
    logic [3:0] alu_control; 

    logic reg_write; 
    logic alu_src; 
    logic mem_read; 
    logic mem_write; 
    logic mem_to_reg; 
    logic branch; 
    logic jump;
    logic jump_reg;  
    logic aui_pc; 

    logic [31:0] branch_target; 
    logic branch_taken; 

    assign branch_target = pc + immediate; 

    logic [2:0] funct3;
    assign funct3 = instruction[14:12];

    always_comb begin
        branch_taken = 1'b0; 

        if (branch) begin
            case (funct3)
                3'b000: branch_taken = (alu_result == 32'd0); 
                3'b001: branch_taken = (alu_result != 32'd0); 
                3'b100: branch_taken = (alu_result == 32'd1); 
                3'b101: branch_taken = (alu_result == 32'd0); 
                default: branch_taken = 1'b0; 
            endcase
        end
    end


    control_unit decoder(
        .instructions(instruction),
        .alu_control(alu_control), 
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write), 
        .mem_to_reg(mem_to_reg), 
        .branch(branch), 
        .jump(jump),
        .jump_reg(jump_reg),
        .aui_pc(aui_pc)
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
        .write_data(write_back_data),
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
    logic [31:0] alu_input_a; 
    logic [31:0] alu_result; 

    always_comb begin 
        if (aui_pc) alu_input_a = pc; 
        else alu_input_a = read_data_1; 
    end

    alu alu_unit(
        .a(alu_input_a), 
        .b(alu_input_b), 
        .alu_control(alu_control),
        .result(alu_result)
    );

endmodule