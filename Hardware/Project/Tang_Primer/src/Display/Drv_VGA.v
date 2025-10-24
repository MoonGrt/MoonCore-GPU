`timescale 1ns / 1ps

module Drv_VGA (
    input wire clk,  // 时钟
    input wire rstn, // 复位，低电平有效

    // VGA 时序参数输入（12位）
    input wire [11:0] H_SYNC,
    input wire [11:0] H_BACK,
    input wire [11:0] H_DISP,
    input wire [11:0] H_FRONT,

    input wire [11:0] V_SYNC,
    input wire [11:0] V_BACK,
    input wire [11:0] V_DISP,
    input wire [11:0] V_FRONT,

    // 请求像素数据
    input  wire        pixel_valid,  // 像素数据有效
    input  wire [23:0] pixel_data,   // 24位像素数据，RGB888格式
    output wire [11:0] pixel_hpos,   // 当前像素点横坐标
    output wire [11:0] pixel_vpos,   // 当前像素点纵坐标

    // VGA输出
    output wire        hs,   // 行同步信号
    output wire        vs,   // 场同步信号
    output wire        en,   // VGA 数据使能信号
    output wire [23:0] data  // VGA 数据输出
);

    // 计算总时序
    wire [11:0] H_TOTAL = H_SYNC + H_BACK + H_DISP + H_FRONT;
    wire [11:0] V_TOTAL = V_SYNC + V_BACK + V_DISP + V_FRONT;

    // 行/场计数器
    reg [11:0] h_cnt;
    reg [11:0] v_cnt;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            h_cnt <= 12'd0;
        else if (h_cnt == H_TOTAL - 1)
            h_cnt <= 12'd0;
        else
            h_cnt <= h_cnt + 1;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            v_cnt <= 12'd0;
        else if (h_cnt == H_TOTAL - 1) begin
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 12'd0;
            else
                v_cnt <= v_cnt + 1;
        end
    end

    // 行同步信号：在 h_cnt < H_SYNC 时为低
    assign hs = (h_cnt < H_SYNC) ? 1'b0 : 1'b1;
    // 场同步信号：在 v_cnt < V_SYNC 时为低
    assign vs = (v_cnt < V_SYNC) ? 1'b0 : 1'b1;

    // 数据使能信号
    assign en = (h_cnt >= H_SYNC + H_BACK && h_cnt < H_SYNC + H_BACK + H_DISP) &&
                (v_cnt >= V_SYNC + V_BACK && v_cnt < V_SYNC + V_BACK + V_DISP);

    // 请求像素位置输出
    assign pixel_hpos = en ? (h_cnt - (H_SYNC + H_BACK)) : 12'd0;
    assign pixel_vpos = en ? (v_cnt - (V_SYNC + V_BACK)) : 12'd0;

    // 输出数据
    assign data = (en && pixel_valid) ? pixel_data : 24'd0;

endmodule
