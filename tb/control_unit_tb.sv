`include "src/encoder.svh"

module control_unit_tb;

    // Input to control unit
    logic [31:0] instructions;

    // Outputs from control unit
    logic [3:0] alu_control;
    logic       reg_write;
    logic       alu_src;
    logic       mem_read;
    logic       mem_write;
    logic       mem_to_reg;
    logic       branch;
    logic       jump;

    // ALU control values
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;
    localparam logic [3:0] ALU_XOR = 4'b0100;

    // Instantiate control unit
    control_unit dut(
        .instructions(instructions),
        .alu_control(alu_control),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump)
    );

    // Task to display control signals
    task display_control(string name);
        begin
            $display("%s:", name);
            $display("  alu_control = %b", alu_control);
            $display("  reg_write   = %b", reg_write);
            $display("  alu_src     = %b", alu_src);
            $display("  mem_read    = %b", mem_read);
            $display("  mem_write   = %b", mem_write);
            $display("  mem_to_reg  = %b", mem_to_reg);
            $display("  branch      = %b", branch);
            $display("  jump        = %b", jump);
            $display("");
        end
    endtask

    initial begin

        // =========================
        // R-TYPE TESTS
        // =========================

        // ADD x5, x6, x7
        instructions = encode_r_type(OP_ADD, 5, 6, 7);
        #10;

        if (alu_control == ALU_ADD && reg_write == 1'b1 && alu_src == 1'b0)
            $display("ADD PASS");
        else
            $display("ADD FAIL");

        display_control("ADD");


        // SUB x5, x6, x7
        instructions = encode_r_type(OP_SUB, 5, 6, 7);
        #10;

        if (alu_control == ALU_SUB && reg_write == 1'b1 && alu_src == 1'b0)
            $display("SUB PASS");
        else
            $display("SUB FAIL");

        display_control("SUB");


        // AND x5, x6, x7
        instructions = encode_r_type(OP_AND, 5, 6, 7);
        #10;

        if (alu_control == ALU_AND && reg_write == 1'b1 && alu_src == 1'b0)
            $display("AND PASS");
        else
            $display("AND FAIL");

        display_control("AND");


        // =========================
        // I-TYPE TESTS
        // =========================

        // ADDI x5, x6, 10
        instructions = encode_i_type(OP_ADD, 5, 6, 12'd10);
        #10;

        if (alu_control == ALU_ADD && reg_write == 1'b1 && alu_src == 1'b1)
            $display("ADDI PASS");
        else
            $display("ADDI FAIL");

        display_control("ADDI");


        // ANDI x5, x6, 10
        instructions = encode_i_type(OP_AND, 5, 6, 12'd10);
        #10;

        if (alu_control == ALU_AND && reg_write == 1'b1 && alu_src == 1'b1)
            $display("ANDI PASS");
        else
            $display("ANDI FAIL");

        display_control("ANDI");


        // ORI x5, x6, 10
        instructions = encode_i_type(OP_OR, 5, 6, 12'd10);
        #10;

        if (alu_control == ALU_OR && reg_write == 1'b1 && alu_src == 1'b1)
            $display("ORI PASS");
        else
            $display("ORI FAIL");

        display_control("ORI");


        $display("All selected control unit tests complete.");

        $finish;
    end

endmodule