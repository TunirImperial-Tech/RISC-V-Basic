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

        // Allow program.hex to finish
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

        //==================================================
        // Expected Results
        //==================================================

        $display("");
        $display("Expected:");

        $display("x1  = 10");
        $display("x2  = 12");
        $display("x3  = 0");
        $display("x4  = 100");
        $display("x5  = 0");
        $display("x6  = 301");
        $display("x7  = 0");
        $display("x8  = 303");
        $display("x9  = 400");
        $display("x10 = 0");

        //==================================================
        // Pass / Fail
        //==================================================

        $display("");
        $display("Checks:");

        if (uut.regfile_unit.registers[1]  == 10  &&
            uut.regfile_unit.registers[2]  == 12  &&
            uut.regfile_unit.registers[3]  == 0   &&
            uut.regfile_unit.registers[4]  == 100 &&
            uut.regfile_unit.registers[5]  == 0   &&
            uut.regfile_unit.registers[6]  == 301 &&
            uut.regfile_unit.registers[7]  == 0   &&
            uut.regfile_unit.registers[8]  == 303 &&
            uut.regfile_unit.registers[9]  == 400 &&
            uut.regfile_unit.registers[10] == 401) begin

            $display("");
            $display("========================================");
            $display("             PASS: CPU WORKS            ");
            $display("========================================");

        end
        else begin

            $display("");
            $display("========================================");
            $display("             FAIL: CPU ERROR            ");
            $display("========================================");

        end

        $finish;

    end

endmodule