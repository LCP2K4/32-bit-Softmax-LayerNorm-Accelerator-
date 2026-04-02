`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2026 12:00:27 AM
// Design Name: 
// Module Name: counter_nbit
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


module counter_nbit #(parameter N = 10,
                      parameter [N-1:0] M = 1)
    (
    input clk,rs,
    input ld,done,
    output reg [N - 1 : 0] dout
    );
    
    
    reg check;
    always @(posedge clk or posedge rs) begin
        if(rs | check) begin
            dout <= {{N-1{1'b0}},1'b0};
            check <= 1'b0;
        end
        else begin
            if(ld) dout <= dout + M;
            if(done) check <= 1'b1;
        end
    end
endmodule
