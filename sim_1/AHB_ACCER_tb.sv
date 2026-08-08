`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 10:15:45 AM
// Design Name: 
// Module Name: AHB_ACCER_tb
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

module AHB_ACCER_tb;

    reg          HCLK;
    reg          HRESETn;

    reg [31:0]   HADDR;
    reg [1:0]    HTRANS;
    reg [31:0]   HWDATA;
    reg          HWRITE;
    reg          HSEL;
    reg          HREADY;


    wire [31:0]  X;
    wire [9:0]   addr;
    wire [31:0]  value_out;
    wire         done;
    wire         fdone;
    
    integer file_id = 0;

    // DUT
    AHB_ACCER dut (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HADDR(HADDR),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HSEL(HSEL),
        .HREADY(HREADY),
        .X(X),
        .addr(addr),
        .value_out(value_out),
        .valid_o(done),     
        .fdone(fdone)        
    );

    always #5 HCLK = ~HCLK;

    task ahb_write(input [31:0] addr, input [31:0] data);
    begin
        @(posedge HCLK);
        HADDR  <= addr;
        HWRITE <= 1;
        HSEL   <= 1;
        HTRANS <= 2'b10;
        HREADY <= 1;

        @(posedge HCLK);
        HWDATA <= data;  
        HSEL   <= 0;
        HWRITE <= 0;
        HTRANS <= 2'b00;
    end
    endtask


    initial begin

        file_id = $fopen("output.hex", "w");
        if (!file_id) begin
            $display("ERROR: Cannot open output.hex!");
            $finish;
        end

        HCLK    = 0;
        HRESETn = 0;
        HADDR   = 0;
        HTRANS  = 0;
        HWDATA  = 0;
        HWRITE  = 0;
        HSEL    = 0;
        HREADY  = 1;


        #20;
        HRESETn = 1;
        @(posedge HCLK);

        ahb_write(32'h08, 32'h1);     // mode MODE = 0 = Softmax MODE = 1 LayerNorm
        ahb_write(32'h0C, 32'd128);    // row
        ahb_write(32'h10, 32'd128);    // col
        ahb_write(32'h04, 32'h0);     // mem addr


        ahb_write(32'h00, 32'h1);     // ctrl start
    end


    always @(posedge HCLK) begin
        if (HRESETn && done && file_id) begin
            $fdisplay(file_id, "%h", value_out);
            $display("Time %0t: WRITE %h", $time, value_out);
        end
    end


    initial begin

        wait(fdone == 1'b1);
        repeat(2) @(posedge HCLK);
        $display("-----------------------------------------------------");
        $display("SUCCESS: fdone detected at %0t ns.", $time);
        $display("Closing output.hex and finishing simulation normally.");
        $display("-----------------------------------------------------");

        if (file_id) begin 
            $fclose(file_id);
            file_id = 0;
        end
        $finish;
    end

    initial begin
        $monitor("Time=%0t | addr=%d | value=%h | valid_o=%b | fdone=%b",
                 $time, addr, value_out, done, fdone);
    end

endmodule