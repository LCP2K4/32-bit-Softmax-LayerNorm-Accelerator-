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
    input clk,rs,ld,end_proc,
    output [N-1:0] accum_out,
    output [N-1:0] counter
    );
    reg [N-1:0] temp = 32'b0;
    reg [N-1:0] count = 32'b0;
    always @(posedge clk or posedge rs) begin
        if(rs) begin
            temp <= 32'b0;
            count <= 32'b0;
        end
        else begin
            if(ld) begin
                temp <= temp + add_in;
                count <= count + 4'd1000; 
            end
        end
    end
    register reg0(temp,clk,rs,end_proc,accum_out);
    register reg1(count,clk,rs,end_proc,counter);
endmodule
