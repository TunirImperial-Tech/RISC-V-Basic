module immediate_gen_tb;

    logic [31:0] instructions;
    logic [31:0] immediate;

    immediate_gen uut (
        .instructions(instructions),
        .immediate(immediate)
    );

    initial begin

        // ========================================
        // Test JAL +16
        // ========================================

        // JAL x1, +16
        instructions = 32'b00000001000000000000000011101111;

        #10;

        $display("JAL +16 immediate = %0d", $signed(immediate));


        // ========================================
        // Test JALR +20
        // ========================================

        // JALR x1, x2, +20
        // opcode = 1100111
        // funct3 = 000
        instructions = 32'b00000001010000010000000011100111;

        #10;

        $display("JALR +20 immediate = %0d", $signed(immediate));


        // ========================================
        // Test JALR -20
        // ========================================

        // I-type immediate = -20
        instructions = 32'b11111110110000010000000011100111;

        #10;

        $display("JALR -20 immediate = %0d", $signed(immediate));


        $finish;
    end

endmodule