`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 12:00:05 AM
// Design Name: 
// Module Name: Decoder
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


module Encoder(
    input [2:0] Y,
    output [2:0] En_Out
    );
    assign En_Out = (Y == 3'b000 || Y == 3'b111) ? 3'b000 : (Y == 3'b001 || Y == 3'b010) ? 3'b001 : 
    (Y == 3'b011) ? 3'b010 : (Y == 3'b100) ? 3'b110 : 3'b101;  
endmodule

