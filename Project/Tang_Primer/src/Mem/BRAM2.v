`define HEX_INIT_FILE
// `define BIN_INIT_FILE

module BRAM2 #(
    parameter DP = 512,  // 深度：512个地址
    parameter DW = 24,  // 数据宽度：32位
    parameter MW = DW / 8,  // 掩码宽度（字节数）
    parameter AW = $clog2(DP)  // 地址宽度
) (
    input wire          clk,
    input wire          rst,
    input wire [AW-1:0] addr,
    input wire [DW-1:0] wdata,
    input wire [MW-1:0] sel,
    input wire          we,

    output wire [DW-1:0] rdata,
    output wire          rvalid
);

    // 3 个字节宽度的独立存储器
    reg [7:0] ram0[0:DP-1];
    reg [7:0] ram1[0:DP-1];
    reg [7:0] ram2[0:DP-1];
    initial begin
        $readmemh("F:/Project/FPAG/Project/GPU/MoonCore-GPU/Tool/init_ram0.hex", ram0);
        $readmemh("F:/Project/FPAG/Project/GPU/MoonCore-GPU/Tool/init_ram1.hex", ram1);
        $readmemh("F:/Project/FPAG/Project/GPU/MoonCore-GPU/Tool/init_ram2.hex", ram2);
    end

    // 写操作
    always @(posedge clk) begin
        if (we) begin
            if (sel[0]) ram0[addr] <= wdata[7:0];
            if (sel[1]) ram1[addr] <= wdata[15:8];
            if (sel[2]) ram2[addr] <= wdata[23:16];
        end
    end

    // 读操作
    reg [DW-1:0] rdata_r/* synthesis syn_keep = 1 */;  // 读出临时寄存器
    assign rvalid = ~we;  // 在读操作时设置为有效
    assign rdata  = rdata_r;  // 读出数据
    always @(posedge clk) if (!we) rdata_r <= {ram0[addr], ram1[addr], ram2[addr]};

endmodule
