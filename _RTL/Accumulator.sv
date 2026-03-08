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
    input clk,rs,ld,
    output [N-1:0] accum_out
    );
    reg [N-1:0] temp;
    always @(posedge clk or posedge rs) begin
        if(rs) temp <= 32'b0;
        else begin
            if(ld) temp <= temp + add_in;
        end
    end
    assign accum_out = temp;
endmodule
