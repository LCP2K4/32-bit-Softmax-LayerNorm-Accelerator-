`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 10:32:20 PM
// Design Name: 
// Module Name: accelerator_interface
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


module accelerator_interface 
    #(parameter N = 32,
      parameter M = 1
    )
   (
    input start,
    input mode, // mode 0 Softmax (in process) mode 1 LayerNorm(undeveloped)
    input clk, rs,
    output reg [N-1:0] Y,
    output [N - 1 : 0] dut,
    output reg done,
    output check
    );
    
    wire [N-1:0] X[M - 1 : 0];
    wire [M - 1:0] valid,done_input;
    genvar i;
    wire [M-1 : 0] done_output;
    wire [M-1 : 0] done_value;
    wire [N - 1 : 0] Pe_out [M-1 : 0];
    wire [N - 1 : 0] s1 [(M-1)/2 : 0];
    wire [N - 1 : 0] s2[(M-1)/4 : 0];
    wire [N - 1 : 0] s3;
    wire [N - 1 : 0] temp,sqrt_temp;
    reg access_acc,end_proc; 
    reg access_sqrt;
   //PE wire
   wire lock2;
   //SQRT wire
   
    reg sqrt_start;
    
    
    wire done_sqrt;
    //MUX21 sl
    wire val_sl,done_sl,counter_sl;
    //COUNTER WIRE
    wire [6 : 0] laddr;
    //BRAM WIRE
    wire valout,endout;
    wire [N-1 : 0] dout ;
    reg [N-1:0] dout_d;
    reg val_d, end_d;
    reg done_d,done_o;
    
    // ACCUMULATOR WIRE
    wire [N-1:0] counter;
    wire acc_done;
    //
    reg [N-1 : 0] div_result;
    //FSM wire
    wire rs_dp, rs_pe;
    wire rw,mode_ld,mode_sl,lock,mux_ld,sqrt_ld,mean_ld;
    wire cnt_ld,final_ld;
    wire [1:0] phase;
    
    
    //SRAM for initial input value
    SRAM rom(
        .clk(clk),
        .rs(rs_dp),
        .en(lock & lock2),
        .addr({3'b000,laddr} + offset),
        .dout(X[0]),
        .valid(valid),
        .end_d(done_input)
    );
    
    reg [N-1 :0] offset = 32'b0; 
    always @(posedge clk or posedge rs) begin
        if(rs) offset <= 32'b0; 
        else if(done) offset <= offset + counter;
    end
    // FSM
    accelarator_fsm fsm(
        .clk(clk),.rs(rs),.start(start),
        .mode(mode),
        .pe_done(end_proc),
        .acc_done(acc_done),
        .div_done(done_sqrt),
        .mean_ld(mean_ld),
        .rs_pe(rs_pe),
        .rs_dp(rs_dp),
        .mode_ld(mode_ld),
        .mode_sl(mode_sl),
        .lock(lock),
        .rw(rw),
        .mux_ld(mux_ld), 
        .sqrt_ld(sqrt_ld),
        .mux_sl(phase),
        .done(done),
        .check(check) 
    );
    // ADRESS GNERATOR MODULE
    assign cnt_ld = lock;
    assign counter_sl = (phase == 2'b00) ? (lock) : cnt_ld;
    counter_nbit #(7,1) cnt(clk,rs_pe,counter_sl,done_output[0],laddr);
    // BRAM module
    always @(posedge clk or posedge rs_pe) begin
        if(rs_pe) begin
            dout_d <= 32'b0;
            X_temp <= 32'b0;
            Pe_temp <= 32'b0;
        end
        else begin
            dout_d <= dout;
            X_temp <= X[0];
            Pe_temp <= Pe_out[0];
        end
    end
     bram #(N) ram(
        .clk(clk), 
        .rs(rs_dp),
        .din(Pe_out[0]),
        .val_in(done_value[0]),
        .end_in(done_output[0]),
        .addr({3'b000,laddr}),
        .en((done_value[0]) | ~rw), 
        .rw(rw), //rw = 1 write rw = 0 read
        .dout(dout),
        .val_out(valout),
        .end_out(endout));
    // PE module
     assign val_sl = (phase == 2'b00 || phase == 2'b01) ? (valid[0]) : valout;
     assign done_sl = (phase == 2'b00 || phase == 2'b01) ? done_input[0] : endout;
     reg [N-1 : 0] X_temp,Pe_temp;
generate
    for(i = 0; i < M; i ++) begin : pe_proc
        PE_Interface pe(
            .X(X_temp),
            .div_result(div_result),
            .mem(dout_d),
            .clk(clk), 
            .rs(rs_pe), 
            .valid(val_sl), 
            .done_input(done_sl),
            
            .mode_ld(mode_ld),
            .mean_ld(mean_ld),
            
            .lock(lock),
            .phase(phase),
            
            .Pe_out(Pe_out[i]),
            .dut(),
            .done_value(done_value[i]),
            .done_output(done_output[i]),
            .lock2(lock2)
            );
    end
    
    // adder tree module
//    for(i = 0; i < M/2; i ++) begin : lv1
//        assign s1[i] =  Pe_out[2*i] + Pe_out[2*i + 1];
//    end
//    for(i = 0; i < 2; i ++) begin : lv2
//        assign s2[i] =  s1[2*i] + s1[2*i + 1];
//    end
endgenerate
//    assign s3 = s2[0] + s2[1];
    reg done_val_lv1,end_proc_lv1; 
    assign    access_acc  = done_value[0];
    assign    end_proc  = done_output;

    
    // Accumulator module
    Accumulator Acc(
                    .add_in(Pe_out[0]),
                    .clk(clk),
                    .rs(rs_dp),
                    .rs_pe(rs_pe),
                    .ld(access_acc),
                    .end_proc(end_proc),
                    .div_done(done_sqrt),
                    .accum_out(temp),
                    .counter(counter),
                    .acc_done(acc_done));

//    always @(posedge clk or posedge rs) begin
//        if(rs) access_sqrt <= 1'b0;
//        else access_sqrt <= end_proc;
//    end
    wire [31:0] o_check;
    //SQRT MODULE
    sqrt_interface sqrt(.A(temp),
                        .SUM(counter << 20),
                        .clk(clk),
                        .reset(rs_dp),   
                        .start(sqrt_ld),
                        .phase(phase),   // select mode 0: for softmax, 1: for LayerNorm
                        .mode_sl(mode_sl),
                        .O(div_result),
                        .o_check(o_check),
                        .n_flag(),        //check negative (not used)
                        .done(done_sqrt));
   always @(posedge clk or posedge rs) begin
        if(rs) Y <= 0;
        else begin
//           if((phase == 2'b11) & done_value[0])     
           Y <= Pe_out[0] << 6;
           
        end
   end  
   assign dut = X[0];
endmodule
