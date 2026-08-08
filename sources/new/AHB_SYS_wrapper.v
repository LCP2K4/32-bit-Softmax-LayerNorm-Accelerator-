//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
//Date        : Mon May 25 17:17:48 2026
//Host        : LAPTOP-U8HBSPLS running 64-bit major release  (build 9200)
//Command     : generate_target AHB_SYS_wrapper.bd
//Design      : AHB_SYS_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module AHB_SYS_wrapper
   (CLK);
  input CLK;

  wire CLK;

  AHB_SYS AHB_SYS_i
       (.CLK(CLK));
endmodule
