`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2026 02:29:42 PM
// Design Name: 
// Module Name: accelarator_fsm
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

module accelarator_fsm(
    input clk, rs, start,
    input mode,
    input pe_done, acc_done, div_done, row_done,
    output reg mean_ld,
    output reg rs_pe, rs_dp, mode_ld, mode_sl, lock, rw, mux_ld, sqrt_ld,
    output reg [1:0] mux_sl, // 00: e^x, 01:mean, 10: var, 11:Softmax/LayerNorm 
    output reg done,
    output reg fdone,
    output reg check
    );
    
    typedef enum {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18} state_s;
    state_s state, next_state;
    
    always @(posedge clk or posedge rs) begin
        if(rs) state <= S0;
        else   state <= next_state;
    end
    
    always @(*) begin
        // =================================================================
        // GÁN GIÁ TR? M?C ??NH CHO T?T C? TÍN HI?U (CH?NG LATCH TUY?T ??I)
        // =================================================================
        rs_dp   = 1'b0;
        mode_sl = 1'b0;
        lock    = 1'b0;
        rw      = 1'b0;
        mux_ld  = 1'b0;
        sqrt_ld = 1'b0;
        mean_ld = 1'b0;
        
        rs_pe   = 1'b0;
        mux_sl  = 2'b00;
        done    = 1'b0;
        fdone   = 1'b0;
        check   = 1'b0;
        
        next_state = state; // M?c ??nh FSM s? gi? nguyên tr?ng thái hi?n t?i
        
        // =================================================================
        // LOGIC CHUY?N TR?NG THÁI (CH? GHI ?È KHI C?N THI?T)
        // =================================================================
        case(state)
            S0 : begin
                rs_dp = 1'b1;
                rs_pe = 1'b1;
                next_state = S1;
            end 
            
            S1 : begin
                if(start) begin
                    next_state = S2;
                    check = 1'b1;
                end
            end 
            
            S2 : begin
                rs_pe = 1'b1;
                
                if(~mode) begin
                    next_state = S3;
                end
                else begin
                    next_state = S6;
                    mux_sl = 2'b01;
                end       
            end 
            
            S3 : begin  //e^x
                lock = 1'b1;
                rw = 1'b1;
                mux_ld = 1'b1;
                
                if(acc_done) begin
                    check = 1'b1;
                    lock = 1'b0;
                    next_state = S4;
                end
            end 
            
            S4 : begin //accumulator and start div
                sqrt_ld = 1'b1;
                rs_pe = 1'b1;
                next_state = S5;
            end 
            
            S5 : begin //wait div
                if(div_done) begin
                    next_state = S16;
                    mux_sl = 2'b11;
                    check = 1'b1;
                end
            end
            
            // LAYER MORM
            S6 : begin //caculate x
                lock = 1'b1;
                rw = 1'b1;
                mux_ld = 1'b1;
                mux_sl = 2'b01;
                
                if(acc_done) begin
                    next_state = S7;
                end
            end 
            
            S7 : begin // accumulator, counter and start div
                sqrt_ld = 1'b1;
                mux_sl = 2'b01;
                rs_pe = 1'b1;
                next_state = S8;
            end 
            
            S8 : begin //caculate 1/N * ?x
                mux_sl = 2'b01;
                
                if(div_done) begin
                    mean_ld = 1'b1;
                    next_state = S9;
                end
            end 
            
            S9 : begin //caculate (x - u)^2
                lock = 1'b1;
                mean_ld = 1'b1;
                mux_sl = 2'b10;
                
                if(acc_done) begin
                    next_state = S10;
                end
            end
             
            S10 : begin //accumulator ?(x-u)^2
                mode_sl = 1'b1;
                sqrt_ld = 1'b1;
                mux_sl = 2'b01;
                rs_pe = 1'b1;
                next_state = S11;
            end
            
            S11 : begin //caculate 1/N ?(x-u)^2 + e
                mode_sl = 1'b1;
                mux_sl = 2'b01;
                
                if(div_done) begin
                    next_state = S12;
                end
            end
            
            S12 : begin // start sqrt
                sqrt_ld = 1'b1;
                mux_sl = 2'b10;
                next_state = S13;
            end
            
            S13 : begin //caculate sqrt(?(x-u)^2)
                mux_sl = 2'b10;
                
                if(div_done) begin
                    next_state = S14;
                end
            end
            
            S14 : begin // start div 1/sqrt(?(x-u)^2)
                sqrt_ld = 1'b1;
                mux_sl = 2'b11;
                next_state = S15;
            end
            
            S15 : begin // caculate 1/sqrt(?(x-u)^2)
                mux_sl = 2'b11;
                
                if(div_done) begin
                    next_state = S16;
                    check = 1'b1;   
                end
            end
            
            S16 : begin // caculate Softmax and LayerNorm
                lock = 1'b1;
                mux_sl = 2'b11;
                
                if(pe_done)
                    next_state = S17;
            end
            
            S17 : begin // caculate Softmax and LayerNorm
                mux_sl = 2'b11;
                done = 1'b1;
                
                if(row_done)
                    next_state = S18;
                else
                    next_state = S2;
            end
            
            S18 : begin // Done output
                fdone = 1'b1;
                next_state = S0;
            end
            
            default: begin
                next_state = S0;
            end
        endcase
     end 
endmodule