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
// Description: Booth Radix-4 Multiplier with Wallace Tree Reduction
// 
//////////////////////////////////////////////////////////////////////////////////

module Booth_4 #(parameter N = 32)(
    input [N-1:0] X, Y,
    output wire [2*N-1:0] Mul_out
);

wire [N:0] Y_temp;
assign Y_temp = {Y, 1'b0};

wire [2:0] En_temp [N/2-1:0];
wire [N:0] temp [N/2-1:0];       
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

        assign pp[i] =  $signed(temp[i]) <<< (2*i);
    end
endgenerate



wire [2*N-1:0] s1[4:0];
wire [2*N-1:0] c1[4:0];

wire [2*N-1:0] s2[2:0];
wire [2*N-1:0] c2[2:0];

wire [2*N-1:0] s3[1:0];
wire [2*N-1:0] c3[1:0];

wire [2*N-1:0] s4,c4;
wire [2*N-1:0] s5,c5;

/* Level 1 : 16 -> 11 */

CSA csa1 (pp[0],pp[1],pp[2],s1[0],c1[0]);
CSA csa2 (pp[3],pp[4],pp[5],s1[1],c1[1]);
CSA csa3 (pp[6],pp[7],pp[8],s1[2],c1[2]);
CSA csa4 (pp[9],pp[10],pp[11],s1[3],c1[3]);
CSA csa5 (pp[12],pp[13],pp[14],s1[4],c1[4]);

/* Level 2 : 11 -> 8 */

CSA csa6 (s1[0],c1[0],s1[1],s2[0],c2[0]);
CSA csa7 (c1[1],s1[2],c1[2],s2[1],c2[1]);
CSA csa8 (s1[3],c1[3],s1[4],s2[2],c2[2]);

/* Level 3 : 8 -> 6 */

CSA csa9  (c1[4],pp[15],s2[0],s3[0],c3[0]);
CSA csa10 (c2[0],s2[1],c2[1],s3[1],c3[1]);

/* Level 4 : 6 -> 4 */

CSA csa11 (s2[2],c2[2],s3[0],s4,c4);
CSA csa12 (c3[0],s3[1],c3[1],s5,c5);

/* Level 5 : 4 -> 3 */

wire [2*N-1:0] s6,c6;
CSA csa13 (s4,c4,s5,s6,c6);

/* Level 6 : 3 -> 2 */
// Sửa ở đây: Thêm Level 6 để nén nốt tín hiệu c5 bị bỏ quên từ Level 4
wire [2*N-1:0] s7,c7;
CSA csa14 (s6,c6,c5,s7,c7);

/* Final Adder */

assign Mul_out = s7 + c7; // Sửa ở đây: Cộng 2 output cuối cùng của Level 6

endmodule
