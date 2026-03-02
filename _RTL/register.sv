`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 11:33:47 AM
// Design Name: 
// Module Name: register
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


module register #(parameter N = 32)(
    input [N - 1 : 0] D,
    input clk,rs,ld,
    output [N - 1 : 0] Q_Out
    );
    reg [N - 1 : 0] Q = 32'b0;

    always @(posedge clk or posedge rs) begin
        if(rs) Q <= 32'b0;
        else if(ld) Q <= D;
    end  
    assign Q_Out = Q;
endmodule
