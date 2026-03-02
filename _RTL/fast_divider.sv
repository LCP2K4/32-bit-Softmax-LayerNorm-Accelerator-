`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2026 12:16:21 AM
// Design Name: 
// Module Name: fast_divider
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


module fast_divider(
    input [31 : 0] X, Y,
    input clk,rs,ld,
    output [31 : 0] Q 
    );
    
    wire [62 : 0] x_extended;
    wire [31 : 0] y_extended;
    
    assign x_extended = {6'b0,X,25'b0};
    assign y_extended = {1'b0,Y[31 : 1]};
    reg [32 : 0] q_temp [15 : 0];
    wire [31:0] out_temp [15:0];
    wire [31:0] x_shift [15:0];
    wire [31:0] z_out;
    // lv0
     sub_proc sub_1(x_extended[62:31],y_extended,x_extended[30],out_temp[0],z_out[31]);
     assign z_out[15] = 1'b0;
    genvar i;
    generate
        for(i = 0; i < 8; i ++) begin: lv1
            sub_proc sub_1(out_temp[i],y_extended,x_extended[29 - i],out_temp[i+1],z_out[29 - i]);
            assign z_out[i] = 1'b0;
        end 
        
     endgenerate
//     register #(32) re1(out_temp[4],clk,rs,ld,out_temp[5]);
//     generate
//        for(i = 5; i < 9; i ++) begin: lv2
//            sub_proc sub_2(out_temp[i],y_extended,x_extended[30 - i + 1],out_temp[i+1],z_out[30 - i + 1]);
//        end 
//     endgenerate
//     register #(32) re2(out_temp[9],clk,rs,ld,out_temp[10]);
//     generate
//        for(i = 10; i < 14; i ++) begin: lv3
//            sub_proc sub_2(out_temp[i],y_extended,x_extended[30 - i + 2],out_temp[i+1],z_out[30 - i + 2]);
//        end 
//     endgenerate
     assign Q = z_out<<1;
     
     
     
endmodule
