`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 10:32:20 PM
// Design Name: 
// Module Name: accelerator_interface
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


module accelerator_interface #(parameter N = 32)(
    input [N-1:0] X[8 : 0],
    input start, clk, rs,
    output [N-1:0] Y
    );
    
    genvar i;
    wire done [8 : 0];
    wire [N - 1 : 0] Pe_out[8 : 0];
    wire [N : 0] s1 [2 : 0];
    wire c1 [2 : 0];
    wire [N - 1 : 0] s2,temp;
    wire c2;
generate
    for(i = 0; i < 9; i ++) begin : pe_proc
        PE_Interface pe(X[i],clk,rs,start, Pe_out[i],done[i]);
    end
    for(i = 0; i < 3; i ++) begin : lv1
        CSA ca1(Pe_out[3*i],Pe_out[3*i + 1],Pe_out[3*i + 2],s1[i],c1[i]);
    end
endgenerate
    CSA ca2({c1[0],s1[0]},{c1[1],s1[1]},{c1[2],s1[2]},s2,c2);    
    register re1({c2,s2},clk,rs,done[0],temp);
    assign Y = temp;
endmodule
