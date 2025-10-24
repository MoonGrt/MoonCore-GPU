// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3_AR71948_AR71948 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Apr  8 19:21:26 2024
// Host        : DESKTOP-HAJLRPS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               F:/ZYNQ_Project/BX71/BX71_Linux_HDMI_Factory/ACZ7015_Linux_Factory.srcs/sources_1/bd/system/ip/system_rgb565to888_0_0/system_rgb565to888_0_0_stub.v
// Design      : system_rgb565to888_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "rgb565to888,Vivado 2018.3_AR71948_AR71948" *)
module system_rgb565to888_0_0(m_clk, s_clk, s_axis_tdata, s_axis_tlast, 
  s_axis_tready, s_axis_tuser, s_axis_tvalid, m_axis_tdata, m_axis_tlast, m_axis_tready, 
  m_axis_tuser, m_axis_tvalid)
/* synthesis syn_black_box black_box_pad_pin="m_clk,s_clk,s_axis_tdata[15:0],s_axis_tlast,s_axis_tready,s_axis_tuser,s_axis_tvalid,m_axis_tdata[23:0],m_axis_tlast,m_axis_tready,m_axis_tuser,m_axis_tvalid" */;
  input m_clk;
  input s_clk;
  input [15:0]s_axis_tdata;
  input s_axis_tlast;
  output s_axis_tready;
  input s_axis_tuser;
  input s_axis_tvalid;
  output [23:0]m_axis_tdata;
  output m_axis_tlast;
  input m_axis_tready;
  output m_axis_tuser;
  output m_axis_tvalid;
endmodule
