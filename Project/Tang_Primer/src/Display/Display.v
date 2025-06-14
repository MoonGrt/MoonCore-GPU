`timescale 1ns / 1ps

module Display (
    input wire clk,  // 时钟
    input wire rstn, // 复位，低电平有效

    input  wire [23:0] spilcd_pixel_data,   // SPI LCD接口：像素数据
    input  wire        spilcd_pixel_valid,  // SPI LCD接口：像素有效信号
    output wire [14:0] spilcd_pixel_addr,   // SPI LCD接口：像素地址

    // LCD
    output wire        lcd_hs,            // 行同步信号
    output wire        lcd_vs,            // 场同步信号
    output wire        lcd_en,            // LCD 数据使能信号
    output wire [23:0] lcd_data,          // LCD 数据输出
    // VGA
    output wire        vga_hs,            // 行同步信号
    output wire        vga_vs,            // 场同步信号
    output wire        vga_en,            // LCD 数据使能信号
    output wire [23:0] vga_data,          // LCD 数据输出
    // HDMI
    output wire        hdmi_tmds_clk_p,   // TMDS 时钟通道
    output wire        hdmi_tmds_clk_n,   // TMDS 时钟反相
    output wire [ 2:0] hdmi_tmds_data_p,  // TMDS 数据通道
    output wire [ 2:0] hdmi_tmds_data_n,  // TMDS 数据反相
    output wire        hdmi_tmds_oen,     // TMDS 输出使能
    // SPI LCD
    output wire        spilcd_resetn,
    output wire        spilcd_clk,
    output wire        spilcd_cs,
    output wire        spilcd_rs,
    output wire        spilcd_data,
    output wire        spilcd_bl
);

    // clk rstn
    wire        lcd_clk;
    wire        lcd_rstn;
    wire        vga_clk;
    wire        vga_rstn;
    wire        hdmi_clk;
    wire        hdmi_rstn;
    wire        mipi_clk;
    wire        mipi_rstn;
    wire        spiLCD_clk;
    wire        spiLCD_rstn;
    // data valid
    wire        lcd_pixel_valid;
    wire        vga_pixel_valid;
    wire [23:0] lcd_pixel_data;
    wire [23:0] vga_pixel_data;
    // test pattern
    wire [ 2:0] lcd_mode = 3'b000;
    wire [23:0] lcd_color = 24'hFFFFFF;
    wire [11:0] lcd_h_res = 12'd480;
    wire [11:0] lcd_v_res = 12'd272;
    wire [11:0] lcd_pixel_hpos;
    wire [11:0] lcd_pixel_vpos;
    wire [ 2:0] vga_mode = 3'b001;
    wire [23:0] vga_color = 24'h000000;
    wire [11:0] vga_h_res = 12'd800;
    wire [11:0] vga_v_res = 12'd480;
    wire [11:0] vga_pixel_hpos;
    wire [11:0] vga_pixel_vpos;
    // spi lcd
    wire [11:0] spilcd_pixel_hpos;
    wire [11:0] spilcd_pixel_vpos;
    assign spilcd_pixel_addr = spilcd_pixel_hpos + spilcd_pixel_vpos * 135;


    Disp_PLL Disp_PLL (
        .clk (clk),
        .rstn(rstn),

        .lcd_clk    (lcd_clk),
        .lcd_rstn   (lcd_rstn),
        .vga_clk    (vga_clk),
        .vga_rstn   (vga_rstn),
        .hdmi_clk   (hdmi_clk),
        .hdmi_clk_x5(hdmi_clk_x5),
        .hdmi_rstn  (hdmi_rstn),
        .mipi_clk   (mipi_clk),
        .mipi_rstn  (mipi_rstn),
        .spilcd_clk (spiLCD_clk),
        .spilcd_rstn(spiLCD_rstn)
    );


    testpattern lcd_testpattern (
        .clk       (lcd_clk),
        .rstn      (lcd_rstn),
        .mode      (lcd_mode),
        .color     (lcd_color),
        .h_res     (lcd_h_res),
        .v_res     (lcd_v_res),
        .pixel_hpos(lcd_pixel_hpos),
        .pixel_vpos(lcd_pixel_vpos),
        .valid     (lcd_pixel_valid),
        .data      (lcd_pixel_data)
    );


    testpattern vga_testpattern (
        .clk       (vga_clk),
        .rstn      (vga_rstn),
        .mode      (vga_mode),
        .color     (vga_color),
        .h_res     (vga_h_res),
        .v_res     (vga_v_res),
        .pixel_hpos(vga_pixel_hpos),
        .pixel_vpos(vga_pixel_vpos),
        .valid     (vga_pixel_valid),
        .data      (vga_pixel_data)
    );


    Driver Driver (
        .clk (clk),
        .rstn(rstn),

        // LCD接口
        .lcd_clk        (lcd_clk),
        .lcd_rstn       (lcd_rstn),
        .lcd_pixel_valid(lcd_pixel_valid),
        .lcd_pixel_data (lcd_pixel_data),
        .lcd_pixel_hpos (lcd_pixel_hpos),
        .lcd_pixel_vpos (lcd_pixel_vpos),
        .lcd_hs         (lcd_hs),
        .lcd_vs         (lcd_vs),
        .lcd_en         (lcd_en),
        .lcd_data       (lcd_data),

        // VGA接口
        .vga_clk        (vga_clk),
        .vga_rstn       (vga_rstn),
        .vga_pixel_valid(vga_pixel_valid),
        .vga_pixel_data (vga_pixel_data),
        .vga_pixel_hpos (vga_pixel_hpos),
        .vga_pixel_vpos (vga_pixel_vpos),
        .vga_hs         (vga_hs),
        .vga_vs         (vga_vs),
        .vga_en         (vga_en),
        .vga_data       (vga_data),

        // HDMI接口
        .hdmi_clk        (hdmi_clk),
        .hdmi_clk_x5     (hdmi_clk_x5),
        .hdmi_rstn       (hdmi_rstn),
        .hdmi_tmds_clk_p (hdmi_tmds_clk_p),
        .hdmi_tmds_clk_n (hdmi_tmds_clk_n),
        .hdmi_tmds_data_p(hdmi_tmds_data_p),
        .hdmi_tmds_data_n(hdmi_tmds_data_n),
        .hdmi_tmds_oen   (hdmi_tmds_oen),

        // SPI LCD接口
        .spiLCD_clk        (spiLCD_clk),
        .spiLCD_rstn       (spiLCD_rstn),
        .spilcd_pixel_valid(spilcd_pixel_valid),
        .spilcd_pixel_data (spilcd_pixel_data),
        .spilcd_pixel_hpos (spilcd_pixel_hpos),
        .spilcd_pixel_vpos (spilcd_pixel_vpos),
        .spilcd_resetn     (spilcd_resetn),
        .spilcd_clk        (spilcd_clk),
        .spilcd_cs         (spilcd_cs),
        .spilcd_rs         (spilcd_rs),
        .spilcd_data       (spilcd_data),
        .spilcd_bl         (spilcd_bl)
    );

endmodule


// ---------------------------------------------------------------------
// File name         : testpattern.v
// Module name       : testpattern
// Module Description:
//          mode[2:0] = "000" : color bar
//          mode[2:0] = "001" : net grid
//          mode[2:0] = "010" : gray
//          mode[2:0] = "011" : single color
// ---------------------------------------------------------------------
// Release history
// VERSION |   Date      | AUTHOR  |    DESCRIPTION
// --------------------------------------------------------------------

module testpattern (
    input wire        clk,   // pixel clock
    input wire        rstn,  // low active reset
    input wire [ 2:0] mode,  // pattern mode
    input wire [23:0] color, // input color for single color mode

    input wire [11:0] h_res,       // horizontal resolution
    input wire [11:0] v_res,       // vertical resolution
    input wire [11:0] pixel_hpos,  // current pixel horizontal position
    input wire [11:0] pixel_vpos,  // current pixel vertical position

    output wire        valid,  // data valid
    output reg  [23:0] data    // output pixel data
);

    // -----------------------------------------
    // Color Definitions
    // -----------------------------------------
    localparam WHITE = 24'hFFFFFF;
    localparam YELLOW = 24'hFFFF00;
    localparam CYAN = 24'h00FFFF;
    localparam GREEN = 24'h00FF00;
    localparam MAGENTA = 24'hFF00FF;
    localparam RED = 24'hFF0000;
    localparam BLUE = 24'h0000FF;
    localparam BLACK = 24'h000000;

    wire [23:0] color_bar_color;
    wire [23:0] net_grid_color;
    wire [23:0] gray_color;

    // -----------------------------------------
    // Color Bar Pattern (mode = 3'b000)
    // Divide screen horizontally into 8 segments
    // -----------------------------------------
    wire [ 2:0] color_index = pixel_hpos / (h_res >> 3);  // divide by 8
    assign color_bar_color =  (color_index == 3'd0) ? WHITE   :
                              (color_index == 3'd1) ? YELLOW  :
                              (color_index == 3'd2) ? CYAN    :
                              (color_index == 3'd3) ? GREEN   :
                              (color_index == 3'd4) ? MAGENTA :
                              (color_index == 3'd5) ? RED     :
                              (color_index == 3'd6) ? BLACK   :
                              (color_index == 3'd7) ? BLUE    :  BLACK;

    // -----------------------------------------
    // Net Grid Pattern (mode = 3'b001)
    // Draw red lines every 32 pixels horizontally and vertically
    // -----------------------------------------
    wire        h_line = (pixel_hpos[4:0] == 5'd0);  // every 32 pixels
    wire        v_line = (pixel_vpos[4:0] == 5'd0);
    assign net_grid_color = (h_line || v_line) ? RED : BLACK;

    // -----------------------------------------
    // Grayscale Pattern (mode = 3'b010)
    // Horizontal grayscale gradient
    // -----------------------------------------
    assign gray_color = {pixel_hpos[7:0], pixel_hpos[7:0], pixel_hpos[7:0]};

    // -----------------------------------------
    // Output logic
    // -----------------------------------------
    assign valid = 1'b1;  // Always valid output
    always @(posedge clk or negedge rstn) begin
        if (!rstn) data <= 24'd0;
        else begin
            case (mode)
                3'b000:  data <= color_bar_color;
                3'b001:  data <= net_grid_color;
                3'b010:  data <= gray_color;
                3'b011:  data <= color;
                default: data <= BLACK;
            endcase
        end
    end

endmodule
