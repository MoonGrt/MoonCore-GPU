module rgb565to888(
    input m_clk,
    input s_clk,
	input [15:0]s_axis_tdata,
	input s_axis_tlast,
	output s_axis_tready,
	input s_axis_tuser,
	input s_axis_tvalid,
	
	output [23:0]m_axis_tdata,
	output m_axis_tlast,
	input m_axis_tready,
	output m_axis_tuser,
	output m_axis_tvalid
);  
assign m_axis_tlast = s_axis_tlast;
assign s_axis_tready = m_axis_tready;
assign m_axis_tuser = s_axis_tuser;
assign m_axis_tvalid = s_axis_tvalid;

parameter RGB_SET = 1;
assign m_axis_tdata = RGB_SET?{s_axis_tdata[15:11], 3'b0, s_axis_tdata[10:5], 2'b0, s_axis_tdata[4:0], 3'b0}:
    {s_axis_tdata[7:5],s_axis_tdata[4:3], 3'b0, s_axis_tdata[2:0],s_axis_tdata[15:13], 2'b0, s_axis_tdata[12:8], 3'b0};
//15:11 10:8 7:5 4:0                7:5 4:0 15:11 10:8
//  5    3      5     2   5  3         3+2   3     3+3     2   5   3       
//15:11 000 10:8 7:5 00 4:0 000     7:5 4:3 000 2:0 15:13 00 12:8 000
endmodule
