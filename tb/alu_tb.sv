module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] alu_control;

    logic [31:0] result;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result)
    );

    initial begin

        // ADD
        a = 10;
        b = 20;
        alu_control = 4'b0000;

        #10;
        $display("ADD: %d + %d = %d", a, b, result);

        // SUB
        a = 5;
        b = 1;
        alu_control = 4'b0001;

        #10;
        $display("SUB: %d - %d = %d", a, b, result);

        //AND
        a = 15;
        b = 19;
        alu_control = 4'b0010;

        #10;
        $display("AND: %d AND %d = %d", a, b, result);

        //OR
        a = 15;
        b = 19;
        alu_control = 4'b0011;

        #10;
        $display("OR: %d OR %d = %d", a, b, result);

        //XOR
        a = 15;
        b = 19;
        alu_control = 4'b0100;

        #10;
        $display("XOR: %d XOR %d = %d", a, b, result);

        $finish;

    end

endmodule