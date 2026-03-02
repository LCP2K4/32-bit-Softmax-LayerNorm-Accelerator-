`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2026 01:27:58 AM
// Design Name: 
// Module Name: fast_divider_fsm
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


module fast_divider_fsm(
    input start,clk,rs,
    output reg r1_ld,r2_ld,r3_ld,r4_ld
    );
     typedef enum {IDLE, START, R1,R2,R3,R4,DONE} state_e;
    state_e state, next_state;
    always @(posedge clk or posedge rs) begin
        if(rs) state <= IDLE;
        else state <= next_state;
    end
    always @(*) begin
        case(state)
endmodule
