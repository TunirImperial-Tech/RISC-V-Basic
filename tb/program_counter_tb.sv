module program_counter_tb;

    logic clk;
    logic reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

    program_counter uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    assign next_pc = pc + 32'd4;

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        #10;

        reset = 0;

        #50;

        $finish;

    end

    always @(posedge clk) begin
        $display("PC = %0d", pc);
    end

endmodule