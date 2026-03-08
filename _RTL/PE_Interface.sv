`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 09:03:16 AM
// Design Name: 
// Module Name: PE_Interface
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


module PE_Interface#(parameter N = 32)(
    input [N - 1 : 0] X,
    input clk, rs, start,
    output [N - 1 : 0] Pe_out,
    output done
    );
    wire rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld;
    PE_datapath #(N) pe(X,clk,rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld,Pe_out);
    exp_fsm exp(start,clk,rs,rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld, done);
endmodule
