`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 02/20/2026
// Module Name: Exp_Mem
// Project Name: 
// Target Devices: 
// Tool Versions:
// Description:
//////////////////////////////////////////////////////////////////////////////////

module Exp_Mem #(parameter N=32)
(
    input  signed [N-1:0] Exp_Mem_Input,

    output [N-1:0] Exp_Mem_w,
    output [N-1:0] Exp_Mem_b
);

reg [N-1:0] w;
reg [N-1:0] b;


always @(*) begin
    case(Exp_Mem_Input[N-1:N-8])

        8'b11110000: begin
            w = 32'h0000553b;
            b = 32'h00019ff2;
        end

        8'b11110001: begin
            w = 32'h00006d70;
            b = 32'h0001faba;
        end

        8'b11110010: begin
            w = 32'h00008c86;
            b = 32'h00026785;
        end

        8'b11110011: begin
            w = 32'h0000b46f;
            b = 32'h0002e93b;
        end

        8'b11110100: begin
            w = 32'h0000e7af;
            b = 32'h000382fa;
        end

        8'b11110101: begin
            w = 32'h0001297d;
            b = 32'h000437f0;
        end

        8'b11110110: begin
            w = 32'h00017dfb;
            b = 32'h00050b2c;
        end

        8'b11110111: begin
            w = 32'h0001ea79;
            b = 32'h0005ff47;
        end

        8'b11111000: begin
            w = 32'h000275c7;
            b = 32'h000715e4;
        end

        8'b11111001: begin
            w = 32'h000328a7;
            b = 32'h00084eeb;
        end

        8'b11111010: begin
            w = 32'h00040e54;
            b = 32'h0009a770;
        end

        8'b11111011: begin
            w = 32'h0005353e;
            b = 32'h000b1814;
        end

        8'b11111100: begin
            w = 32'h0006afeb;
            b = 32'h000c92c0;
        end

        8'b11111101: begin
            w = 32'h00089625;
            b = 32'h000dff6c;
        end

        8'b11111110: begin
            w = 32'h000b0679;
            b = 32'h000f3796;
        end

        8'b11111111: begin
            w = 32'h000e2821;
            b = 32'h00100000;
        end

        8'b00000000: begin
            w = 32'h00122d79;
            b = 32'h00100000;
        end

        8'b00000001: begin
            w = 32'h0017572d;
            b = 32'h000eb593;
        end

        8'b00000010: begin
            w = 32'h001df847;
            b = 32'h000b6506;
        end

        8'b00000011: begin
            w = 32'h00267b67;
            b = 32'h000502ae;
        end

        8'b00000100: begin
            w = 32'h00316973;
            b = 32'hfffa14a2;
        end

        8'b00000101: begin
            w = 32'h003f7237;
            b = 32'hffe889ad;
        end

        8'b00000110: begin
            w = 32'h0051776b;
            b = 32'hffcd81e0;
        end

        8'b00000111: begin
            w = 32'h00689ae3;
            b = 32'hffa503ce;
        end

        8'b00001000: begin
            w = 32'h008650c5;
            b = 32'hff699809;
        end

        8'b00001001: begin
            w = 32'h00ac76eb;
            b = 32'hff13c234;
        end

        8'b00001010: begin
            w = 32'h00dd72e6;
            b = 32'hfe994c3f;
        end

        8'b00001011: begin
            w = 32'h011c588e;
            b = 32'hfdec54b1;
        end

        8'b00001100: begin
            w = 32'h016d1b7e;
            b = 32'hfcfa0be2;
        end

        8'b00001101: begin
            w = 32'h01d4cea3;
            b = 32'hfba905ab;
        end

        8'b00001110: begin
            w = 32'h0259f5d8;
            b = 32'hf9d6fc71;
        end

        8'b00001111: begin
            w = 32'h0304eeaf;
            b = 32'hf755d74b;
        end
        
        8'b00010000: begin
            w = 32'h0304eeaf;
            b = 32'hf755d74b;
        end

        default: begin
            w = 32'd0;
            b = 32'd0;
        end

    endcase
end
assign Exp_Mem_w = w; 
assign Exp_Mem_b = b;
endmodule