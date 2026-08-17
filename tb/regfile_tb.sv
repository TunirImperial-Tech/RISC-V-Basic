module regfile_tb;

    //Inputs to regfile
    logic clk; 
    logic reg_write; 

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd; 

    logic [31:0] write_data;

    //Outputs from regfile
    logic [31:0] read_data_1;
    logic [31:0] read_data_2; 

    //Instantiation
    regfile dut(
        .clk(clk), 
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    //generate clock
    always #5 clk = ~clk; 

    initial begin
        //Waveform dump file
        $dumpfile("test_results/regfile_tb.vcd"); 
        $dumpvars(0, regfile_tb); 

        //Initial values
        clk = 0;
        reg_write = 0;
        rs1 = 0;
        rs2 = 0; 
        rd = 0;  
        write_data = 0; 

        //Write 42 to x5 and read it
        #10;
        reg_write = 1;
        rd = 5; 
        write_data = 42; 

        #10;
        reg_write = 0; 
        rs1 = 5; 
        #1; 
        $display("Test 1: x5 = %d", read_data_1);

        //Write 100 to x10
        #10; 
        reg_write = 1; 
        rd = 10; 
        write_data = 100; 

        #10; 
        reg_write = 0; 
        rs2 = 10; 
        #1; 
        $display("Test 2: x10 = %d", read_data_2);

        //Read two registers
        rs1 = 5;
        rs2 = 10; 
        #1; 
        $display("Test 3: x5 = %d, x10 = %d", read_data_1, read_data_2);

        //x0 must always be 0
        rs1 = 0; 
        #1; 
        $display("Test 4: x0 = %d", read_data_1);

        //Try to write to x0
        #10;
        reg_write = 1; 
        rd = 0; 
        write_data = 50; 

        #10;
        reg_write = 0; 
        rs1 = 0; 
        #1; 
        $display("Test 4: x0 = %d", read_data_1);

        $finish; 
        
    end
endmodule