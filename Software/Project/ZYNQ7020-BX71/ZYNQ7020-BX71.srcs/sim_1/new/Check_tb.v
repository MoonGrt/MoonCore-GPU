`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 15:07:31
// Design Name: 
// Module Name: Check_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Check_tb();

reg Clk;
reg Rstn;
wire [35:0]GPIO0_o_wire;
wire [35:0]GPIO0_i_wire;
wire [35:0]GPIO0_t;
wire [35:0]GPIO1_t;

Check Check0(
    .CLK(Clk),
    .RESETN(Rstn),
    .GPIO0_i({0,GPIO0_i_wire[34:0]}),
    .GPIO0_t(GPIO0_t),
    .GPIO0_o(GPIO0_o_wire),
    .GPIO1_i(GPIO0_o_wire),
    .GPIO1_t(GPIO1_t),
    .GPIO1_o(GPIO0_i_wire)
);

initial Clk = 1;
always #10 Clk = ~Clk;

initial begin
    Rstn = 0;
    #56;
    Rstn = 1;
    #1000000000;






    $stop;
end





endmodule
