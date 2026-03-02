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


module sub_proc(
    input [31 : 0] X, Y,
    input X_shift,
    output [31:0] Q,
    output cout
    );
    wire [32 : 0] q_temp;
    wire [31:0] out_temp;
    cla_32bit cla(X,~Y,1,q_temp[31:0],q_temp[32]);
    mux_2_1 mu(q_temp[31:0],{X,X_shift},q_temp[31],out_temp);
    assign cout = ~q_temp[31];
    assign Q = out_temp;
endmodule
