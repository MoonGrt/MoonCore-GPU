`timescale 1ns / 1ps

module Disp_PLL (
    input wire clk,  // ʱ��
    input wire rstn, // ��λ���͵�ƽ��Ч

    output wire lcd_clk,     // LCD ʱ��
    output wire lcd_rstn,    // LCD ��λ���͵�ƽ��Ч
    output wire vga_clk,     // VGA ʱ��
    output wire vga_rstn,    // VGA ��λ���͵�ƽ��Ч
    output wire hdmi_clk,    // HDMI ʱ��
    output wire hdmi_clk_x5, // HDMI ʱ�� x5
    output wire hdmi_rstn,   // HDMI ��λ���͵�ƽ��Ч
    output wire mipi_clk,    // MIPI ʱ��
    output wire mipi_rstn,   // MIPI ��λ���͵�ƽ��Ч
    output wire spilcd_clk,  // SPI LCD ʱ��
    output wire spilcd_rstn  // SPI LCD ��λ���͵�ƽ��Ч
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
