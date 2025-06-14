`timescale 1ns / 1ps

module top (
    input wire clk,  // 时钟
    input wire rstn  // 复位，低电平有效
);

    // BRAM Parameters
    parameter DP = 135 * 240;
    parameter DW = 24;
    parameter MW = DW / 8;
    parameter AW = $clog2(DP);
    // BRAM Inputs
    reg           we = 0;
    reg  [DW-1:0] wdata = 0;
    reg  [MW-1:0] sel = {MW{1'b1}};

    // Display Inputs
    wire [  23:0] spilcd_pixel_data;
    wire          spilcd_pixel_valid;
    // Display Outputs
    wire [AW-1:0] spilcd_pixel_addr;
    wire          lcd_hs;
    wire          lcd_vs;
    wire          lcd_en;
    wire [  23:0] lcd_data;
    wire          vga_hs;
    wire          vga_vs;
    wire          vga_en;
    wire [  23:0] vga_data;
    wire          hdmi_tmds_clk_p;
    wire          hdmi_tmds_clk_n;
    wire [   2:0] hdmi_tmds_data_p;
    wire [   2:0] hdmi_tmds_data_n;
    wire          hdmi_tmds_oen;
    wire          spilcd_resetn;
    wire          spilcd_clk;
    wire          spilcd_cs;
    wire          spilcd_rs;
    wire          spilcd_data;
    wire          spilcd_bl;


    BRAM #(
        .DP(DP),
        .DW(DW)
    ) BRAM (
        .clk   (clk),
        .rst   (~rstn),
        .addr  (spilcd_pixel_addr),
        .wdata (data),
        .sel   (sel),
        .we    (data_valid),
        .rdata (spilcd_pixel_data),
        .rvalid(spilcd_pixel_valid)
    );

    Display Display (
        .clk (clk),
        .rstn(rstn),

        // LCD
        .lcd_hs  (lcd_hs),
        .lcd_vs  (lcd_vs),
        .lcd_en  (lcd_en),
        .lcd_data(lcd_data),

        // VGA
        .vga_hs  (vga_hs),
        .vga_vs  (vga_vs),
        .vga_en  (vga_en),
        .vga_data(vga_data),

        // HDMI
        .hdmi_tmds_clk_p (hdmi_tmds_clk_p),
        .hdmi_tmds_clk_n (hdmi_tmds_clk_n),
        .hdmi_tmds_data_p(hdmi_tmds_data_p),
        .hdmi_tmds_data_n(hdmi_tmds_data_n),
        .hdmi_tmds_oen   (hdmi_tmds_oen),

        // SPI LCD
        .spilcd_pixel_data (spilcd_pixel_data),
        .spilcd_pixel_valid(spilcd_pixel_valid),
        .spilcd_pixel_addr (spilcd_pixel_addr),
        .spilcd_resetn     (spilcd_resetn),
        .spilcd_clk        (spilcd_clk),
        .spilcd_cs         (spilcd_cs),
        .spilcd_rs         (spilcd_rs),
        .spilcd_data       (spilcd_data),
        .spilcd_bl         (spilcd_bl)
    );


endmodule
