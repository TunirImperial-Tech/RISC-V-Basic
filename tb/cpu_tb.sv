`timescale 1ns/1ps

module tb_cpu;
    logic clk;
    logic reset;

    cpu dut (
        .clk(clk),
        .reset(reset)
    );

    // 10ns clock period
    always #5 clk = ~clk;

    integer f;
    integer i;

    initial begin
        clk = 0;
        reset = 1;

        // hold reset for 2 clock edges
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        // run for 50 instructions' worth of cycles (32 needed, generous margin)
        repeat (50) @(posedge clk);

        // dump all 32 registers to a file
        f = $fopen("sim/register_dump.txt", "w");
        for (i = 0; i < 32; i = i + 1) begin
            $fdisplay(f, "x%0d = %08h", i, dut.regfile_unit.registers[i]);
        end
        $fclose(f);

        $display("Register dump complete: sim/register_dump.txt");
        $finish;
    end
endmodule