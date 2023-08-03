`timescale 1ns / 1ps

module test_pre_spi();

    reg clk;
    reg cs_n;
    reg mosi;
    reg sclk;
    wire miso;
    reg [15:0] cycles_num;
    wire cycles_num_rdy;

    // Instantiate the Unit Under Test (UUT)
    pre_spi_2 uut (
        .clk(clk), 
        .cs_n(cs_n), 
        .mosi(mosi), 
        .sclk(sclk), 
        .miso(miso), 
        .cycles_num(cycles_num), 
        .cycles_num_rdy(cycles_num_rdy)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        cs_n = 1;
        mosi = 0;
        sclk = 0;
        cycles_num = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        #10 cs_n = 0;
        #500 cs_n = 1;

        // Finish the simulation
        #100 $finish;
    end

    always #5 clk = ~clk; // Generate a clock signal with a period of 10ns
    always #50 sclk = ~sclk; // Generate a clock signal with a period of 10ns

endmodule
