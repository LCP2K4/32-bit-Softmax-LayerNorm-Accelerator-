`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 04:53:04 PM
// Design Name: 
// Module Name: config_module
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


module config_module
#(
    parameter N=32
)
(
    input clk,
    input rs_dp,
    input rs_pe,

    input lock,
    input done,

    input [1:0] phase,

    input [9:0] laddr,
    input [N-1:0] col_len,
    input [N-1:0] row_len,

    input valout,
    input endout,

    output reg valid,
    output reg end_col,

    output reg row_done,

    output reg val_sl,
    output reg done_sl
);

reg [N-1:0] row_count;


always @(posedge clk or posedge rs_pe)
begin
    if(rs_pe)
    begin
        valid<=0;
        end_col<=0;
    end
    else if(lock)
    begin
        valid<=1'b1;

        if(laddr==(col_len-1))
            end_col<=1'b1;
        else
            end_col<=1'b0;
    end
end

always @(posedge clk)
begin
    if(rs_dp)
        row_count<=0;

    else if(done)
        row_count<=row_count+1;
end


always @(posedge clk)
begin
    if(rs_dp)
        row_done<=0;

    else if(row_count==(row_len-1))
        row_done<=1'b1;
end



always @(posedge clk)
begin
    if(rs_dp)
    begin
        val_sl<=0;
        done_sl<=0;
    end
    else
    begin
        if((phase==2'b00)||(phase==2'b01))
        begin
            val_sl<=valid;
            done_sl<=end_col;
        end
        else
        begin
            val_sl<=valout;
            done_sl<=endout;
        end
    end
end

endmodule