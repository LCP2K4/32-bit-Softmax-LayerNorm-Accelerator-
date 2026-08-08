`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2026 03:40:23 PM
// Design Name: 
// Module Name: fast_divider
// Project Name: 
// Target Devices: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fast_divider(
    input  [31:0] X, Y,
    input clk, rs, start,
    output [31:0] Q,
    output done
);

//---------------------------------------
    // Fixed-point alignment
    //---------------------------------------
    wire [62:0] x_extended = {{12{X[31]}}, X, 19'b0};
    wire [31:0] y_extended = {1'b0, Y[31:1]};

    //---------------------------------------
    // Internal signals
    //---------------------------------------
    wire [31:0] out_temp [0:23]; // T?ng kích th??c ?? ch?a thêm output c?a sub_proc
    wire [31:0] reg_temp [0:6];  // T?ng lên 7 thanh ghi (0 ??n 6)
    wire [31:0] q_bit;

    //---------------------------------------
    // PHASE 0
    //---------------------------------------
    sub_proc s00(x_extended[62:31], y_extended, x_extended[30], out_temp[0], q_bit[31]);
    sub_proc s01(out_temp[0],       y_extended, x_extended[29], out_temp[1], q_bit[30]);
    sub_proc s02(out_temp[1],       y_extended, x_extended[28], out_temp[2], q_bit[29]);

    register #(32) r0(out_temp[2], clk, rs, ld1, reg_temp[0]);

    //---------------------------------------
    // PHASE 1
    //---------------------------------------
    sub_proc s10(reg_temp[0], y_extended, x_extended[27], out_temp[3], q_bit[28]);
    sub_proc s11(out_temp[3], y_extended, x_extended[26], out_temp[4], q_bit[27]);
    sub_proc s12(out_temp[4], y_extended, x_extended[25], out_temp[5], q_bit[26]);

    register #(32) r1(out_temp[5], clk, rs, ld2, reg_temp[1]);

    //---------------------------------------
    // PHASE 2
    //---------------------------------------
    sub_proc s20(reg_temp[1], y_extended, x_extended[24], out_temp[6], q_bit[25]);
    sub_proc s21(out_temp[6], y_extended, x_extended[23], out_temp[7], q_bit[24]);
    sub_proc s22(out_temp[7], y_extended, x_extended[22], out_temp[8], q_bit[23]);

    register #(32) r2(out_temp[8], clk, rs, ld3, reg_temp[2]);

    //---------------------------------------
    // PHASE 3 
    //---------------------------------------
    sub_proc s30(reg_temp[2], y_extended, x_extended[21], out_temp[9],  q_bit[22]);
    sub_proc s31(out_temp[9], y_extended, x_extended[20], out_temp[10], q_bit[21]);
    sub_proc s32(out_temp[10],y_extended, x_extended[19], out_temp[11], q_bit[20]);

    register #(32) r3(out_temp[11], clk, rs, ld4, reg_temp[3]);

    //---------------------------------------
    // PHASE 4 
    //---------------------------------------
    sub_proc s40(reg_temp[3], y_extended, x_extended[18], out_temp[12], q_bit[19]);
    sub_proc s41(out_temp[12],y_extended, x_extended[17], out_temp[13], q_bit[18]);
    sub_proc s42(out_temp[13],y_extended, x_extended[16], out_temp[14], q_bit[17]);

    register #(32) r4(out_temp[14], clk, rs, ld5, reg_temp[4]);

    //---------------------------------------
    // PHASE 5
    //---------------------------------------
    sub_proc s50(reg_temp[4], y_extended, x_extended[15], out_temp[15], q_bit[16]);
    sub_proc s51(out_temp[15], y_extended, x_extended[14], out_temp[16], q_bit[15]);
    sub_proc s52(out_temp[16], y_extended, x_extended[13], out_temp[17], q_bit[14]);
    
    register #(32) r5(out_temp[17], clk, rs, ld6, reg_temp[5]);
    
    //---------------------------------------
    // PHASE 6 (New stage for ld7)
    //---------------------------------------
    sub_proc s60(reg_temp[5], y_extended, x_extended[12], out_temp[18], q_bit[13]);
    sub_proc s61(out_temp[18], y_extended, x_extended[11], out_temp[19], q_bit[12]);
    sub_proc s62(out_temp[19], y_extended, x_extended[10], out_temp[20], q_bit[11]);
    
    register #(32) r6(out_temp[20], clk, rs, ld7, reg_temp[6]);

    //---------------------------------------
    // FINAL
    //---------------------------------------
    sub_proc s70(reg_temp[6], y_extended, x_extended[9], out_temp[21], q_bit[10]);
    sub_proc s71(out_temp[21], y_extended, x_extended[8], out_temp[22], q_bit[9]); // Thêm s71
    sub_proc s72(out_temp[22], y_extended, x_extended[7], out_temp[23], q_bit[8]); // Thêm s72
    sub_proc s73(out_temp[23], y_extended, x_extended[6], out_temp[24], q_bit[7]); // Thêm s73
    
    // Rút g?n ph?n gán c?ng còn 7 bit (do bit 9, 8, 7 ?ã ???c tính ? trên). 
    // Chu?i c? là 0101010101, nên 7 bit cu?i s? là 1010101 ?? gi? nguyên pattern.
    assign q_bit[6:0] = 7'b0111111;
    //---------------------------------------
    // Output
    //---------------------------------------
    assign Q = q_bit >> 1;

    //---------------------------------------
    // FSM
    //---------------------------------------
    fast_divider_fsm fsm(
        .clk(clk), 
        .rs(rs), 
        .start(start),
        .r1_ld(ld1), 
        .r2_ld(ld2), 
        .r3_ld(ld3), 
        .r4_ld(ld4), 
        .r5_ld(ld5), 
        .r6_ld(ld6), 
        .r7_ld(ld7), // B? sung tín hi?u ld7
        .done(done)
    );

endmodule