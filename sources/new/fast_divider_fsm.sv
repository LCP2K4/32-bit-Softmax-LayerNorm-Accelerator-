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
    input clk, rs, start,
    output reg r1_ld, r2_ld, r3_ld, r4_ld, r5_ld, r6_ld,r7_ld,
    output reg done
    );
    
typedef enum {IDLE, R1, R2, R3, R4, R5, R6, R7, DONE_S} state_e;
    state_e state, next_state;
    
    always @(posedge clk or posedge rs) begin
        if(rs) state <= IDLE;
        else   state <= next_state;
    end
    
    always @(*) begin
        // ==========================================
        // 1. GÁN GIÁ TR? M?C ??NH (CH?NG LATCH)
        // ==========================================
        // T?ng lên 7 bit ?? bao g?m r7_ld
        {r7_ld, r6_ld, r5_ld, r4_ld, r3_ld, r2_ld, r1_ld} = 7'b0000000;
        done = 1'b0;
        next_state = state; // M?c ??nh gi? nguyên tr?ng thái
        
        // ==========================================
        // 2. LOGIC T?NG TR?NG THÁI (CH? GHI ?È KHI C?N)
        // ==========================================
        case(state)
            IDLE: begin
                if(start)
                    next_state = R1;
            end
            
            R1: begin
                r1_ld = 1'b1;
                next_state = R2;
            end
            
            R2: begin
                r2_ld = 1'b1;
                next_state = R3;
            end
            
            R3: begin
                r3_ld = 1'b1;
                next_state = R4;
            end
            
            R4: begin
                r4_ld = 1'b1;
                next_state = R5;
            end
            
            R5: begin
                r5_ld = 1'b1;
                next_state = R6;
            end
            
            R6: begin
                r6_ld = 1'b1;
                next_state = R7; // Chuy?n ti?p t?i R7 thay vì DONE_S
            end

            R7: begin
                r7_ld = 1'b1;
                next_state = DONE_S;
            end
            
            DONE_S: begin
                done = 1'b1;
                next_state = IDLE;
            end  
            
            default: begin
                next_state = IDLE;
            end
        endcase
     end
endmodule