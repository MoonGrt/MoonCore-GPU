`timescale 1ns / 1ps
module tb_spilcd;

    // lcd114_test Parameters
    parameter T = 10;


    // lcd114_test Inputs
    reg  clk = 0;
    reg  rst_n = 0;

    // lcd114_test Outputs
    wire lcd_resetn;
    wire lcd_clk;
    wire lcd_cs;
    wire lcd_rs;
    wire lcd_data;
    wire lcd_bl;

    initial begin
        forever #(T / 2) clk = ~clk;
    end

    initial begin
        #(T * 2) rst_n = 1;
    end

    spilcd_driver spilcd_driver (
        .clk       (clk),
        .resetn    (rst_n),
        .lcd_resetn(lcd_resetn),
        .lcd_clk   (lcd_clk),
        .lcd_cs    (lcd_cs),
        .lcd_rs    (lcd_rs),
        .lcd_data  (lcd_data),
        .lcd_bl    (lcd_bl)
    );

endmodule
