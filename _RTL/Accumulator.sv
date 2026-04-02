`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2026 07:43:18 PM
// Design Name: 
// Module Name: Accumulator
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


module Accumulator #(parameter N = 32)(
    input [N-1:0] add_in,
    input clk,rs,rs_pe,ld,end_proc,
    input div_done,
    output [N-1:0] accum_out,
    output [N-1:0] counter,
    output reg acc_done
    );
    reg [N-1:0] temp = 32'b0;
    reg [N-1:0] count;
    reg [N-1:0] check = 32'b0;
    always @(posedge clk or posedge rs) begin
        if(rs | rs_pe) begin
            temp <= 32'b0;
            check <= 32'b0;
            acc_done <= 1'b0;
        end
        else begin
            if(ld ) begin
                temp <= temp +add_in;
            end
            if(end_proc) acc_done <= 1'b1;
            else acc_done <= 1'b0;
        end
    end
    counter_nbit #(32,1)  cnt(clk,rs_pe,ld,acc_done,count);
    register reg0(temp,clk,rs,acc_done,accum_out);
    register reg1(count,clk,rs,acc_done,counter);
//    assign counter = count;
endmodule
