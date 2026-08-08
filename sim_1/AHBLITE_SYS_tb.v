`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 02:57:12 PM
// Design Name: 
// Module Name: AHBLITE_SYS_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for AHBLITE_SYS
// 
//////////////////////////////////////////////////////////////////////////////////

module AHBLITE_SYS_tb(); 

    reg CLK;
    reg RESET;
    
    wire [31:0] value_out;
    wire        valid_o;  
    wire        fdone;
    wire [9:0]  addr,accaddr;

    integer file_id = 0;


    // DUT
    AHBLITE_SYS dut(
        .CLK(CLK),
        .RESET(RESET),
        .value_out(value_out),
        .addr(addr),
        .accaddr(accaddr),
        .valid_o(valid_o),        
        .fdone(fdone)
    );
    
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        RESET = 1;
        #50;
        RESET = 0;
    end

    initial begin
        file_id = $fopen("output.hex", "w");
        if (!file_id) begin
            $display("ERROR: Cannot open output.hex!");
            $finish;
        end
    end
    

    always @(posedge CLK) begin


        if (valid_o && file_id) begin
            $fdisplay(file_id, "%h", value_out);
            $display("Time %0t: WRITE %h", $time, value_out);
        end
    end
    

    initial begin
        wait(fdone == 1);
        #20; 


        if (file_id) begin 
            $fclose(file_id);
            file_id = 0;
        end

        $display("Done.");
        $finish;
    end

 
    always @(posedge CLK) begin
        $display("T=%0t | valid=%b | fdone=%b | value=%h", 
                  $time, valid_o, fdone, value_out);
    end

endmodule