`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 12:03:35 PM
// Design Name: 
// Module Name: Add_Booth
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


module Add_Booth #(parameter N = 32)(
    input [N - 1 : 0] X,Y,
    input clk,rs,
    output [N - 1 : 0] Out
    );
    reg [N - 1 : 0] temp1, temp2, temp4;
    reg [2 * N - 1 : 0] temp3;
    register #(N) re1(X,clk,rs,temp1);
    register #(N) re2(Y,clk,rs,temp2);
    Booth_4 #(N) add(temp1,temp2,temp3);
    register #(N) re3(temp3[N-1 : 0],clk,rs,temp4);
    assign Out = temp4;
    
endmodule
