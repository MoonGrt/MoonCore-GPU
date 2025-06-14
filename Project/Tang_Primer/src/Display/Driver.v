`timescale 1ns / 1ps

module Driver (
    input wire clk,  // ʱ��
    input wire rstn, // ��λ���͵�ƽ��Ч

    // LCD
    input  wire        lcd_clk,
    input  wire        lcd_rstn,
    input  wire        lcd_pixel_valid,
    input  wire [23:0] lcd_pixel_data,
    output wire [11:0] lcd_pixel_hpos,
    output wire [11:0] lcd_pixel_vpos,
    output wire        lcd_hs,              // ��ͬ���ź�
    output wire        lcd_vs,              // ��ͬ���ź�
    output wire        lcd_en,              // LCD ����ʹ���ź�
    output wire [23:0] lcd_data,            // LCD �������
    // VGA
    input  wire        vga_clk,
    input  wire        vga_rstn,
    input  wire        vga_pixel_valid,
    input  wire [23:0] vga_pixel_data,
    output wire [11:0] vga_pixel_hpos,
    output wire [11:0] vga_pixel_vpos,
    output wire        vga_hs,              // ��ͬ���ź�
    output wire        vga_vs,              // ��ͬ���ź�
    output wire        vga_en,              // LCD ����ʹ���ź�
    output wire [23:0] vga_data,            // LCD �������
    // HDMI
    input  wire        hdmi_clk,
    input  wire        hdmi_clk_x5,
    input  wire        hdmi_rstn,
    output wire        hdmi_tmds_clk_p,     // TMDS ʱ��ͨ��
    output wire        hdmi_tmds_clk_n,     // TMDS ʱ�ӷ���
    output wire [ 2:0] hdmi_tmds_data_p,    // TMDS ����ͨ��
    output wire [ 2:0] hdmi_tmds_data_n,    // TMDS ���ݷ���
    output wire        hdmi_tmds_oen,       // TMDS ���ʹ��
    // SPI LCD
    input  wire        spiLCD_clk,
    input  wire        spiLCD_rstn,
    input  wire        spilcd_pixel_valid,
    input  wire [23:0] spilcd_pixel_data,
    output wire [11:0] spilcd_pixel_hpos,
    output wire [11:0] spilcd_pixel_vpos,
    output wire        spilcd_resetn,
    output wire        spilcd_clk,
    output wire        spilcd_cs,
    output wire        spilcd_rs,
    output wire        spilcd_data,
    output wire        spilcd_bl
);

    // Drv_LCD Inputs
    wire [11:0] LCD_H_SYNC = 11'd41;  // ��ͬ��
    wire [11:0] LCD_H_BACK = 11'd2;  // ����ʾ����
    wire [11:0] LCD_H_DISP = 11'd480;  // ����Ч����
    wire [11:0] LCD_H_FRONT = 11'd2;  // ����ʾǰ��
    wire [11:0] LCD_V_SYNC = 11'd10;  // ��ͬ��
    wire [11:0] LCD_V_BACK = 11'd2;  // ����ʾ����
    wire [11:0] LCD_V_DISP = 11'd272;  // ����Ч����
    wire [11:0] LCD_V_FRONT = 11'd2;  // ����ʾǰ��
    // Drv_VGA Inputs
    wire [11:0] VGA_H_SYNC = 11'd128;  // ��ͬ��
    wire [11:0] VGA_H_BACK = 11'd88;  // ����ʾ����
    wire [11:0] VGA_H_DISP = 11'd800;  // ����Ч����
    wire [11:0] VGA_H_FRONT = 11'd40;  // ����ʾǰ��
    wire [11:0] VGA_V_SYNC = 11'd2;  // ��ͬ��
    wire [11:0] VGA_V_BACK = 11'd33;  // ����ʾ����
    wire [11:0] VGA_V_DISP = 11'd480;  // ����Ч����
    wire [11:0] VGA_V_FRONT = 11'd10;  // ����ʾǰ��
    // Drv_HDMI Inputs
    wire [23:0] hdmi_video_din;
    wire        hdmi_video_hsync;
    wire        hdmi_video_vsync;
    wire        hdmi_video_de;


    Drv_LCD Drv_LCD (
        .clk    (lcd_clk),
        .rstn   (lcd_rstn),
        .H_SYNC (LCD_H_SYNC),
        .H_BACK (LCD_H_BACK),
        .H_DISP (LCD_H_DISP),
        .H_FRONT(LCD_H_FRONT),
        .V_SYNC (LCD_V_SYNC),
        .V_BACK (LCD_V_BACK),
        .V_DISP (LCD_V_DISP),
        .V_FRONT(LCD_V_FRONT),

        .pixel_valid(lcd_pixel_valid),
        .pixel_data (lcd_pixel_data),
        .pixel_hpos (lcd_pixel_hpos),
        .pixel_vpos (lcd_pixel_vpos),

        .hs  (lcd_hs),
        .vs  (lcd_vs),
        .en  (lcd_en),
        .data(lcd_data)
    );


    Drv_VGA Drv_VGA (
        .clk    (vga_clk),
        .rstn   (vga_rstn),
        .H_SYNC (VGA_H_SYNC),
        .H_BACK (VGA_H_BACK),
        .H_DISP (VGA_H_DISP),
        .H_FRONT(VGA_H_FRONT),
        .V_SYNC (VGA_V_SYNC),
        .V_BACK (VGA_V_BACK),
        .V_DISP (VGA_V_DISP),
        .V_FRONT(VGA_V_FRONT),

        .pixel_valid(vga_pixel_valid),
        .pixel_data (vga_pixel_data),
        .pixel_hpos (vga_pixel_hpos),
        .pixel_vpos (vga_pixel_vpos),

        .hs  (vga_hs),
        .vs  (vga_vs),
        .en  (vga_en),
        .data(vga_data)
    );


    Drv_HDMI Drv_HDMI (
        .clk   (hdmi_clk),
        .clk_x5(hdmi_clk_x5),
        .rstn  (hdmi_rstn),

        .video_din  (hdmi_video_din),
        .video_hsync(hdmi_video_hsync),
        .video_vsync(hdmi_video_vsync),
        .video_de   (hdmi_video_de),

        .tmds_clk_p (hdmi_tmds_clk_p),
        .tmds_clk_n (hdmi_tmds_clk_n),
        .tmds_data_p(hdmi_tmds_data_p),
        .tmds_data_n(hdmi_tmds_data_n),
        .tmds_oen   (hdmi_tmds_oen)
    );


    Drv_MIPI Drv_MIPI ();


    Drv_LCD_SPI Drv_LCD_SPI (
        .clk (spiLCD_clk),
        .rstn(spiLCD_rstn),

        .pixel_valid(spilcd_pixel_valid),
        .pixel_data (spilcd_pixel_data),
        .pixel_hpos (spilcd_pixel_hpos),
        .pixel_vpos (spilcd_pixel_vpos),

        .lcd_resetn(spilcd_resetn),
        .lcd_clk   (spilcd_clk),
        .lcd_cs    (spilcd_cs),
        .lcd_rs    (spilcd_rs),
        .lcd_data  (spilcd_data),
        .lcd_bl    (spilcd_bl)
    );

endmodule
