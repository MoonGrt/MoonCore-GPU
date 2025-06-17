/*
    // SDPRAM Parameters
    parameter T = 10;
    parameter INIT_FILE = "init.hex";
    parameter DP = 512;
    parameter DW = 8;
    parameter AW = $clog2(DP) - 1;
    // SDPRAM Inputs
    reg           clka;
    reg           rsta;
    reg           cea;
    reg  [AW-1:0] addra;
    reg  [DW-1:0] dina;
    reg           clkb;
    reg           rstb;
    reg           ceb;
    reg  [AW-1:0] addrb;
    wire [DW-1:0] doutb;
    // SDPRAM Instance
    SDPRAM #(
        .INIT_FILE(INIT_FILE),
        .DP       (DP),
        .DW       (DW),
        .AW       (AW)
    ) SDPRAM (
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

module SDPRAM #(
    parameter INIT_FILE = "init.hex",
    parameter DP = 512,
    parameter DW = 8,
    parameter AW = $clog2(DP)
) (
    input wire          clka,
    input wire          rsta,
    input wire          cea,
    input wire [AW-1:0] addra,
    input wire [DW-1:0] dina,

    input  wire          clkb,
    input  wire          rstb,
    input  wire          ceb,
    input  wire [AW-1:0] addrb,
    output reg  [DW-1:0] doutb
);

    // Memory declaration
    reg [DW-1:0] ram[0:DP-1];
    initial begin  // Initialize memory from file
        `define HEX_INIT_FILE
        // `define BIN_INIT_FILE
        if (INIT_FILE != "") begin
        `ifdef HEX_INIT_FILE
            $readmemh(INIT_FILE, ram);
        `elsif BIN_INIT_FILE
            $readmemb(INIT_FILE, ram);
        `else
            $error("Unsupported INIT_FILE_FORMAT");
        `endif
        end
    end

    // Port A logic
    wire CLKA = cea ? clka : 1'b0;
    always @(posedge CLKA) ram[addra] <= dina;

    // Port B logic
    wire CLKB = ceb ? clkb : 1'b0;
    always @(posedge CLKB) doutb <= ram[addrb];

endmodule
