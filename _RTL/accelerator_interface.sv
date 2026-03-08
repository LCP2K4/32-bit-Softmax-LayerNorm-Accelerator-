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
    input [N-1:0] X[7 : 0],
    input start, clk, rs,
    output [N-1:0] Y
    );
    
    genvar i;
    wire done [7 : 0];
    wire [N - 1 : 0] Pe_out[7 : 0];
    wire [N - 1 : 0] s1 [3 : 0];
    wire [N - 1 : 0] s2[1 : 0];
    wire [N - 1 : 0] s3;
    wire [N - 1 : 0] temp;
generate
    for(i = 0; i < 8; i ++) begin : pe_proc
        PE_Interface pe(X[i],clk,rs,start, Pe_out[i],done[i]);
    end
    for(i = 0; i < 4; i ++) begin : lv1
        assign s1[i] =  Pe_out[2*i] + Pe_out[2*i + 1];
    end
    for(i = 0; i < 2; i ++) begin : lv2
        assign s2[i] =  s1[2*i] + s1[2*i + 1];
    end
endgenerate
    assign s3 = s2[0] + s2[1];   
    Accumulator Acc(s3,clk,rs,done[0],temp);
    assign Y = temp;
endmodule
