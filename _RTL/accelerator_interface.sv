`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 10:32:20 PM
// Design Name: 
// Module Name: accelerator_interface
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


module accelerator_interface 
    #(parameter N = 32
    )
   (
    input [N-1:0] X[7 : 0],
    input clk, rs, start, mode, end_proc,
    output [N-1:0] Y,
    output done
    );
    
    genvar i;
    wire done_s [7 : 0];
    wire [N - 1 : 0] Pe_out[7 : 0];
    wire [N - 1 : 0] s1 [3 : 0];
    wire [N - 1 : 0] s2[1 : 0];
    wire [N - 1 : 0] s3;
    wire [N - 1 : 0] temp,counter,sqrt_temp;
    wire acess;
    reg sqrt_start;
generate
    for(i = 0; i < 8; i ++) begin : pe_proc
        PE_Interface pe(X[i],clk,rs,start, Pe_out[i],done_s[i]);
    end
    for(i = 0; i < 4; i ++) begin : lv1
        assign s1[i] =  Pe_out[2*i] + Pe_out[2*i + 1];
    end
    for(i = 0; i < 2; i ++) begin : lv2
        assign s2[i] =  s1[2*i] + s1[2*i + 1];
    end
endgenerate
    assign s3 = s2[0] + s2[1];  
    assign acess = done_s[0] & done_s[1] & done_s[2] & done_s[3] & done_s[4] & done_s[5] & done_s[6] & done_s[7]; 
    Accumulator Acc(s3,clk,rs,acess,end_proc,temp,counter);
    always @(posedge clk or posedge rs) begin
        if(rs) sqrt_start <= 1'b0;
        else sqrt_start <= end_proc;
    end
   
    sqrt_interface sqrt(.A(temp),
                        .clk(clk),
                        .reset(rs),   
                        .start(sqrt_start),
                        .mode_sl(mode),   // select mode 0: for softmax, 1: for LayerNorm
                        .O(Y),
                        .n_flag(),        //check negative (not used)
                        .done(done));

endmodule
