`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2026 03:15:57 PM
// Design Name: 
// Module Name: AHB_ACCER
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


module AHB_ACCER(
    
    //MASTER
    output wire [31:0] HADDRM,
//    output wire [ 2:0] HSIZEM,
    output wire [ 1:0] HTRANSM,
    output wire [31:0] HWDATAM,
    output wire        HWRITEM,
    //SLAVE
    input  wire        HCLK,
    input  wire        HRESETn,
    input  wire [31:0] HADDR,
    input  wire [1:0]  HTRANS,
    input  wire [31:0] HWDATA,
    input  wire        HWRITE,
    input  wire        HSEL,
    input  wire        HREADY,
    
    output wire        HREADYOUT,
    output reg  [31:0] HRDATA,
    
    //output to Accer
    
    output [31:0] X,
    output [31:0] addr,
    output [31:0] value_out,
    output valid_o,
    //output to AHB
    output fdone
        
    );
    typedef enum {S0,S1,S2,S3,S4,S5,S6} state_s;
    state_s state, next_state;
    
    localparam [7:0] CTRL_ADDR = 8'h00; //1 start
    localparam [7:0] MEM_ADDR = 8'h04; // adress of first data we need in memory
    localparam [7:0] MODE_ADDR = 8'h08; // mode of accelerator
    localparam [7:0] ROW_ADDR = 8'h0C; // row matrix
    localparam [7:0] COL_ADDR = 8'h10; // collumn matrix
    
//    reg [31:0] X;
    reg [31:0] r_HADDR;
    reg        r_HWRITE;
    reg        r_HSEL;
    
    reg [31:0] ctrl,mem,mode,data,row,col;
    reg [31:0] counter;
    
    wire lock;
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            r_HADDR  <= 32'h0;
            r_HWRITE <= 1'b0;
            r_HSEL   <= 1'b0;
        end else if (HREADY) begin 
            r_HADDR  <= HADDR;
            r_HWRITE <= HWRITE;
            r_HSEL   <= HSEL & HTRANS[1]; 
        end
    end
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            ctrl <= 32'h2;
            mem  <= 32'h0;
            row  <= 32'h0;
            col  <= 32'h0;
            mode <= 32'h0;
        end else if (r_HSEL && r_HWRITE && HREADY) begin
            case (r_HADDR[7:0])
                CTRL_ADDR: ctrl <= HWDATA;
                MODE_ADDR: mode <= HWDATA;
                MEM_ADDR:  mem  <= HWDATA;
                ROW_ADDR:  row  <= HWDATA;
                COL_ADDR:  col  <= HWDATA;
            endcase
        end 
    end

    assign HREADYOUT = 1'b1;
    assign HADDRM  = 32'b0;
    assign HTRANSM = 2'b00;
    assign HWDATAM = 32'b0;
    assign HWRITEM = 1'b0;    
    accelerator_interface 
    #(32,1
    ) acc
   (
    .start(ctrl[0]),
    .mode(mode[0]), // mode 0 Softmax (in process) mode 1 LayerNorm(undeveloped)
    .X(X),
    .col_len(col),
    .row_len(row),
    .clk(HCLK),.rs(ctrl[1]),
    .Y(value_out),
    .addr(addr),
    .valid_o(valid_o),
    .fdone(fdone),
    .lock(lock)
    );
    
    SRAM rom(
        .clk(HCLK),
        .rs(ctrl[1]),
        .en(lock),
        .addr(addr + mem),
        .dout(X)
    );   
endmodule
