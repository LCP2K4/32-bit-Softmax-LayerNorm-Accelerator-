module fast_divider(
    input  [31:0] X, Y,
    input clk, rs, start,
    output [31:0] Q,
    output done
);

    //---------------------------------------
    // Fixed-point alignment
    //---------------------------------------
    wire [62:0] x_extended = {6'b0, X, 25'b0};
    wire [31:0] y_extended = {1'b0, Y[31:1]};

    //---------------------------------------
    // Internal signals
    //---------------------------------------
    wire [31:0] out_temp [0:15];
    wire [31:0] reg_temp [0:4];
    wire [31:0] q_bit;

    //---------------------------------------
    // ========== PHASE 0 ==========
    //---------------------------------------
    sub_proc s00(x_extended[62:31], y_extended, x_extended[30], out_temp[0], q_bit[31]);
    sub_proc s01(out_temp[0],      y_extended, x_extended[29], out_temp[1], q_bit[30]);
    sub_proc s02(out_temp[1],      y_extended, x_extended[28], out_temp[2], q_bit[29]);

    register #(32) r0(out_temp[2], clk, rs, ld1, reg_temp[0]);

    //---------------------------------------
    // ========== PHASE 1 ==========
    //---------------------------------------
    sub_proc s10(reg_temp[0], y_extended, x_extended[27], out_temp[3], q_bit[28]);
    sub_proc s11(out_temp[3], y_extended, x_extended[26], out_temp[4], q_bit[27]);
    sub_proc s12(out_temp[4], y_extended, x_extended[25], out_temp[5], q_bit[26]);

    register #(32) r1(out_temp[5], clk, rs, ld2, reg_temp[1]);

    //---------------------------------------
    // ========== PHASE 2 ==========
    //---------------------------------------
    sub_proc s20(reg_temp[1], y_extended, x_extended[24], out_temp[6], q_bit[25]);
    sub_proc s21(out_temp[6], y_extended, x_extended[23], out_temp[7], q_bit[24]);
    sub_proc s22(out_temp[7], y_extended, x_extended[22], out_temp[8], q_bit[23]);

    register #(32) r2(out_temp[8], clk, rs, ld3, reg_temp[2]);

    //---------------------------------------
    // ========== PHASE 3 ==========
    //---------------------------------------
    sub_proc s30(reg_temp[2], y_extended, x_extended[21], out_temp[9],  q_bit[22]);
    sub_proc s31(out_temp[9], y_extended, x_extended[20], out_temp[10], q_bit[21]);
    sub_proc s32(out_temp[10],y_extended, x_extended[19], out_temp[11], q_bit[20]);

    register #(32) r3(out_temp[11], clk, rs, ld4, reg_temp[3]);

    //---------------------------------------
    // ========== PHASE 4 ==========
    //---------------------------------------
    sub_proc s40(reg_temp[3], y_extended, x_extended[18], out_temp[12], q_bit[19]);
    sub_proc s41(out_temp[12],y_extended, x_extended[17], out_temp[13], q_bit[18]);
    sub_proc s42(out_temp[13],y_extended, x_extended[16], out_temp[14], q_bit[17]);

    register #(32) r4(out_temp[14], clk, rs, ld5, reg_temp[4]);

    //---------------------------------------
    // Last bit
    //---------------------------------------
    sub_proc s50(reg_temp[4], y_extended, x_extended[15], out_temp[15], q_bit[16]);
    assign q_bit[15:0] = 16'b0;
    //---------------------------------------
    // Output
    //---------------------------------------
    assign Q = q_bit >> 1;

    //---------------------------------------
    // FSM
    //---------------------------------------
    fast_divider_fsm fsm(
        clk, rs, start,
        ld1, ld2, ld3, ld4, ld5,
        done
    );

endmodule
