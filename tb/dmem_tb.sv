module dmem_tb;

    logic clk;
    logic mem_read;
    logic mem_write;

    logic [31:0] address;
    logic [31:0] write_data;

    logic [31:0] read_data;

    dmem uut(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;


        // =================================
        // Write 100 to address 0
        // =================================

        @(negedge clk);

        address = 32'd0;
        write_data = 32'd100;
        mem_write = 1;

        @(posedge clk);
        #1;

        mem_write = 0;


        // =================================
        // Read address 0
        // =================================

        address = 32'd0;
        mem_read = 1;

        #1;

        $display("Memory[0] = %0d", read_data);


        // =================================
        // Write 200 to address 4
        // =================================

        @(negedge clk);

        address = 32'd4;
        write_data = 32'd200;
        mem_read = 0;
        mem_write = 1;

        @(posedge clk);
        #1;

        mem_write = 0;


        // =================================
        // Read address 4
        // =================================

        address = 32'd4;
        mem_read = 1;

        #1;

        $display("Memory[4] = %0d", read_data);


        // =================================
        // Check results
        // =================================

        if (read_data == 32'd200)
            $display("PASS: Data memory works!");
        else
            $display("FAIL: Data memory error!");

        $finish;

    end

endmodule