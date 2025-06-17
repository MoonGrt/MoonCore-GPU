/*
    // SDPBRAM3 Parameters
    parameter T = 10;
    parameter FILE_BASE = "init";
    parameter DP = 512;
    parameter DW = 8;
    parameter N = 3;
    parameter AW = $clog2(DP) - 1;
    parameter BDW = N * DW - 1;
    // SDPBRAM3 Inputs
    reg          clka;
    reg          rsta;
    reg          cea;
    reg  [ AW:0] addra;
    reg  [BDW:0] dina;
    reg          clkb;
    reg          rstb;
    reg          ceb;
    reg  [ AW:0] addrb;
    wire [BDW:0] doutb;
    // SDPBRAM3 Instance
    SDPBRAM3 #(
        .FILE_BASE(FILE_BASE),
        .DP       (DP),
        .DW       (DW),
        .N        (N),
        .AW       (AW),
        .BDW      (BDW)
    ) SDPBRAM3 (
        .clka (clka),
        .rsta (rsta),
        .cea  (cea),
        .addra(addra),
        .dina (dina),
        .clkb (clkb),
        .rstb (rstb),
        .ceb  (ceb),
        .addrb(addrb),
        .doutb(doutb)
    );
*/

module SDPBRAM3 #(
    parameter FILE_BASE = "init",   // File base name
    parameter DP = 512,             // DPRAM depth
    parameter DW = 8,               // DPRAM width
    parameter N  = 3,               // Number of DPRAM instances (DW-bit each)
    parameter AW = $clog2(DP) - 1,  // Address width (log2(DP))
    parameter BDW = N * DW - 1      // Data width
) (
    input  wire         clka,
    input  wire         rsta,
    input  wire         cea,
    input  wire [ AW:0] addra,
    input  wire [BDW:0] dina,

    input  wire         clkb,
    input  wire         rstb,
    input  wire         ceb,
    input  wire [ AW:0] addrb,
    output wire [BDW:0] doutb
);

    localparam INIT_FILE0 = {FILE_BASE, "0.hex"};
    localparam INIT_FILE1 = {FILE_BASE, "1.hex"};
    localparam INIT_FILE2 = {FILE_BASE, "2.hex"};
    SDPRAM #(.INIT_FILE(INIT_FILE0), .DP(DP), .DW(DW)) SDPRAM0 (
        .clka (clka), .rsta (rsta), .cea  (cea), .addra(addra), .dina(dina[7:0]),
        .clkb (clkb), .rstb (rstb), .ceb  (ceb), .addrb(addrb), .doutb(doutb[7:0]));
    SDPRAM #(.INIT_FILE(INIT_FILE1), .DP(DP), .DW(DW)) SDPRAM1 (
        .clka (clka), .rsta (rsta), .cea  (cea), .addra(addra), .dina(dina[15:8]),
        .clkb (clkb), .rstb (rstb), .ceb  (ceb), .addrb(addrb), .doutb(doutb[15:8]));
    SDPRAM #(.INIT_FILE(INIT_FILE2), .DP(DP), .DW(DW)) SDPRAM2 (
        .clka (clka), .rsta (rsta), .cea  (cea), .addra(addra), .dina(dina[23:16]),
        .clkb (clkb), .rstb (rstb), .ceb  (ceb), .addrb(addrb), .doutb(doutb[23:16]));

endmodule
