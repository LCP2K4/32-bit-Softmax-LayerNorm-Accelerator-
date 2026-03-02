`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 12:30:35 AM
// Design Name: 
// Module Name: Booth_4
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


module Booth_4 #(parameter N = 32)(
    input [N-1:0] X, Y,start,clk,rs,
    output reg [2*N-1:0] Mul_out,
    output check
);

wire [N:0] Y_temp;
assign Y_temp = {Y,1'b0};

wire [2:0] En_temp [N/2-1:0];
wire [N-1:0] temp [N/2-1:0];
wire [2*N-1:0] pp   [N/2-1:0];

genvar i;
generate
    for (i = 0; i < N/2; i = i + 1) begin : en
        Encoder en0(
            Y_temp[2*i+2 : 2*i],
            En_temp[i]
        );
    end
endgenerate    
generate
    for (i = 0; i < N/2; i = i + 1) begin :  de
        Decoder de0(
            X,
            En_temp[i],
            temp[i]
        );

        assign pp[i] =  $signed(temp[i]) << (2*i);

    end
endgenerate


integer k;
wire [2*N-1:0] s1[N/2 - 1:0];
wire [2*N-1:0] s2[N/8 - 1:0];
wire [2*N-1:0] s3[N/16 - 1:0];
reg [2*N - 1 : 0] s4;
reg check_temp;
generate
    for(i = 0; i < N/2; i ++) begin : lv1
        assign s1[i] = pp[2*i] + pp[2*i + 1];
    end
    for(i = 0; i < N/8; i ++) begin : lv2
        assign s2[i] = s1[2*i] + s1[2*i + 1];
    end
    for(i = 0; i < N/16; i ++) begin : lv3
        assign s3[i] = s2[2*i] + s2[2*i+1];
    end
endgenerate

assign check = check_temp;
    always @(posedge clk or posedge rs) begin
        if(rs) begin
            check_temp <= 1'b0;
         end
         else begin
            if(start) begin
                check_temp <= 1'b1;
                s4 <= s3[0] + s3[1];
            end
         end   
    end
assign check = check_temp;
assign Mul_out = s4;
endmodule

