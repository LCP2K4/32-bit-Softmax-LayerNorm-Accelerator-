`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 09:03:16 AM
// Design Name: 
// Module Name: PE_Interface
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


module PE_Interface#(parameter N = 32)(
    input [N - 1 : 0] X, div_result,mem,
    input clk, rs, valid, done_input,
    
    input mode_ld,
    input mean_ld,
    
    input lock,
//    input mux_ld,
    input [1:0] phase,
    
    output [N - 1 : 0] Pe_out,dut,
    output done_value,done_output,lock2
    
    );
    wire x_ld,w_ld,b_ld,mul_ld,exp_ld;
    wire [6 : 0] laddr;

    

    PE_datapath #(N) pe(X,div_result,mem,clk,rs,valid,done_input,
                        mode_ld,
                        mean_ld,
                        lock,
//                        mux_ld,
                        phase,
                        Pe_out,dut,
                        done_value,done_output,lock2);
//    exp_fsm exp(start,clk,rs,rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld, done);
    
endmodule
