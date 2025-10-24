/////////////////////////////////////////////////////////////////////////////////
// Company       : 武汉芯路恒科技有限公司
//                 http://xiaomeige.taobao.com
// Web           : http://www.corecourse.cn
// 
// Create Date   : 2019/04/10 00:00:00
// Module Name   : dvi_encoder
// Description   : rgb转tmds(hdmi)
// 
// Dependencies  : 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////////

module dvi_encoder(
  pixelclk,
  pixelclk5x,
  rst_p,
  TFT_rgb,
  hsync,
  vsync,
  de,
  tmds_clk_p,
  tmds_clk_n,
  tmds_data_p,
  tmds_data_n
);
  input        pixelclk;       // system clock
  input        pixelclk5x;     // system clock x5
  input        rst_p;          // reset
  input        [15:0]TFT_rgb;
  input        hsync;          // hsync data
  input        vsync;          // vsync data
  input        de;             // data enable
  output       tmds_clk_p;     //clock
  output       tmds_clk_n;     //clock
  output [2:0] tmds_data_p;    //rgb
  output [2:0] tmds_data_n;    //rgb


  wire  [7:0] blue_din;       // Blue data in
  wire  [7:0] green_din;      // Green data in
  wire  [7:0] red_din;        // Red data in


  // assign TFT_rgb = {disp_red[7:3],disp_green[7:2],disp_blue[7:3]};
  
  assign red_din   = {TFT_rgb[15:11],3'b000};
  assign green_din = {TFT_rgb[10: 5],2'b00 };
  assign blue_din  = {TFT_rgb[4 : 0],3'b000};

  wire [9:0] red;
  wire [9:0] green;
  wire [9:0] blue;

  encode encb(
    .clk     (pixelclk ),
    .rst_p   (rst_p    ),
    .din     (blue_din ),
    .c0      (hsync    ),
    .c1      (vsync    ),
    .de      (de       ),
    .dout    (blue     )
  );

  encode encr(
    .clk     (pixelclk  ),
    .rst_p   (rst_p     ),
    .din     (green_din ),
    .c0      (1'b0      ),
    .c1      (1'b0      ),
    .de      (de        ),
    .dout    (green     )
  );

  encode encg(
    .clk     (pixelclk ),
    .rst_p   (rst_p    ),
    .din     (red_din  ),
    .c0      (1'b0     ),
    .c1      (1'b0     ),
    .de      (de       ),
    .dout    (red      )
  );

  serdes_4b_10to1 serdes_4b_10to1_inst(
    .clkx5         (pixelclk5x      ),// 5x clock input
    .datain_0      (blue            ),// input data for serialisation
    .datain_1      (green           ),// input data for serialisation
    .datain_2      (red             ),// input data for serialisation
    .datain_3      (10'b1111100000  ),// input data for serialisation
    .dataout_0_p   (tmds_data_p[0]  ),// out DDR data
    .dataout_0_n   (tmds_data_n[0]  ),// out DDR data
    .dataout_1_p   (tmds_data_p[1]  ),// out DDR data
    .dataout_1_n   (tmds_data_n[1]  ),// out DDR data
    .dataout_2_p   (tmds_data_p[2]  ),// out DDR data
    .dataout_2_n   (tmds_data_n[2]  ),// out DDR data
    .dataout_3_p   (tmds_clk_p      ),// out DDR data
    .dataout_3_n   (tmds_clk_n      ) // out DDR data
  ); 

endmodule