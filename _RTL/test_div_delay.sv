`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2026 12:31:12 AM
// Design Name: 
// Module Name: test_div_delay
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


module test_div_delay(
    input [31:0] X,Y,
    input clk,rs,ld1,ld2,
    output [31:0] Q
    );
    
    wire [31:0] temp,temp1;
    wire [63:0] temp2;
    register re1(X,clk,rs,ld1,temp);
    register re2(Y,clk,rs,ld1,temp1);
    assign temp2 = temp1 * temp; 
    register re3(temp2[57:26],clk,rs,ld2,Q);
endmodule
