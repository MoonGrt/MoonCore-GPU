/*
    // DPRAM Parameters
    parameter INIT_FILE = "init.hex";
    parameter DP = 512;
    parameter DW = 8;
    parameter AW = $clog2(DP) - 1;
    // DPRAM Signals
    reg           clka;
    reg           rsta;
    reg           cea;
    reg           wra;
    reg  [AW-1:0] addra;
    reg  [DW-1:0] dina;
    wire [DW-1:0] douta;
    reg           clkb;
    reg           rstb;
    reg           ceb;
    reg           wrb;
    reg  [AW-1:0] addrb;
    reg  [DW-1:0] dinb;
    wire [DW-1:0] doutb;
    // DPRAM Instance
    DPRAM #(
        .INIT_FILE(INIT_FILE),
        .DP       (DP),
        .DW       (DW),
        .AW       (AW)
    ) DPRAM (
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

module DPRAM #(
    parameter INIT_FILE = "init.hex",
    parameter DP = 512,
    parameter DW = 8,
    parameter AW = $clog2(DP)
) (
    input  wire          clka,
    input  wire          rsta,
    input  wire          cea,
    input  wire          wra,
    input  wire [AW-1:0] addra,
    input  wire [DW-1:0] dina,
    output reg  [DW-1:0] douta,

    input  wire          clkb,
    input  wire          rstb,
    input  wire          ceb,
    input  wire          wrb,
    input  wire [AW-1:0] addrb,
    input  wire [DW-1:0] dinb,
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
    always @(posedge CLKA) begin
        if (rsta) douta <= {DW{1'b0}};
        else if (wra) ram[addra] <= dina;
        else douta <= ram[addra];
    end

    // Port B logic
    wire CLKB = ceb ? clkb : 1'b0;
    always @(posedge CLKB) begin
        if (rstb) doutb <= {DW{1'b0}};
        else if (wrb) ram[addrb] <= dinb;
        else doutb <= ram[addrb];
    end

endmodule
