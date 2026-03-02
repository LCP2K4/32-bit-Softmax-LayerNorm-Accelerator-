`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2026 11:26:41 AM
// Design Name: 
// Module Name: wallace_tree
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
module half_adder(
    input a,b,
    ouput s,cout);
    
    assign s = a & b;
    assign cout = (~a)&b | a & (~b);
endmodule

module full_adder(
    input a,b,cin,
    output s,cout);
    
    assign s = a ^ b ^ cin;
    assign cout = a & b | (a ^ b) & cin;
endmodule

module wallace_tree #(parameter N = 32)(
    input [N - 1 : 0] p[N/2 - 1 : 0],
    output [2 * N - 1 : 0] z
    );
    genvar i;
 
    assign z[1 : 0] = {p[0][1],p[0][0]}; 
    half_adder ha0(pp[0][2],pp[1][2],
endmodule
