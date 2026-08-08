`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 12:02:19 AM
// Design Name: 
// Module Name: SRAM
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


module SRAM #(parameter N = 32,
               WIDTH = 20)(
    input clk,rs,en,
    input [WIDTH-1:0] addr,
    output reg [N-1:0] dout
    );
    reg [N-1:0] memory[0:(2**(WIDTH)-1)];
    initial begin
        $readmemh("data.mem",memory);
    end
    
    always @(posedge clk) begin
        if(en) begin
            dout <= memory[addr][N-1:0];
        end
    end
endmodule
