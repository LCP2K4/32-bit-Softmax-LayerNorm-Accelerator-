`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 10:37:51 AM
// Design Name: 
// Module Name: PE_tb
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


module PE_tb(

    );
    parameter N = 32;
localparam SCALE = 1 << 26;

reg clk;
reg rs;
reg start;
reg signed [N-1:0] X;
wire signed [N-1:0] Pe_out;
wire done;
// DUT
PE_Interface #(N) dut (
    .X(X),
    .clk(clk),
    .rs(rs),
    .start(start),
    .Pe_out(Pe_out),
    .done(done)
);

// Clock 10ns
always #5 clk = ~clk;

initial begin
    clk = 0;
    rs = 1;
    start = 0;
    X = 0;

    // Reset
    #20;
    rs = 0;

    // =========================
    // Input = 1 (Q6.26)
    // =========================
    X = 32'h04000000;
    start = 1;
    #10;
    start = 0;
    #200;

    // =========================
    // Input = 2 (Q6.26)
    // =========================
    X = 2 * SCALE;
    start = 1;
    #10;
    start = 0;
    #200;

    // =========================
    // Input = -1 (Q6.26)
    // =========================
    X = -1 * SCALE;
    start = 1;
    #10;
    start = 0;
    #200;

    // =========================
    // Input = 0 (Q6.26)
    // =========================
    X = 0;
    start = 1;
    #10;
    start = 0;
    #200;
    
    $stop;
end

endmodule
