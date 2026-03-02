`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2026 08:26:27 PM
// Design Name: 
// Module Name: Exp_Mem
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


module Exp_Mem #(parameter N = 32)(
    input [N - 1 : 0] Exp_Mem_Input,
    output [N - 1 : 0] Exp_Mem_w,
    output [N - 1 : 0] Exp_Mem_b
    );
    
    reg [N - 1 : 0] w = 32'b0;
    reg [N - 1 : 0] b = 32'b0;
    always @(*) begin
        case(Exp_Mem_Input [N - 1 : N - 6])
           6'b110100:  begin
                w = 32'h00000052;
                b = 32'h00000362;
           end
           6'b110111: begin
                w = 32'h000000de;
                b = 32'h00000853;
           end
           6'b111000: begin
                w = 32'h0000025c;
                b = 32'h00001443;
           end
           6'b111001: begin
                w = 32'h0000066b;
                b = 32'h000030a9;
           end
           6'b111010: begin
                w = 32'h00001172;
                b = 32'h000072d4;
           end
           6'b111011: begin
                w = 32'h00002f6c;
                b = 32'h000108b6;
           end
           6'b111100: begin
                w = 32'h000080e8;
                b = 32'h00024ea6;
           end
           6'b111101: begin
                w = 32'h00015e68;
                b = 32'h0004e725;
           end
           6'b111110: begin
                w = 32'h0003b880;
                b = 32'h00099b56;
           end
           6'b111111: begin
                w = 32'h000a1d2a;
                b = 32'h00100000;
           end
           6'b000000: begin
                w = 32'h001b7e15;
                b = 32'h00100000;
           end
           6'b000001: begin
                w = 32'h004abb7e;
                b = 32'hffe0c297;
           end
           6'b000010: begin
                w = 32'h00cb24c9;
                b = 32'hfedff001;
           end
           6'b000011: begin
                w = 32'h022833aa;
                b = 32'hfac8c35f;
           end
           6'b000100: begin
                w = 32'h05dd0a47;
                b = 32'hebf568ea;
           end
           6'b000101: begin
                w = 32'h0ff0400a;
                b = 32'hb9955c1b;
           end
           6'b000110: begin
                w = 32'h2b534514;
                b = 32'h80000000;
           end
           6'b000111: begin
                w = 32'h75c5327f;
                b = 32'h80000000;
           end
           default : begin
                w = 32'h7fffffff;
                b = 32'h80000000;    
            end
        endcase
    end
    assign Exp_Mem_w = w;
    assign Exp_Mem_b = b;
endmodule
