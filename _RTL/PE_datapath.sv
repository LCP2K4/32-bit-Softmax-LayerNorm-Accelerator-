`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 08:15:27 AM
// Design Name: 
// Module Name: PE_datapath
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


module PE_datapath#(parameter N = 32)(
    input [N - 1 : 0] X,
    input clk, rs,
    input x_ld, w_ld, b_ld,mul_ld,exp_ld,
    output [N - 1 : 0] Exp_Out
    );
    wire cout;
    wire [N - 1 : 0] X_temp, W_temp,B_temp,W,B,Mul_in,add_temp;
    wire [2 * N - 1 : 0] Mul_temp;
    reg [N - 1 : 0] Mul_out;
    reg [N - 1 : 0] Exp_temp;
    register #(N) rex(X,clk,rs,x_ld,X_temp);
    assign Mul_in = $signed(X_temp) >>> 6;
    Exp_Mem #(N) exp(X,W,B);
    register #(N) rew(W,clk,rs,w_ld,W_temp);
    register #(N) reb(B,clk,rs,b_ld,B_temp);
    Booth_4 #(N) bo4(Mul_in,W_temp,Mul_temp);
    register #(N) mul(Mul_temp[51 : 20],clk,rs, mul_ld, Mul_out);
    cla_32bit cla(Mul_out,B_temp,1'b0,add_temp,cout);
    register #(N) reexp({cout,add_temp},clk,rs,exp_ld,Exp_temp);
    assign Exp_Out = $signed(Exp_temp) <<< 6;
    
endmodule
