module immediate_gen_tb;

    logic [31:0] instructions;
    logic [31:0] immediate;

    // Instantiate immediate generator
    immediate_gen dut(
        .instructions(instructions),
        .immediate(immediate)
    );

    initial begin

        // =========================
        // Positive immediate: 10
        // =========================
        instructions = 32'b0;
        instructions[31:20] = 12'd10;

        #10;

        $display("Positive immediate:");
        $display("  Expected = 10");
        $display("  Actual   = %0d", $signed(immediate));


        // =========================
        // Zero immediate
        // =========================
        instructions = 32'b0;
        instructions[31:20] = 12'd0;

        #10;

        $display("Zero immediate:");
        $display("  Expected = 0");
        $display("  Actual   = %0d", $signed(immediate));


        // =========================
        // Negative immediate: -10
        // 12-bit two's complement
        // =========================
        instructions = 32'b0;
        instructions[31:20] = -12'sd10;

        #10;

        $display("Negative immediate:");
        $display("  Expected = -10");
        $display("  Actual   = %0d", $signed(immediate));


        $finish;
    end

endmodule