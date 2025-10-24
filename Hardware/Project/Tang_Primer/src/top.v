`timescale 1ns / 1ps

module top (
    input wire clk,  // 时钟
    input wire rstn, // 复位，低电平有效

    output wire spilcd_rstn,
    output wire spilcd_clk,
    output wire spilcd_cs,
    output wire spilcd_rs,
    output wire spilcd_data,
    output wire spilcd_bl
);

    // BRAM Parameters
    parameter FILE_BASE = "F:/Project/FPAG/Project/GPU/MoonCore-GPU/Tool/init_ram";
    parameter DP = 135 * 240;
    parameter DW = 8;
    parameter MW = DW / 8;
    parameter AW = $clog2(DP) - 1;
    parameter N = 3;
    parameter BDW = DW * N - 1;
    // BRAM Inputs
    reg           we = 0;
    reg  [DW-1:0] wdata = 0;
    reg  [MW-1:0] sel = {MW{1'b1}};

    // Display Inputs
    wire          spilcd_pixel_valid;
    wire [ BDW:0] spilcd_pixel_data;
    wire [  AW:0] spilcd_pixel_addr;
    wire          lcd_hs;
    wire          lcd_vs;
    wire          lcd_en;
    wire [ BDW:0] lcd_data;
    wire          vga_hs;
    wire          vga_vs;
    wire          vga_en;
    wire [ BDW:0] vga_data;
    wire          hdmi_tmds_clk_p;
    wire          hdmi_tmds_clk_n;
    wire [   2:0] hdmi_tmds_data_p;
    wire [   2:0] hdmi_tmds_data_n;
    wire          hdmi_tmds_oen;

    // SYS_PLL
    // wire          sys_clk = clk  /* synthesis syn_keep = 1 */;
    wire          sys_clk  /* synthesis syn_keep = 1 */;
    SYS_rPLL SYS_rPLL (
        .clkout(sys_clk),  // output clkout
        .reset (1'b0),     // input reset
        .clkin (clk)       // input clkin
    );


    // DPBRAM3 #(
    //     .FILE_BASE(FILE_BASE),
    //     .DP       (DP),
    //     .DW       (DW),
    //     .N        (N),
    //     .AW       (AW),
    //     .BDW      (BDW)
    // ) DPBRAM3 (
    //     .clka (clk),
    //     .rsta (~rstn),
    //     .cea  (1'b1),
    //     .wra  (1'b1),
    //     .addra(),
    //     .dina (),
    //     .douta(),
    //     .clkb (clk),
    //     .rstb (~rstn),
    //     .ceb  (1'b1),
    //     .wrb  (1'b0),
    //     .addrb(spilcd_pixel_addr),
    //     .dinb (),
    //     .doutb(spilcd_pixel_data)
    // );
    SDPBRAM3 #(
        .FILE_BASE(FILE_BASE),
        .DP       (DP),
        .DW       (DW),
        .N        (N),
        .AW       (AW),
        .BDW      (BDW)
    ) SDPBRAM3 (
        .clka (clk),
        .rsta (~rstn),
        .cea  (1'b1),
        .addra(),
        .dina (),
        .clkb (clk),
        .rstb (~rstn),
        .ceb  (1'b1),
        .addrb(spilcd_pixel_addr),
        .doutb(spilcd_pixel_data)
    );


    Display Display (
        .clk (sys_clk),
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
        .spilcd_rstn       (spilcd_rstn),
        .spilcd_clk        (spilcd_clk),
        .spilcd_cs         (spilcd_cs),
        .spilcd_rs         (spilcd_rs),
        .spilcd_data       (spilcd_data),
        .spilcd_bl         (spilcd_bl)
    );


endmodule
