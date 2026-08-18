module imem_tb;

    logic [31:0] address;
    logic [31:0] instruction;

    imem uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        address = 0;
        #10;
        $display("Address = %0d, Instruction = %h", address, instruction);

        address = 4;
        #10;
        $display("Address = %0d, Instruction = %h", address, instruction);

        address = 8;
        #10;
        $display("Address = %0d, Instruction = %h", address, instruction);

        address = 12;
        #10;
        $display("Address = %0d, Instruction = %h", address, instruction);

        $finish;

    end

endmodule