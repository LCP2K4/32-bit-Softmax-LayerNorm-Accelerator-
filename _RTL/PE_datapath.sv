`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 08:15:27 AM
// Design Name: 
// Module Name: PE_datapath
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


module PE_datapath#(parameter N = 32)(
    input [N - 1 : 0] X, div_result,mem,
    input clk, rs,
    input valid,done_input,
    
    
    input mode_ld,
    input mean_ld,
    
    input lock,
    input [1:0] phase,
    
    output [N - 1 : 0] Exp_Out, dut,
    output reg done_value, done_output,lock2
    );
    reg [3:0] done_reg;
    wire cout;
    reg ld,premul_ld,mul_ld,exp_ld;
    wire [N - 1 : 0] X_temp,X_shift, W_temp,B_temp, B_add,W,B,Mul_in1,Mul_in2,add_temp,sub_temp;
    wire [N-1:0] div_result_temp;
    wire [2 * N - 1 : 0] Mul_temp;
    wire [N-1 : 0] Mul_in1_temp, Mul_in2_temp, B_temp_lv2;
    reg [N - 1 : 0] Mul_out;
    reg [N - 1 : 0] Exp_temp;
    wire [N - 1 : 0] X_in,W_in,B_in,mux2_temp;
    

    //lv1 pipeline
    always @(posedge clk or posedge rs) begin
        if(rs) begin 
            done_reg <= 4'b0;
            ld <= 1'b0;
            lock2 = 1'b1;
            premul_ld <= 1'b0;
            mul_ld <= 1'b0;
            exp_ld <= 1'b0;
        end
        else begin
            if(done_input) lock2 <= 1'b0;
            done_reg[0] <= done_input;
            done_reg[1] <= done_reg[0];
            done_reg[2] <= done_reg[1];
            done_reg[3] <= done_reg[2];
            ld <= valid & lock;
            premul_ld <= ld ;
            mul_ld <= premul_ld ;
            exp_ld <= mul_ld;
        end       
    end
//    always @(*) begin
//        if(rs) lock2 = 1'b1;
//        else if(done_input) lock2 = 1'b0;
//    end
 //   assign ld = valid & lock;
    //MOUDULE X
    mux_4_1 #(32) muxx(
    .A(X),.B(X),.C(div_result<<6),.D(div_result<<6),
//    .clk(clk),.rs(rs),.en(mux_ld),
    .sel(phase),
    .O(X_in)
    );
    register #(N) rex(X_in,clk,rs,ld,X_temp);
    assign X_shift = $signed(X_temp) >>> 6;
    Exp_Mem #(N) exp(X_in,W,B);
   
    // MODULE W
    mux_4_1 #(32) muxw(
    .A(W),.B(mem),.C(mem),.D(mem),
//    .clk(clk),.rs(rs),.en(mux_ld),
    .sel(phase),
    .O(W_in)
    );
    register #(N) rew(W_in,clk,rs,ld,W_temp);
    
    //MODULE B
    mux_4_1 #(32) muxb(
    .A(B),.B(32'b0),.C(32'b0),.D(32'b0),
//    .clk(clk),.rs(rs),.en(mux_ld),
    .sel(phase),
    .O(B_in)
    );
    register #(N) reb(B_in,clk,rs,ld,B_temp);
    
    // MODULE STORE MEAN
    
    register #(N) remean(div_result,clk,1'b0,mean_ld,div_result_temp);
    
    //SUBTRACTOR
    assign sub_temp = W_temp - div_result_temp ;
    mux_2_1 mux2(W_temp,sub_temp,mode_ld,mux2_temp);
    //LV2 pipeline
//    always @(posedge clk) begin
//        premul_ld <= ld ;
//    end 
    
    // MUX for choose multiplication input
    mux_4_1 #(N) mux_mul1(X_shift,X_shift,sub_temp,X_shift,phase,Mul_in1);
    mux_4_1 #(N) mux_mul2(W_temp,32'h00100000,sub_temp,mux2_temp,phase,Mul_in2);
    register #(N) remul1(Mul_in1,clk,rs,premul_ld,Mul_in1_temp);
    register #(N) remul2(Mul_in2,clk,rs,premul_ld,Mul_in2_temp);
    register #(N) reblv2(B_temp,clk,rs,premul_ld,B_temp_lv2);
    // MULTIPLIER
//    Booth_4 #(N) bo4(Mul_in1_temp,Mul_in2_temp,Mul_temp);
    assign Mul_temp = Mul_in1_temp * Mul_in2_temp;
    //lv3 pipeline
//    always @(posedge clk) begin
//        mul_ld <= premul_ld ;
//    end
    register #(N) reb1(B_temp_lv2,clk,rs,mul_ld,B_add);
    register #(N) mul(Mul_temp[51 : 20],clk,rs, mul_ld, Mul_out);
    cla_32bit cla(Mul_out,B_add,1'b0,add_temp,cout);
    
    //lv4 pipeline

//    always @(posedge clk) begin
//        exp_ld <= mul_ld;
//    end
    register #(N) reexp({cout,add_temp},clk,rs,exp_ld,Exp_temp);
    assign Exp_Out = $signed(Exp_temp);
    assign dut = div_result;
    always @(posedge clk) begin
        done_value <=   exp_ld;
        done_output <= done_reg[3];
    end
endmodule
