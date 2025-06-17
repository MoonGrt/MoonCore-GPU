/*
    // DPBRAM3 Parameters
    parameter FILE_BASE = "init";
    parameter DP = 512;
    parameter DW = 8;
    parameter N = 3;
    parameter AW = $clog2(DP) - 1;
    parameter BDW = N * DW - 1;
    // DPBRAM3 Signals
    reg          en;
    reg          clka;
    reg          rsta;
    reg          wra;
    reg  [ AW:0] addra;
    reg  [BDW:0] dina;
    wire [BDW:0] douta;
    reg          clkb;
    reg          rstb;
    reg          wrb;
    reg  [ AW:0] addrb;
    reg  [BDW:0] dinb;
    wire [BDW:0] doutb;
    // DPBRAM3 Instance
    DPBRAM3 #(
        .FILE_BASE(FILE_BASE),
        .DP       (DP),
        .DW       (DW),
        .N        (N),
        .AW       (AW),
        .BDW      (BDW)
    ) DPBRAM3 (
        .clka (clka),
        .rsta (rsta),
        .cea  (cea),
        .wra  (wra),
        .addra(addra),
        .dina (dina),
        .douta(douta),
        .clkb (clkb),
        .rstb (rstb),
        .ceb  (ceb),
        .wrb  (wrb),
        .addrb(addrb),
        .dinb (dinb),
        .doutb(doutb)
    );
*/

module DPBRAM3 #(
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
    input  wire         wra,
    input  wire [ AW:0] addra,
    input  wire [BDW:0] dina,
    output wire [BDW:0] douta,

    input  wire         clkb,
    input  wire         rstb,
    input  wire         ceb,
    input  wire         wrb,
    input  wire [ AW:0] addrb,
    input  wire [BDW:0] dinb,
    output wire [BDW:0] doutb
);

    localparam INIT_FILE0 = {FILE_BASE, "0.hex"};
    localparam INIT_FILE1 = {FILE_BASE, "1.hex"};
    localparam INIT_FILE2 = {FILE_BASE, "2.hex"};
    DPRAM #(.INIT_FILE(INIT_FILE0), .DP(DP), .DW(DW)) DPRAM0 (
        .clka(clka), .rsta(rsta), .cea(cea), .wra(wra), .addra(addra), .dina(dina[7:0]), .douta(douta[7:0]),
        .clkb(clkb), .rstb(rstb), .ceb(ceb), .wrb(wrb), .addrb(addrb), .dinb(dinb[7:0]), .doutb(doutb[7:0]));
    DPRAM #(.INIT_FILE(INIT_FILE1), .DP(DP), .DW(DW)) DPRAM1 (
        .clka(clka), .rsta(rsta), .cea(cea), .wra(wra), .addra(addra), .dina(dina[15:8]), .douta(douta[15:8]),
        .clkb(clkb), .rstb(rstb), .ceb(ceb), .wrb(wrb), .addrb(addrb), .dinb(dinb[15:8]), .doutb(doutb[15:8]));
    DPRAM #(.INIT_FILE(INIT_FILE2), .DP(DP), .DW(DW)) DPRAM2 (
        .clka(clka), .rsta(rsta), .cea(cea), .wra(wra), .addra(addra), .dina(dina[23:16]), .douta(douta[23:16]),
        .clkb(clkb), .rstb(rstb), .ceb(ceb), .wrb(wrb), .addrb(addrb), .dinb(dinb[23:16]), .doutb(doutb[23:16]));

endmodule
