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


module SRAM #(parameter N = 34,
               WIDTH = 10)(
    input clk,rs,en,
    input [WIDTH-1:0] addr,
    output reg [N-3:0] dout,
    output reg valid, end_d
    );
    reg [N-1:0] memory[0:(2**(WIDTH-2)-1)];
    reg [N-1:0] temp;
    initial begin
        $readmemh("hardware_input_34b_per_row.mem",memory);
    end
    
    always @(posedge clk or posedge rs) begin
        if(rs) begin
            dout <= 32'b0;
            valid <= 1'b0;
            end_d <= 1'b0;
        end
        else if(en) begin
            dout <= memory[addr][N-3:0];
            valid <= memory[addr][N-2];
            end_d <= memory[addr][N-1];
        end
    end
endmodule
