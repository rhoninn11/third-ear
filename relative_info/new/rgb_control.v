`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2023 14:43:05
// Design Name: 
// Module Name: rgb_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RGB_control(
    input GCLK,
    output [2:0] RGB_LED_1_O,
    output [2:0] RGB_LED_2_O
);

    //counter signals
    localparam window = 50;
    reg [7:0] windowcount = 0;
    
    localparam deltacountMax = 1000000;
    reg [19:0] deltacount = 0;
        
    localparam valcountMax = 500;
    reg [8:0] valcount = 0;

    //color intensity signals
    wire [7:0] incVal;
    wire [7:0] decVal;

    reg [7:0] redVal;
    reg [7:0] greenVal;
    reg [7:0] blueVal;
    
    reg [7:0] redVal2;
    reg [7:0] greenVal2;
    reg [7:0] blueVal2;
    
    //PWM registers
    reg [2:0] rgbLedReg1;
    reg [2:0] rgbLedReg2;
    
    always @(posedge GCLK) begin
        if(windowcount < window)
            windowcount <= windowcount + 1;
        else
            windowcount <= 0;
    end

    always @(posedge GCLK) begin
        if(deltacount < deltacountMax)
            deltacount <= deltacount + 1;
        else
            deltacount <= 0;
    end

    always @(posedge GCLK) begin
        if(deltacount == 0) begin
            if(valcount < valcountMax)
                valcount <= valcount + 1;
            else
                valcount <= 0;
        end
    end

    assign incVal = {1'b0, valcount[6:0]};
    assign decVal = ~valcount;

    always @(*) begin
        redVal = (valcount[8:7] == 2'b00) ? incVal : ((valcount[8:7] == 2'b01) ? decVal : 8'b0);
        greenVal = (valcount[8:7] == 2'b00) ? decVal : ((valcount[8:7] == 2'b01) ? 8'b0 : incVal);
        blueVal = (valcount[8:7] == 2'b00) ? 8'b0 : ((valcount[8:7] == 2'b01) ? incVal : decVal);
        
        redVal2 = (valcount[8:7] == 2'b00) ? incVal : ((valcount[8:7] == 2'b01) ? decVal : 8'b0);
        greenVal2 = (valcount[8:7] == 2'b00) ? decVal : ((valcount[8:7] == 2'b01) ? 8'b0 : incVal);
        blueVal2 = (valcount[8:7] == 2'b00) ? 8'b0 : ((valcount[8:7] == 2'b01) ? incVal : decVal);
    end
    
    always @(posedge GCLK) begin
        rgbLedReg1[2] <= (redVal > windowcount);
        rgbLedReg1[1] <= (greenVal > windowcount);
        rgbLedReg1[0] <= (blueVal > windowcount);
        
        rgbLedReg2[2] <= (redVal2 > windowcount);
        rgbLedReg2[1] <= (greenVal2 > windowcount);
        rgbLedReg2[0] <= (blueVal2 > windowcount);
    end

    assign RGB_LED_1_O = rgbLedReg1;
    assign RGB_LED_2_O = rgbLedReg2;

endmodule

