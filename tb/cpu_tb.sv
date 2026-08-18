module cpu_tb;

    logic clk;
    logic reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // 10 time-unit clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;

        // Start CPU
        reset = 0;

        // Let program execute
        #100;

        // Check results
        $display("");
        $display("========== CPU TEST RESULTS ==========");

        $display("x1 = %0d", uut.regfile_unit.registers[1]);
        $display("x2 = %0d", uut.regfile_unit.registers[2]);
        $display("x3 = %0d", uut.regfile_unit.registers[3]);
        $display("x4 = %0d", uut.regfile_unit.registers[4]);
        $display("x5 = %0d", uut.regfile_unit.registers[5]);
        $display("x6 = %0d", uut.regfile_unit.registers[6]);
        $display("x7 = %0d", uut.regfile_unit.registers[7]);

        $display("");

        // Check expected values

        if (uut.regfile_unit.registers[1] == 10)
            $display("PASS: x1 = 10");
        else
            $display("FAIL: x1 expected 10");

        if (uut.regfile_unit.registers[2] == 20)
            $display("PASS: x2 = 20");
        else
            $display("FAIL: x2 expected 20");

        if (uut.regfile_unit.registers[3] == 30)
            $display("PASS: x3 = 30");
        else
            $display("FAIL: x3 expected 30");

        if (uut.regfile_unit.registers[4] == 20)
            $display("PASS: x4 = 20");
        else
            $display("FAIL: x4 expected 20");

        if (uut.regfile_unit.registers[5] == 0)
            $display("PASS: x5 = 0");
        else
            $display("FAIL: x5 expected 0");

        if (uut.regfile_unit.registers[6] == 30)
            $display("PASS: x6 = 30");
        else
            $display("FAIL: x6 expected 30");

        if (uut.regfile_unit.registers[7] == 30)
            $display("PASS: x7 = 30");
        else
            $display("FAIL: x7 expected 30");

        $display("");
        $display("=======================================");

        $finish;
    end

    // Show what the CPU is doing each cycle
    always @(posedge clk) begin

        #1;

        $display(
            "Time=%0t | PC=%0d | Instruction=%h | rs1=%d | rs2=%d | rd=%d | ALU=%0d | WriteData=%0d | RegWrite=%b | x1=%0d | x2=%0d",
            $time,
            uut.pc,
            uut.instruction,
            uut.rs1,
            uut.rs2,
            uut.rd,
            uut.alu_result,
            uut.reg_write,
            uut.regfile_unit.registers[1],
            uut.regfile_unit.registers[2]
        );

    end

endmodule