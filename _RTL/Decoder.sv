`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 12:18:54 AM
// Design Name: 
// Module Name: Encoder
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


module Decoder(
    input [31 : 0] X,
    input [2 : 0] De_Sel,
    output [32 : 0] De_Out
    );
    reg [32 : 0] En_Temp;
    always @(*) begin
        case(De_Sel)
            3'b000 : En_Temp = 33'b0;
            3'b001 : En_Temp = {X[31],X};
            3'b010 : En_Temp = {X[31],X} << 1;
            3'b110 : En_Temp = (~({X[31],X} << 1)) + 1;
            3'b101 : En_Temp = (~{X[31],X}) + 1;
            default : En_Temp = 33'b0;
         endcase
    end
    assign De_Out = En_Temp; 
endmodule