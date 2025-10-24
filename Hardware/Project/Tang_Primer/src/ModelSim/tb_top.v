`timescale 1ns / 1ps
module tb_top;

    // top Parameters
    parameter T = 10;

    // top Inputs
    reg clk = 0;
    reg rstn = 0;

    initial begin
        forever #(T / 2) clk = ~clk;
    end

    initial begin
        #(T * 2) rstn = 1;
    end

    top top (
        .clk (clk),
        .rstn(rstn)
    );

endmodule
