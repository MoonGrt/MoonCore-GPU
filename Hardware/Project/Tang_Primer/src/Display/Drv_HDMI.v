`timescale 1ns / 1ps

module Drv_HDMI (
    input wire clk,     // 时钟
    input wire clk_x5,  // 5倍时钟
    input wire rstn,    // 复位，低电平有效

    input wire [23:0] video_din,    // RGB888 video in
    input wire        video_hsync,  // hsync data
    input wire        video_vsync,  // vsync data
    input wire        video_de,     // data enable

    output wire       tmds_clk_p,   // TMDS 时钟通道
    output wire       tmds_clk_n,
    output wire [2:0] tmds_data_p,  // TMDS 数据通道
    output wire [2:0] tmds_data_n,
    output wire       tmds_oen      // TMDS 输出使能
);

    // wire define
    wire       reset;

    // 并行数据
    wire [9:0] red_10bit;
    wire [9:0] green_10bit;
    wire [9:0] blue_10bit;
    wire [9:0] clk_10bit;

    // 串行数据
    wire [2:0] tmds_data_serial;
    wire       tmds_clk_serial;

    //*****************************************************
    //**                    main code
    //*****************************************************
    assign tmds_oen  = 1'b1;
    assign clk_10bit = 10'b1111100000;

    // 异步复位，同步释放
    asyn_rst_syn reset_syn (
        .rstn     (rstn),
        .clk      (clk),
        .syn_reset(reset)  //高有效
    );

    // 对三个颜色通道进行编码
    dvi_encoder encoder_b (
        .clkin(clk),
        .rstin(reset),

        .din (video_din[7:0]),
        .c0  (video_hsync),
        .c1  (video_vsync),
        .de  (video_de),
        .dout(blue_10bit)
    );

    dvi_encoder encoder_g (
        .clkin(clk),
        .rstin(reset),

        .din (video_din[15:8]),
        .c0  (video_hsync),
        .c1  (video_vsync),
        .de  (video_de),
        .dout(green_10bit)
    );

    dvi_encoder encoder_r (
        .clkin(clk),
        .rstin(reset),

        .din (video_din[23:16]),
        .c0  (video_hsync),
        .c1  (video_vsync),
        .de  (video_de),
        .dout(red_10bit)
    );

    // // 对编码后的数据进行并串转换
    // serializer_10_to_1 serializer_b (
    //     .reset        (reset),      // 复位,高有效
    //     .paralell_clk (clk),        // 输入并行数据时钟
    //     .serial_clk_5x(clk_x5),     // 输入串行数据时钟
    //     .paralell_data(blue_10bit), // 输入并行数据
    //     // .paralell_data      (10'h146),  // 输入并行数据

    //     .serial_data_out(tmds_data_serial[0])  // 输出串行数据
    // );

    // serializer_10_to_1 serializer_g (
    //     .reset        (reset),
    //     .paralell_clk (clk),
    //     .serial_clk_5x(clk_x5),
    //     .paralell_data(green_10bit),
    //     //     .paralell_data      (10'h146),

    //     .serial_data_out(tmds_data_serial[1])
    // );

    // serializer_10_to_1 serializer_r (
    //     .reset        (reset),
    //     .paralell_clk (clk),
    //     .serial_clk_5x(clk_x5),
    //     .paralell_data(red_10bit),
    //     //    .paralell_data      (10'h146),

    //     .serial_data_out(tmds_data_serial[2])
    // );

    // serializer_10_to_1 serializer_clk (
    //     .reset        (reset),
    //     .paralell_clk (clk),
    //     .serial_clk_5x(clk_x5),
    //     .paralell_data(clk_10bit),

    //     .serial_data_out(tmds_clk_serial)
    // );

    // // 转换差分信号
    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O电平标准为TMDS
    // ) TMDS0 (
    //     .I (tmds_data_serial[0]),
    //     .O (tmds_data_p[0]),
    //     .OB(tmds_data_n[0])
    // );

    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O电平标准为TMDS
    // ) TMDS1 (
    //     .I (tmds_data_serial[1]),
    //     .O (tmds_data_p[1]),
    //     .OB(tmds_data_n[1])
    // );

    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O电平标准为TMDS
    // ) TMDS2 (
    //     .I (tmds_data_serial[2]),
    //     .O (tmds_data_p[2]),
    //     .OB(tmds_data_n[2])
    // );

    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O电平标准为TMDS
    // ) TMDS3 (
    //     .I (tmds_clk_serial),
    //     .O (tmds_clk_p),
    //     .OB(tmds_clk_n)
    // );

endmodule


module dvi_encoder (
    input            clkin,  // pixel clock input
    input            rstin,  // async. reset input (active high)
    input      [7:0] din,    // data inputs: expect registered
    input            c0,     // c0 input
    input            c1,     // c1 input
    input            de,     // de input
    output reg [9:0] dout    // data outputs
);

    ////////////////////////////////////////////////////////////
    // Counting number of 1s and 0s for each incoming pixel
    // component. Pipe line the result.
    // Register Data Input so it matches the pipe lined adder
    // output
    ////////////////////////////////////////////////////////////
    reg [3:0] n1d;  // number of 1s in din
    reg [7:0] din_q;

    // 计算像素数据中"1"的个数
    always @(posedge clkin) begin
        n1d   <= #1 din[0] + din[1] + din[2] + din[3] + din[4] + din[5] + din[6] + din[7];

        din_q <= #1 din;
    end

    ///////////////////////////////////////////////////////
    // Stage 1: 8 bit -> 9 bit
    // Refer to DVI 1.0 Specification, page 29, Figure 3-5
    ///////////////////////////////////////////////////////
    wire decision1;

    assign decision1 = (n1d > 4'h4) | ((n1d == 4'h4) & (din_q[0] == 1'b0));

    wire [8:0] q_m;
    assign q_m[0] = din_q[0];
    assign q_m[1] = (decision1) ? (q_m[0] ^~ din_q[1]) : (q_m[0] ^ din_q[1]);
    assign q_m[2] = (decision1) ? (q_m[1] ^~ din_q[2]) : (q_m[1] ^ din_q[2]);
    assign q_m[3] = (decision1) ? (q_m[2] ^~ din_q[3]) : (q_m[2] ^ din_q[3]);
    assign q_m[4] = (decision1) ? (q_m[3] ^~ din_q[4]) : (q_m[3] ^ din_q[4]);
    assign q_m[5] = (decision1) ? (q_m[4] ^~ din_q[5]) : (q_m[4] ^ din_q[5]);
    assign q_m[6] = (decision1) ? (q_m[5] ^~ din_q[6]) : (q_m[5] ^ din_q[6]);
    assign q_m[7] = (decision1) ? (q_m[6] ^~ din_q[7]) : (q_m[6] ^ din_q[7]);
    assign q_m[8] = (decision1) ? 1'b0 : 1'b1;

    /////////////////////////////////////////////////////////
    // Stage 2: 9 bit -> 10 bit
    // Refer to DVI 1.0 Specification, page 29, Figure 3-5
    /////////////////////////////////////////////////////////
    reg [3:0] n1q_m, n0q_m;  // number of 1s and 0s for q_m
    always @(posedge clkin) begin
        n1q_m <= #1 q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
        n0q_m <= #1 4'h8 - (q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7]);
    end

    parameter CTRLTOKEN0 = 10'b1101010100;
    parameter CTRLTOKEN1 = 10'b0010101011;
    parameter CTRLTOKEN2 = 10'b0101010100;
    parameter CTRLTOKEN3 = 10'b1010101011;

    reg [4:0] cnt;  // disparity counter, MSB is the sign bit
    wire decision2, decision3;

    assign decision2 = (cnt == 5'h0) | (n1q_m == n0q_m);
    /////////////////////////////////////////////////////////////////////////
    // [(cnt > 0) and (N1q_m > N0q_m)] or [(cnt < 0) and (N0q_m > N1q_m)]
    /////////////////////////////////////////////////////////////////////////
    assign decision3 = (~cnt[4] & (n1q_m > n0q_m)) | (cnt[4] & (n0q_m > n1q_m));

    ////////////////////////////////////
    // pipe line alignment
    ////////////////////////////////////
    reg de_q, de_reg;
    reg c0_q, c1_q;
    reg c0_reg, c1_reg;
    reg [8:0] q_m_reg;

    always @(posedge clkin) begin
        de_q    <=#1 de;
        de_reg  <=#1 de_q;

        c0_q    <=#1 c0;
        c0_reg  <=#1 c0_q;
        c1_q    <=#1 c1;
        c1_reg  <=#1 c1_q;

        q_m_reg <=#1 q_m;
    end

    ///////////////////////////////
    // 10-bit out
    // disparity counter
    ///////////////////////////////
    always @(posedge clkin or posedge rstin) begin
        if (rstin) begin
            dout <= 10'h0;
            cnt  <= 5'h0;
        end else begin
            if (de_reg) begin
                if (decision2) begin
                    dout[9] <= #1 ~q_m_reg[8];
                    dout[8] <= #1 q_m_reg[8];
                    dout[7:0] <= #1 (q_m_reg[8]) ? q_m_reg[7:0] : ~q_m_reg[7:0];

                    cnt <= #1 (~q_m_reg[8]) ? (cnt + n0q_m - n1q_m) : (cnt + n1q_m - n0q_m);
                end else begin
                    if (decision3) begin
                        dout[9] <= #1 1'b1;
                        dout[8] <= #1 q_m_reg[8];
                        dout[7:0] <= #1 ~q_m_reg[7:0];

                        cnt <= #1 cnt + {q_m_reg[8], 1'b0} + (n0q_m - n1q_m);
                    end else begin
                        dout[9] <= #1 1'b0;
                        dout[8] <= #1 q_m_reg[8];
                        dout[7:0] <= #1 q_m_reg[7:0];

                        cnt <= #1 cnt - {~q_m_reg[8], 1'b0} + (n1q_m - n0q_m);
                    end
                end
            end else begin
                case ({
                    c1_reg, c0_reg
                })
                    2'b00:   dout <= #1 CTRLTOKEN0;
                    2'b01:   dout <= #1 CTRLTOKEN1;
                    2'b10:   dout <= #1 CTRLTOKEN2;
                    default: dout <= #1 CTRLTOKEN3;
                endcase

                cnt <= #1 5'h0;
            end
        end
    end

endmodule


// module serializer_10_to_1 (
//     input       reset,          // 复位,高有效
//     input       paralell_clk,   // 输入并行数据时钟
//     input       serial_clk_5x,  // 输入串行数据时钟
//     input [9:0] paralell_data,  // 输入并行数据

//     output serial_data_out  // 输出串行数据
// );

//     // wire define
//     wire cascade1;  // 用于两个OSERDESE2级联的信号
//     wire cascade2;

//     //*****************************************************
//     //**                    main code
//     //*****************************************************

//     // 例化OSERDESE2原语，实现并串转换,Master模式
//     OSERDESE2 #(
//         .DATA_RATE_OQ  ("DDR"),     // 设置双倍数据速率
//         .DATA_RATE_TQ  ("SDR"),     // DDR, BUF, SDR
//         .DATA_WIDTH    (10),        // 输入的并行数据宽度为10bit
//         .SERDES_MODE   ("MASTER"),  // 设置为Master，用于10bit宽度扩展
//         .TBYTE_CTL     ("FALSE"),   // Enable tristate byte operation (FALSE, TRUE)
//         .TBYTE_SRC     ("FALSE"),   // Tristate byte source (FALSE, TRUE)
//         .TRISTATE_WIDTH(1)          // 3-state converter width (1,4)
//     ) OSERDESE2_Master (
//         .CLK   (serial_clk_5x),  // 串行数据时钟,5倍时钟频率
//         .CLKDIV(paralell_clk),   // 并行数据时钟
//         .RST   (reset),          // 1-bit input: Reset
//         .OCE   (1'b1),           // 1-bit input: Output data clock enable

//         .OQ(serial_data_out),  // 串行输出数据

//         .D1(paralell_data[0]),  // D1 - D8: 并行数据输入
//         .D2(paralell_data[1]),
//         .D3(paralell_data[2]),
//         .D4(paralell_data[3]),
//         .D5(paralell_data[4]),
//         .D6(paralell_data[5]),
//         .D7(paralell_data[6]),
//         .D8(paralell_data[7]),

//         .SHIFTIN1 (cascade1),  // SHIFTIN1 用于位宽扩展
//         .SHIFTIN2 (cascade2),  // SHIFTIN2
//         .SHIFTOUT1(),          // SHIFTOUT1: 用于位宽扩展
//         .SHIFTOUT2(),          // SHIFTOUT2

//         .OFB     (),      // 以下是未使用信号
//         .T1      (1'b0),
//         .T2      (1'b0),
//         .T3      (1'b0),
//         .T4      (1'b0),
//         .TBYTEIN (1'b0),
//         .TCE     (1'b0),
//         .TBYTEOUT(),
//         .TFB     (),
//         .TQ      ()
//     );

//     // 例化OSERDESE2原语，实现并串转换,Slave模式
//     OSERDESE2 #(
//         .DATA_RATE_OQ  ("DDR"),    // 设置双倍数据速率
//         .DATA_RATE_TQ  ("SDR"),    // DDR, BUF, SDR
//         .DATA_WIDTH    (10),       // 输入的并行数据宽度为10bit
//         .SERDES_MODE   ("SLAVE"),  // 设置为Slave，用于10bit宽度扩展
//         .TBYTE_CTL     ("FALSE"),  // Enable tristate byte operation (FALSE, TRUE)
//         .TBYTE_SRC     ("FALSE"),  // Tristate byte source (FALSE, TRUE)
//         .TRISTATE_WIDTH(1)         // 3-state converter width (1,4)
//     ) OSERDESE2_Slave (
//         .CLK   (serial_clk_5x),  // 串行数据时钟,5倍时钟频率
//         .CLKDIV(paralell_clk),   // 并行数据时钟
//         .RST   (reset),          // 1-bit input: Reset
//         .OCE   (1'b1),           // 1-bit input: Output data clock enable

//         .OQ(),  // 串行输出数据

//         .D1(1'b0),              // D1 - D8: 并行数据输入
//         .D2(1'b0),
//         .D3(paralell_data[8]),
//         .D4(paralell_data[9]),
//         .D5(1'b0),
//         .D6(1'b0),
//         .D7(1'b0),
//         .D8(1'b0),

//         .SHIFTIN1 (),          // SHIFTIN1 用于位宽扩展
//         .SHIFTIN2 (),          // SHIFTIN2
//         .SHIFTOUT1(cascade1),  // SHIFTOUT1: 用于位宽扩展
//         .SHIFTOUT2(cascade2),  // SHIFTOUT2

//         .OFB     (),      // 以下是未使用信号
//         .T1      (1'b0),
//         .T2      (1'b0),
//         .T3      (1'b0),
//         .T4      (1'b0),
//         .TBYTEIN (1'b0),
//         .TCE     (1'b0),
//         .TBYTEOUT(),
//         .TFB     (),
//         .TQ      ()
//     );

// endmodule


module asyn_rst_syn (
    input clk,  // 目的时钟域
    input rstn, // 异步复位，低有效

    output syn_reset  // 高有效
);

    // reg define
    reg reset_1;
    reg reset_2;

    //*****************************************************
    //**                    main code
    //*****************************************************
    assign syn_reset = reset_2;

    // 对异步复位信号进行同步释放，并转换成高有效
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            reset_1 <= 1'b1;
            reset_2 <= 1'b1;
        end else begin
            reset_1 <= 1'b0;
            reset_2 <= reset_1;
        end
    end

endmodule
