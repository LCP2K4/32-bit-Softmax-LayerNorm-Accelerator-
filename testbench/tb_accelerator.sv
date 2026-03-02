`timescale 1ns/1ps

module tb_accelerator;

    parameter N = 32;
    parameter FRAC = 26;

    logic clk;
    logic rs;
    logic start;
    logic signed [N-1:0] X [0:8];
    logic signed [31:0] Y;   // m? r?ng bit
    logic signed [31:0] B;
    logic signed [31:0] Q;
    logic cout;

    accelerator_interface #(N) dut (
        .X(X),
        .clk(clk),
        .rs(rs),
        .start(start),
        .Y(Y)
    );
    
    fast_divider dut2 (
        X[0],B,clk,rs,1'b1,Q
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rs = 1;
        start = 0;

        #20 rs = 0;

        // 9 input = 1.0 (Q6.26)
        for (int i = 0; i < 9; i++)
            X[i] = 32'sd3 <<< FRAC;
        B = 32'sd1 << FRAC;
        #10 start = 1;
        #10 start = 0;

        #50;
         for (int i = 0; i < 9; i++)
            X[i] = 32'sd0 <<< FRAC;
        B = 32'sd2 <<< FRAC;
        #10 start = 1;
        #10 start = 0;
        #200;
    end

endmodule