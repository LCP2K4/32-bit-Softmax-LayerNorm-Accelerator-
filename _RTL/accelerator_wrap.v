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
    input clk, rs,
    output [N-1:0] Y,
    output done
    );
    
    accelerator_interface #(N,M) acc
    (
        .start(start),
        .mode(mode),
        .clk(clk),
        .rs(rs),
        .Y(Y),
        .done(done)
     );
endmodule
