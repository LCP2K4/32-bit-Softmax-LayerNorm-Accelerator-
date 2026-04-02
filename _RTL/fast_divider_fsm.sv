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
    input clk,rs,start,
    output reg r1_ld,r2_ld,r3_ld,r4_ld,r5_ld,r6_ld,
    output reg done
    );
    typedef enum {IDLE, R1,R2,R3,R4,R5,R6,DONE_S} state_e;
    state_e state, next_state;
    always @(posedge clk or posedge rs) begin
        if(rs) state <= IDLE;
        else state <= next_state;
    end
    always @(*) begin
        case(state)
            IDLE: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b0;
                r6_ld = 1'b0;
                done = 1'b0;
                if(start)
                    next_state = R1;
                else
                    next_state = IDLE;
            end
            R1: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b00001;
                r6_ld = 1'b0;
                next_state = R2;
            end
            R2: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b00010;
                r6_ld = 1'b0;
                next_state = R3;
            end
            R3: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b00100;
                r6_ld = 1'b0;
                next_state = R4;
            end
            R4: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b01000;
                r6_ld = 1'b0;
                next_state = R5;
            end
            R5: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b10000;
                r6_ld = 1'b0;
                next_state = R6;
            end
            R6: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b00000;
                r6_ld = 1'b0;
                r6_ld = 1'b1;
                next_state = DONE_S;
            end
            DONE_S: begin
                {r5_ld,r4_ld,r3_ld,r2_ld,r1_ld} = 5'b00000;
                r6_ld = 1'b0;
                done = 1'b1;
                next_state = IDLE;
            end  
            default: next_state = IDLE;
        endcase
     end
endmodule