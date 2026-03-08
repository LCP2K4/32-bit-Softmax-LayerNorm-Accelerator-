`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 08:45:24 AM
// Design Name: 
// Module Name: PE_fsm
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


module exp_fsm(
    input start, clk, rs,
    output reg rs_dp,x_ld, w_ld, b_ld ,mul_ld,exp_ld,
    output reg done
    );
    typedef enum {IDLE, START, LOAD, CAL, OUT, DONE_S} state_e;
    state_e state, next_state;
    always @(posedge clk or posedge rs) begin
        if(rs) state <= IDLE;
        else state <= next_state;
    end
    always @(*) begin
        case(state)
            IDLE: begin
                {rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld} = 6'b100000;
                done = 1'b0;
                next_state = START;
            end
            START: begin
                if(start) next_state = LOAD;
                else next_state = START;
            end
            LOAD: begin
                {rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld} = 6'b011100;
                next_state = CAL;
            end
            CAL: begin
            {rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld} = 6'b000010;
             next_state = OUT;
            end
            OUT: begin
                {rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld} = 6'b000001;
                next_state = DONE_S;
            end
            DONE_S: begin
                exp_ld = 1'b0;
                done = 1'b1;
                next_state = IDLE;
            end
            default: begin
                 {rs_dp,x_ld,w_ld,b_ld,mul_ld,exp_ld} = 6'b100000;
                 done = 1'b0;
                 next_state = IDLE;
            end
        endcase
    end
endmodule

