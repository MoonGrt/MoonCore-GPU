`timescale 1ns / 1ps

module Drv_VGA (
    input wire clk,  // ʱ��
    input wire rstn, // ��λ���͵�ƽ��Ч

    // VGA ʱ��������루12λ��
    input wire [11:0] H_SYNC,
    input wire [11:0] H_BACK,
    input wire [11:0] H_DISP,
    input wire [11:0] H_FRONT,

    input wire [11:0] V_SYNC,
    input wire [11:0] V_BACK,
    input wire [11:0] V_DISP,
    input wire [11:0] V_FRONT,

    // ������������
    input  wire        pixel_valid,  // ����������Ч
    input  wire [23:0] pixel_data,   // 24λ�������ݣ�RGB888��ʽ
    output wire [11:0] pixel_hpos,   // ��ǰ���ص������
    output wire [11:0] pixel_vpos,   // ��ǰ���ص�������

    // VGA���
    output wire        hs,   // ��ͬ���ź�
    output wire        vs,   // ��ͬ���ź�
    output wire        en,   // VGA ����ʹ���ź�
    output wire [23:0] data  // VGA �������
);

    // ������ʱ��
    wire [11:0] H_TOTAL = H_SYNC + H_BACK + H_DISP + H_FRONT;
    wire [11:0] V_TOTAL = V_SYNC + V_BACK + V_DISP + V_FRONT;

    // ��/��������
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

    // ��ͬ���źţ��� h_cnt < H_SYNC ʱΪ��
    assign hs = (h_cnt < H_SYNC) ? 1'b0 : 1'b1;
    // ��ͬ���źţ��� v_cnt < V_SYNC ʱΪ��
    assign vs = (v_cnt < V_SYNC) ? 1'b0 : 1'b1;

    // ����ʹ���ź�
    assign en = (h_cnt >= H_SYNC + H_BACK && h_cnt < H_SYNC + H_BACK + H_DISP) &&
                (v_cnt >= V_SYNC + V_BACK && v_cnt < V_SYNC + V_BACK + V_DISP);

    // ��������λ�����
    assign pixel_hpos = en ? (h_cnt - (H_SYNC + H_BACK)) : 12'd0;
    assign pixel_vpos = en ? (v_cnt - (V_SYNC + V_BACK)) : 12'd0;

    // �������
    assign data = (en && pixel_valid) ? pixel_data : 24'd0;

endmodule
