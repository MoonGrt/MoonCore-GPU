`timescale 1ns / 1ps

module Disp_PLL (
    input wire clk,  // 时钟
    input wire rstn, // 复位，低电平有效

    output wire lcd_clk,     // LCD 时钟
    output wire lcd_rstn,    // LCD 复位，低电平有效
    output wire vga_clk,     // VGA 时钟
    output wire vga_rstn,    // VGA 复位，低电平有效
    output wire hdmi_clk,    // HDMI 时钟
    output wire hdmi_clk_x5, // HDMI 时钟 x5
    output wire hdmi_rstn,   // HDMI 复位，低电平有效
    output wire mipi_clk,    // MIPI 时钟
    output wire mipi_rstn,   // MIPI 复位，低电平有效
    output wire spilcd_clk,  // SPI LCD 时钟
    output wire spilcd_rstn  // SPI LCD 复位，低电平有效
);

    assign lcd_clk = clk;
    assign hdmi_clk_x5 = clk;
    assign lcd_rstn = rstn;
    assign vga_clk = clk;
    assign vga_rstn = rstn;
    assign hdmi_clk = clk;
    assign hdmi_rstn = rstn;
    assign mipi_clk = clk;
    assign mipi_rstn = rstn;
    assign spilcd_clk = clk;
    assign spilcd_rstn = rstn;

endmodule
