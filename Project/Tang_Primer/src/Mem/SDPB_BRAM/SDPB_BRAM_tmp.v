//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.02
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Mon Jun 16 15:11:09 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    SDPB_BRAM your_instance_name(
        .dout(dout), //output [23:0] dout
        .clka(clka), //input clka
        .cea(cea), //input cea
        .reseta(reseta), //input reseta
        .clkb(clkb), //input clkb
        .ceb(ceb), //input ceb
        .resetb(resetb), //input resetb
        .oce(oce), //input oce
        .ada(ada), //input [14:0] ada
        .din(din), //input [23:0] din
        .adb(adb) //input [14:0] adb
    );

//--------Copy end-------------------
