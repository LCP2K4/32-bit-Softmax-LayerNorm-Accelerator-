`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 10:45:37 PM
// Design Name: 
// Module Name: bram
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


module bram #(parameter N = 32)(
    input clk, rs,
    input [N - 1 : 0] din,
    input val_in,end_in,
    input [9 : 0]addr,
    input en,rw,
    output reg [N - 1 : 0] dout,
    output reg val_out,end_out 
    );
    reg [N + 1 : 0] temp [0 : 1023];
    always @(posedge clk) begin
        if(rs) dout <= 32'b0;
        else if (en) begin
            if(rw) begin
                temp[addr][N - 1 : 0] <= din;
                temp[addr][N] <= val_in;
                temp[addr][N+1] <= end_in;
            end
            else begin
                dout <= temp[addr][N - 1 : 0];
                val_out <= temp[addr][N];
                end_out <= temp[addr][N+1];
            end
         end
    end
    
endmodule
