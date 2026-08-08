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
#(
    parameter N=32,
    parameter M=1
)
(
    input start,
    input mode,
    input [N-1:0] X,
    input [N-1:0] col_len,
    input [N-1:0] row_len,
    input clk,
    input rs,

    output reg [N-1:0] Y,
    output reg [N-1:0] addr,
    output reg valid_o,
    output fdone,
    output reg lock
);

/////////////////////////////////////////////////
// INTERNAL SIGNALS
/////////////////////////////////////////////////

genvar i;

wire [M-1:0] done_output;
wire [M-1:0] done_value;

wire [N-1:0] Pe_out[M-1:0];

wire [N-1:0] temp;

wire access_acc;
wire end_proc;

reg [N-1:0] X_temp;
reg [N-1:0] X_in;
reg [N-1:0] Pe_temp;

reg [N-1:0] offset;

wire done_sqrt;

wire valid;
wire end_col;
wire row_done;

wire val_sl;
wire done_sl;
wire counter_sl;

wire [9:0] laddr;

wire valout;
wire endout;
wire [N-1:0] dout;

reg [N-1:0] dout_d;
reg [N-1:0] dout_in;

wire [N-1:0] counter;
wire acc_done;

wire [N-1:0] div_result;

wire rs_dp;
wire rs_pe;

wire rw;
wire mode_ld;
wire mode_sl;
wire mux_ld;
wire sqrt_ld;
wire mean_ld;

wire cnt_ld;
wire final_ld;

wire [1:0] phase;
wire done;

/////////////////////////////////////////////////
// ADDRESS GENERATOR
/////////////////////////////////////////////////

always @(posedge clk)
begin
    if(rs)
        addr<=0;

    else if(fdone)
        addr<=0;

    else if(lock)
        addr<=laddr+offset;
end


always @(posedge clk)
begin

    if(rs)
        offset<=0;

    else if(fdone)
        offset<=0;

    else if(done)
        offset<=offset+counter;

end

/////////////////////////////////////////////////
// FSM
/////////////////////////////////////////////////

accelarator_fsm fsm
(
    .clk(clk),
    .rs(rs),
    .start(start),

    .mode(mode),

    .pe_done(end_proc),
    .acc_done(acc_done),
    .div_done(done_sqrt),
    .row_done(row_done),

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
    .fdone(fdone)
);

/////////////////////////////////////////////////
// ADDRESS COUNTER
/////////////////////////////////////////////////

assign counter_sl=lock;

counter_nbit #(10,1)
cnt
(
    clk,
    rs_pe,
    counter_sl,
    done_output[0],
    laddr
);

/////////////////////////////////////////////////
// PIPELINE REGISTER
/////////////////////////////////////////////////

always @(posedge clk)
begin

    if(rs_pe)
    begin
        dout_d<=0;
        X_temp<=0;
        Pe_temp<=0;
    end

    else
    begin
        dout_d<=dout;
        X_temp<=X;
        Pe_temp<=Pe_out[0];
    end

end


always @(posedge clk or posedge rs_pe)
begin

    if(rs_pe)
    begin
        dout_in<=0;
        X_in<=0;
    end

    else if(lock)
    begin
        dout_in<=dout_d;
        X_in<=X_temp;
    end

end


/////////////////////////////////////////////////
// BRAM
/////////////////////////////////////////////////

bram #(N)
ram
(
    .clk(clk),
    .rs(rs_dp),

    .din(Pe_out[0]),

    .val_in(done_value[0]),
    .end_in(done_output[0]),

    .addr(laddr),

    .en(done_value[0] | ~rw),

    .rw(rw),

    .dout(dout),
    .val_out(valout),
    .end_out(endout)
);

/////////////////////////////////////////////////
// CONFIG MODULE
/////////////////////////////////////////////////

config_module #(N)
cfg
(
    .clk(clk),
    .rs_dp(rs_dp),
    .rs_pe(rs_pe),

    .lock(lock),
    .done(done),

    .phase(phase),

    .laddr(laddr),

    .col_len(col_len),
    .row_len(row_len),

    .valout(valout),
    .endout(endout),

    .valid(valid),
    .end_col(end_col),

    .row_done(row_done),

    .val_sl(val_sl),
    .done_sl(done_sl)
);

/////////////////////////////////////////////////
// PE
/////////////////////////////////////////////////

generate

for(i=0;i<M;i=i+1)
begin: pe_proc

PE_Interface pe
(
    .X(X_temp),

    .div_result(div_result),

    .mem(dout_in),

    .clk(clk),
    .rs(rs_pe),

    .valid(val_sl),
    .done_input(done_sl),

    .mode_ld(mode),
    .mean_ld(mean_ld),

    .lock(lock),

    .phase(phase),

    .Pe_out(Pe_out[i]),

    .done_value(done_value[i]),
    .done_output(done_output[i])
);

end

endgenerate


assign access_acc=done_value[0];
assign end_proc=done_output[0];

/////////////////////////////////////////////////
// ACCUMULATOR
/////////////////////////////////////////////////

Accumulator Acc
(
    .add_in(Pe_out[0]),

    .clk(clk),

    .rs(rs_dp),
    .rs_pe(rs_pe),

    .ld(access_acc),

    .end_proc(end_proc),

    .accum_out(temp),

    .counter(counter),

    .acc_done(acc_done)
);

/////////////////////////////////////////////////
// SQRT
/////////////////////////////////////////////////

wire [31:0] o_check;

sqrt_interface sqrt
(
    .A(temp),

    .SUM(counter<<20),

    .clk(clk),

    .reset(rs_dp),

    .start(sqrt_ld),

    .phase(phase),

    .mode_sl(mode_sl),

    .O(div_result),

    .o_check(o_check),

    .n_flag(),

    .done(done_sqrt)
);

/////////////////////////////////////////////////
// OUTPUT
/////////////////////////////////////////////////

always @(posedge clk)
begin

    if(rs)
    begin
        Y<=0;
        valid_o<=0;
    end

    else
    begin

        if(done)
        begin
            Y<=0;
            valid_o<=0;
        end

        else if((phase==2'b11)&&(done_value[0]))
        begin
            Y<=Pe_out[0]<<6;
            valid_o<=done_value[0];
        end

    end

end

endmodule