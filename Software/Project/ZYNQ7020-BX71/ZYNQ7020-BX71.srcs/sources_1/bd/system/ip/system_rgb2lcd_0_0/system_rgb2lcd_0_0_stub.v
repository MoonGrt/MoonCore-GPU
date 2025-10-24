// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Apr  7 11:25:28 2024
// Host        : Holden running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/maxhy/Downloads/Compressed/ACZ7015_Linux_Factory/ACZ7015_Linux_Factory.srcs/sources_1/bd/system/ip/system_rgb2lcd_0_0/system_rgb2lcd_0_0_stub.v
// Design      : system_rgb2lcd_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "rgb2lcd,Vivado 2018.3" *)
module system_rgb2lcd_0_0(rgb_data_in, rgb_vde, rgb_hsync, rgb_vsync, 
  pixel_clk, rst_n, lcd_pclk, lcd_rstn, lcd_hs, lcd_vs, lcd_de, lcd_bl, data)
/* synthesis syn_black_box black_box_pad_pin="rgb_data_in[23:0],rgb_vde,rgb_hsync,rgb_vsync,pixel_clk,rst_n,lcd_pclk,lcd_rstn,lcd_hs,lcd_vs,lcd_de,lcd_bl,data[15:0]" */;
  input [23:0]rgb_data_in;
  input rgb_vde;
  input rgb_hsync;
  input rgb_vsync;
  input pixel_clk;
  input rst_n;
  output lcd_pclk;
  output lcd_rstn;
  output lcd_hs;
  output lcd_vs;
  output lcd_de;
  output lcd_bl;
  output [15:0]data;
endmodule
