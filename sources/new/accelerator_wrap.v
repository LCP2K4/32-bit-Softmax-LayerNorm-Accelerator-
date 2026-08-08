`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 10:52:43 PM
// Design Name: 
// Module Name: accelerator_wrap
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


module accelerator_wrap
 #(parameter N = 32,
      parameter M = 1
    )
   (
    input start,
    input mode, // mode 0 Softmax (in process) mode 1 LayerNorm(undeveloped)
 //   input row_done,
    input [N-1:0] col_len,
    input [N-1:0] row_len,
    input  clk, rs,
    output [N-1:0] Y,
    output [9:0] addr,
    output done,fdone,
    output lock
    );
    
    accelerator_interface #(N,M) acc
    (
        .start(start),
        .mode(mode),
        .col_len(col_len),
        .row_len(row_len),
        .clk(clk),
        .rs(rs),
        .Y(Y),
        .addr(addr),
        .done(done),
        .fdone(fdone),
        .lock(lock)
     );
endmodule
