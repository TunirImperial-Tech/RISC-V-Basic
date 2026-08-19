module cpu_tb;

    logic clk;
    logic reset;

    //==================================================
    // CPU
    //==================================================

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    //==================================================
    // Clock
    //==================================================

    always #5 clk = ~clk;

    //==================================================
    // Test
    //==================================================

    initial begin

        clk   = 0;
        reset = 1;

        // Reset CPU
        #10;

        // Start CPU
        reset = 0;

        // Allow program.hex to execute
        #200;

        //==================================================
        // Results
        //==================================================

        $display("");
        $display("========================================");
        $display("          PROGRAM TEST RESULTS          ");
        $display("========================================");

        $display("");
        $display("Register values:");

        $display("x1  = %0d", uut.regfile_unit.registers[1]);
        $display("x2  = %0d", uut.regfile_unit.registers[2]);
        $display("x3  = %0d", uut.regfile_unit.registers[3]);
        $display("x4  = %0d", uut.regfile_unit.registers[4]);
        $display("x5  = %0d", uut.regfile_unit.registers[5]);
        $display("x6  = %0d", uut.regfile_unit.registers[6]);
        $display("x7  = %0d", uut.regfile_unit.registers[7]);
        $display("x8  = %0d", uut.regfile_unit.registers[8]);
        $display("x9  = %0d", uut.regfile_unit.registers[9]);
        $display("x10 = %0d", uut.regfile_unit.registers[10]);
        $display("x11 = %0d", uut.regfile_unit.registers[11]);
        $display("x12 = %0d", uut.regfile_unit.registers[12]);
        $display("x13 = %0d", uut.regfile_unit.registers[13]);
        $display("x14 = %0d", uut.regfile_unit.registers[14]);
        $display("x15 = %0d", uut.regfile_unit.registers[15]);
        $display("x16 = %0d", uut.regfile_unit.registers[16]);
        $display("x17 = %0d", uut.regfile_unit.registers[17]);
        $display("x18 = %0d", uut.regfile_unit.registers[18]);
        $display("x19 = %0d", uut.regfile_unit.registers[19]);
        $display("x20 = %0d", uut.regfile_unit.registers[20]);
        $display("x21 = %0d", uut.regfile_unit.registers[21]);

        $display("");

        $finish;

    end

endmodule