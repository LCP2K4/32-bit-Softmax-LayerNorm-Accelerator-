`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2026 09:39:52 AM
// Design Name: 
// Module Name: mux_4_1
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


module mux_4_1 #(parameter N = 32)(
    input  [N-1 : 0] A,B,C,D,
//    input clk,rs,en,
    input [1 : 0] sel,
    output reg [N-1 : 0] O
    );
//   reg [1 : 0] temp;
//    always @(posedge clk or posedge rs) begin
//        if(rs) temp <= 2'b0;
//        else begin
//            if(en) temp <= sel;
//        end
//    end
    always @(*) begin
        case(sel)
            2'b00 : O = A;
            2'b01 : O = B;
            2'b10 : O = C;
            2'b11 : O = D;
            default : O = A;
        endcase
    end       
endmodule
