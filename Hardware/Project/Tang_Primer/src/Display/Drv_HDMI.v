`timescale 1ns / 1ps

module Drv_HDMI (
    input wire clk,     // ʱ��
    input wire clk_x5,  // 5��ʱ��
    input wire rstn,    // ��λ���͵�ƽ��Ч

    input wire [23:0] video_din,    // RGB888 video in
    input wire        video_hsync,  // hsync data
    input wire        video_vsync,  // vsync data
    input wire        video_de,     // data enable

    output wire       tmds_clk_p,   // TMDS ʱ��ͨ��
    output wire       tmds_clk_n,
    output wire [2:0] tmds_data_p,  // TMDS ����ͨ��
    output wire [2:0] tmds_data_n,
    output wire       tmds_oen      // TMDS ���ʹ��
);

    // wire define
    wire       reset;

    // ��������
    wire [9:0] red_10bit;
    wire [9:0] green_10bit;
    wire [9:0] blue_10bit;
    wire [9:0] clk_10bit;

    // ��������
    wire [2:0] tmds_data_serial;
    wire       tmds_clk_serial;

    //*****************************************************
    //**                    main code
    //*****************************************************
    assign tmds_oen  = 1'b1;
    assign clk_10bit = 10'b1111100000;

    // �첽��λ��ͬ���ͷ�
    asyn_rst_syn reset_syn (
        .rstn     (rstn),
        .clk      (clk),
        .syn_reset(reset)  //����Ч
    );

    // ��������ɫͨ�����б���
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

    // // �Ա��������ݽ��в���ת��
    // serializer_10_to_1 serializer_b (
    //     .reset        (reset),      // ��λ,����Ч
    //     .paralell_clk (clk),        // ���벢������ʱ��
    //     .serial_clk_5x(clk_x5),     // ���봮������ʱ��
    //     .paralell_data(blue_10bit), // ���벢������
    //     // .paralell_data      (10'h146),  // ���벢������

    //     .serial_data_out(tmds_data_serial[0])  // �����������
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

    // // ת������ź�
    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O��ƽ��׼ΪTMDS
    // ) TMDS0 (
    //     .I (tmds_data_serial[0]),
    //     .O (tmds_data_p[0]),
    //     .OB(tmds_data_n[0])
    // );

    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O��ƽ��׼ΪTMDS
    // ) TMDS1 (
    //     .I (tmds_data_serial[1]),
    //     .O (tmds_data_p[1]),
    //     .OB(tmds_data_n[1])
    // );

    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O��ƽ��׼ΪTMDS
    // ) TMDS2 (
    //     .I (tmds_data_serial[2]),
    //     .O (tmds_data_p[2]),
    //     .OB(tmds_data_n[2])
    // );

    // OBUFDS #(
    //     .IOSTANDARD("TMDS_33")  // I/O��ƽ��׼ΪTMDS
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

    // ��������������"1"�ĸ���
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
//     input       reset,          // ��λ,����Ч
//     input       paralell_clk,   // ���벢������ʱ��
//     input       serial_clk_5x,  // ���봮������ʱ��
//     input [9:0] paralell_data,  // ���벢������

//     output serial_data_out  // �����������
// );

//     // wire define
//     wire cascade1;  // ��������OSERDESE2�������ź�
//     wire cascade2;

//     //*****************************************************
//     //**                    main code
//     //*****************************************************

//     // ����OSERDESE2ԭ�ʵ�ֲ���ת��,Masterģʽ
//     OSERDESE2 #(
//         .DATA_RATE_OQ  ("DDR"),     // ����˫����������
//         .DATA_RATE_TQ  ("SDR"),     // DDR, BUF, SDR
//         .DATA_WIDTH    (10),        // ����Ĳ������ݿ��Ϊ10bit
//         .SERDES_MODE   ("MASTER"),  // ����ΪMaster������10bit�����չ
//         .TBYTE_CTL     ("FALSE"),   // Enable tristate byte operation (FALSE, TRUE)
//         .TBYTE_SRC     ("FALSE"),   // Tristate byte source (FALSE, TRUE)
//         .TRISTATE_WIDTH(1)          // 3-state converter width (1,4)
//     ) OSERDESE2_Master (
//         .CLK   (serial_clk_5x),  // ��������ʱ��,5��ʱ��Ƶ��
//         .CLKDIV(paralell_clk),   // ��������ʱ��
//         .RST   (reset),          // 1-bit input: Reset
//         .OCE   (1'b1),           // 1-bit input: Output data clock enable

//         .OQ(serial_data_out),  // �����������

//         .D1(paralell_data[0]),  // D1 - D8: ������������
//         .D2(paralell_data[1]),
//         .D3(paralell_data[2]),
//         .D4(paralell_data[3]),
//         .D5(paralell_data[4]),
//         .D6(paralell_data[5]),
//         .D7(paralell_data[6]),
//         .D8(paralell_data[7]),

//         .SHIFTIN1 (cascade1),  // SHIFTIN1 ����λ����չ
//         .SHIFTIN2 (cascade2),  // SHIFTIN2
//         .SHIFTOUT1(),          // SHIFTOUT1: ����λ����չ
//         .SHIFTOUT2(),          // SHIFTOUT2

//         .OFB     (),      // ������δʹ���ź�
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

//     // ����OSERDESE2ԭ�ʵ�ֲ���ת��,Slaveģʽ
//     OSERDESE2 #(
//         .DATA_RATE_OQ  ("DDR"),    // ����˫����������
//         .DATA_RATE_TQ  ("SDR"),    // DDR, BUF, SDR
//         .DATA_WIDTH    (10),       // ����Ĳ������ݿ��Ϊ10bit
//         .SERDES_MODE   ("SLAVE"),  // ����ΪSlave������10bit�����չ
//         .TBYTE_CTL     ("FALSE"),  // Enable tristate byte operation (FALSE, TRUE)
//         .TBYTE_SRC     ("FALSE"),  // Tristate byte source (FALSE, TRUE)
//         .TRISTATE_WIDTH(1)         // 3-state converter width (1,4)
//     ) OSERDESE2_Slave (
//         .CLK   (serial_clk_5x),  // ��������ʱ��,5��ʱ��Ƶ��
//         .CLKDIV(paralell_clk),   // ��������ʱ��
//         .RST   (reset),          // 1-bit input: Reset
//         .OCE   (1'b1),           // 1-bit input: Output data clock enable

//         .OQ(),  // �����������

//         .D1(1'b0),              // D1 - D8: ������������
//         .D2(1'b0),
//         .D3(paralell_data[8]),
//         .D4(paralell_data[9]),
//         .D5(1'b0),
//         .D6(1'b0),
//         .D7(1'b0),
//         .D8(1'b0),

//         .SHIFTIN1 (),          // SHIFTIN1 ����λ����չ
//         .SHIFTIN2 (),          // SHIFTIN2
//         .SHIFTOUT1(cascade1),  // SHIFTOUT1: ����λ����չ
//         .SHIFTOUT2(cascade2),  // SHIFTOUT2

//         .OFB     (),      // ������δʹ���ź�
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
    input clk,  // Ŀ��ʱ����
    input rstn, // �첽��λ������Ч

    output syn_reset  // ����Ч
);

    // reg define
    reg reset_1;
    reg reset_2;

    //*****************************************************
    //**                    main code
    //*****************************************************
    assign syn_reset = reset_2;

    // ���첽��λ�źŽ���ͬ���ͷţ���ת���ɸ���Ч
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
