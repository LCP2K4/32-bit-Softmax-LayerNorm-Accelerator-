`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2026 01:59:12 PM
// Design Name: 
// Module Name: sub_proc
// Project Name: 
// Target Devices: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sub_proc(
    input [31 : 0] X, Y,
    input X_shift,
    output [31:0] Q,
    output cout
    );
    wire [31:0] shifted_x;
    assign shifted_x = {X[30:0], X_shift};
    wire [31:0] sub_result;
    assign sub_result = shifted_x - Y;

    assign cout = ~sub_result[31];
    assign Q = sub_result[31] ? shifted_x : sub_result;
endmodule
