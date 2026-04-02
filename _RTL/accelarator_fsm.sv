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
    input clk,rs,start,
    input mode,
    input pe_done,acc_done,div_done,
    output reg mean_ld,
    output reg rs_pe,rs_dp,mode_ld,mode_sl,lock,rw,mux_ld, sqrt_ld,
    output reg [1:0] mux_sl, // 00: e^x, 01:mean, 10: var, 11:Softmax/LayerNorm 
    output reg done,
    output reg check
    );
    typedef enum {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17} state_s;
    state_s state, next_state;
    
    always @(posedge clk or posedge rs) begin
        if(rs) state <= S0;
        else   state <= next_state;
    end
    
    always @(*) begin
        case(state)
            S0 : begin
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b1000000;
                rs_pe = 1'b1;
                mux_sl = 2'b00;
                done = 1'b0;
                mode_ld = 1'b0;
                check = 1'b0;
                next_state = S1;
            end 
            S1 : begin
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                rs_pe = 1'b0;
                mux_sl = 2'b00;
                mode_ld = 1'b0;
                done = 1'b0;
                if(start) next_state = S2;
                else next_state = S1;
            end 
            S2 : begin
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                mux_sl = 2'b00;
                rs_pe = 1'b0;
                if(~mode) begin
                    next_state = S3;
                    mode_ld = 1'b0;
                end
                else begin
                    next_state = S6;
                    mux_sl = 2'b01;
                    mode_ld = 1'b1;
                end       
            end 
            S3 : begin  //e^x
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0011100;
                mux_sl = 2'b00;
                rs_pe = 1'b0;
                if(acc_done)
                    next_state = S4;
                else
                    next_state = S3;
            end 
            S4 : begin //accumulator and start div
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000010;
                mux_sl = 2'b00;
                rs_pe = 1'b1;
                next_state = S5;
            end 
            S5 : begin //wait div
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                mux_sl = 2'b00;
                rs_pe = 1'b0;
                if(div_done) begin
                    next_state = S16;
                    mux_sl = 2'b11;
                end
                else
                    next_state = S5;
            end
            
            // LAYER MORM
            S6 : begin //caculate x
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0011100;
                mux_sl = 2'b01;
                rs_pe = 1'b0;
                if(acc_done) begin
                    next_state = S7;
                end
                else
                    next_state = S6;
            end 
            S7 : begin // accumulator, counter and start div
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000010;
                mux_sl = 2'b01;
                rs_pe = 1'b1;
                next_state = S8;
            end 
            S8 : begin //caculate 1/N * ?x
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                mux_sl = 2'b01;
                rs_pe = 1'b0;
                if(div_done) begin
                    next_state = S9;
                end
                else
                    next_state = S8;
            end 
            S9 : begin //caculate (x - u)^2
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0010001;
                mux_sl = 2'b10;
                rs_pe = 1'b0;
                if(acc_done) begin
                    next_state = S10;
                    
                end
                else
                    next_state = S9;
            end
             
            S10 : begin //accumulator ?(x-u)^2
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0100010;
                mux_sl = 2'b01;
                rs_pe = 1'b1;
                next_state = S11;
            end
            S11 : begin //caculate 1/N ?(x-u)^2 + e
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0100000;
                mux_sl = 2'b01;
                rs_pe = 1'b0;
                if(div_done) begin
                    next_state = S12;
                end
                else
                    next_state = S11;
            end
            S12 : begin // start sqrt
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000010;
                mux_sl = 2'b10;
                rs_pe = 1'b0;
                next_state = S13;
            end
            S13 : begin //caculate sqrt(?(x-u)^2)
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                mux_sl = 2'b10;
                rs_pe = 1'b0;
                if(div_done) begin
                    next_state = S14;
                end
                else
                    next_state = S13;
            end
            S14 : begin // start div 1/sqrt(?(x-u)^2)
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000010;
                mux_sl = 2'b11;
                rs_pe = 1'b0;
                next_state = S15;
            end
            S15 : begin // caculate 1/sqrt(?(x-u)^2)
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                mux_sl = 2'b11;
                rs_pe = 1'b0;
                if(div_done) begin
                    next_state = S16;
                    check = 1'b1;    
                end
                else
                    next_state = S15;
            end
            S16 : begin // caculate Softmax and LayerNorm
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0010000;
                mux_sl = 2'b11;
                rs_pe = 1'b0;
                if(pe_done)
                    next_state = S17;
                else
                    next_state = S16;
            end
            S17 : begin // Done output
                {rs_dp,mode_sl,lock,rw,mux_ld, sqrt_ld,mean_ld} = 7'b0000000;
                mux_sl = 2'b00;
                rs_pe = 1'b0;
                done = 1'b1;
                next_state = S0;
            end
        endcase
     end 
endmodule
