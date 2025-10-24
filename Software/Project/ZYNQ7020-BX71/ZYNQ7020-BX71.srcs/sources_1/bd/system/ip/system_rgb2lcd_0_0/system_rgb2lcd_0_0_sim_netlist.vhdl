-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sun Apr  7 11:25:28 2024
-- Host        : Holden running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               C:/Users/maxhy/Downloads/Compressed/ACZ7015_Linux_Factory/ACZ7015_Linux_Factory.srcs/sources_1/bd/system/ip/system_rgb2lcd_0_0/system_rgb2lcd_0_0_sim_netlist.vhdl
-- Design      : system_rgb2lcd_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_rgb2lcd_0_0_rgb2lcd is
  port (
    lcd_hs : out STD_LOGIC;
    lcd_vs : out STD_LOGIC;
    lcd_de : out STD_LOGIC;
    data : out STD_LOGIC_VECTOR ( 15 downto 0 );
    rgb_vde : in STD_LOGIC;
    rgb_data_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    rgb_hsync : in STD_LOGIC;
    pixel_clk : in STD_LOGIC;
    rgb_vsync : in STD_LOGIC;
    rst_n : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of system_rgb2lcd_0_0_rgb2lcd : entity is "rgb2lcd";
end system_rgb2lcd_0_0_rgb2lcd;

architecture STRUCTURE of system_rgb2lcd_0_0_rgb2lcd is
  signal \RGB_Data[10]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[11]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[12]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[13]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[14]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[15]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[19]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[20]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[21]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[22]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[23]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[3]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[4]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[5]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[6]_i_1_n_0\ : STD_LOGIC;
  signal \RGB_Data[7]_i_1_n_0\ : STD_LOGIC;
  signal lcd_hs_i_1_n_0 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \RGB_Data[10]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \RGB_Data[11]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \RGB_Data[12]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \RGB_Data[13]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \RGB_Data[14]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \RGB_Data[15]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \RGB_Data[19]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \RGB_Data[20]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \RGB_Data[21]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \RGB_Data[22]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \RGB_Data[23]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \RGB_Data[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \RGB_Data[4]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \RGB_Data[5]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \RGB_Data[6]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \RGB_Data[7]_i_1\ : label is "soft_lutpair2";
begin
\RGB_Data[10]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(5),
      O => \RGB_Data[10]_i_1_n_0\
    );
\RGB_Data[11]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(6),
      O => \RGB_Data[11]_i_1_n_0\
    );
\RGB_Data[12]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(7),
      O => \RGB_Data[12]_i_1_n_0\
    );
\RGB_Data[13]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(8),
      O => \RGB_Data[13]_i_1_n_0\
    );
\RGB_Data[14]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(9),
      O => \RGB_Data[14]_i_1_n_0\
    );
\RGB_Data[15]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(10),
      O => \RGB_Data[15]_i_1_n_0\
    );
\RGB_Data[19]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(11),
      O => \RGB_Data[19]_i_1_n_0\
    );
\RGB_Data[20]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(12),
      O => \RGB_Data[20]_i_1_n_0\
    );
\RGB_Data[21]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(13),
      O => \RGB_Data[21]_i_1_n_0\
    );
\RGB_Data[22]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(14),
      O => \RGB_Data[22]_i_1_n_0\
    );
\RGB_Data[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(15),
      O => \RGB_Data[23]_i_1_n_0\
    );
\RGB_Data[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(0),
      O => \RGB_Data[3]_i_1_n_0\
    );
\RGB_Data[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(1),
      O => \RGB_Data[4]_i_1_n_0\
    );
\RGB_Data[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(2),
      O => \RGB_Data[5]_i_1_n_0\
    );
\RGB_Data[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(3),
      O => \RGB_Data[6]_i_1_n_0\
    );
\RGB_Data[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rgb_vde,
      I1 => rgb_data_in(4),
      O => \RGB_Data[7]_i_1_n_0\
    );
\RGB_Data_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[10]_i_1_n_0\,
      Q => data(5)
    );
\RGB_Data_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[11]_i_1_n_0\,
      Q => data(6)
    );
\RGB_Data_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[12]_i_1_n_0\,
      Q => data(7)
    );
\RGB_Data_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[13]_i_1_n_0\,
      Q => data(8)
    );
\RGB_Data_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[14]_i_1_n_0\,
      Q => data(9)
    );
\RGB_Data_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[15]_i_1_n_0\,
      Q => data(10)
    );
\RGB_Data_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[19]_i_1_n_0\,
      Q => data(11)
    );
\RGB_Data_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[20]_i_1_n_0\,
      Q => data(12)
    );
\RGB_Data_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[21]_i_1_n_0\,
      Q => data(13)
    );
\RGB_Data_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[22]_i_1_n_0\,
      Q => data(14)
    );
\RGB_Data_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[23]_i_1_n_0\,
      Q => data(15)
    );
\RGB_Data_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[3]_i_1_n_0\,
      Q => data(0)
    );
\RGB_Data_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[4]_i_1_n_0\,
      Q => data(1)
    );
\RGB_Data_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[5]_i_1_n_0\,
      Q => data(2)
    );
\RGB_Data_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[6]_i_1_n_0\,
      Q => data(3)
    );
\RGB_Data_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => \RGB_Data[7]_i_1_n_0\,
      Q => data(4)
    );
lcd_de_reg: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => rgb_vde,
      Q => lcd_de
    );
lcd_hs_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst_n,
      O => lcd_hs_i_1_n_0
    );
lcd_hs_reg: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => rgb_hsync,
      Q => lcd_hs
    );
lcd_vs_reg: unisim.vcomponents.FDCE
     port map (
      C => pixel_clk,
      CE => '1',
      CLR => lcd_hs_i_1_n_0,
      D => rgb_vsync,
      Q => lcd_vs
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_rgb2lcd_0_0 is
  port (
    rgb_data_in : in STD_LOGIC_VECTOR ( 23 downto 0 );
    rgb_vde : in STD_LOGIC;
    rgb_hsync : in STD_LOGIC;
    rgb_vsync : in STD_LOGIC;
    pixel_clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    lcd_pclk : out STD_LOGIC;
    lcd_rstn : out STD_LOGIC;
    lcd_hs : out STD_LOGIC;
    lcd_vs : out STD_LOGIC;
    lcd_de : out STD_LOGIC;
    lcd_bl : out STD_LOGIC;
    data : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of system_rgb2lcd_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of system_rgb2lcd_0_0 : entity is "system_rgb2lcd_0_0,rgb2lcd,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of system_rgb2lcd_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of system_rgb2lcd_0_0 : entity is "package_project";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of system_rgb2lcd_0_0 : entity is "rgb2lcd,Vivado 2018.3";
end system_rgb2lcd_0_0;

architecture STRUCTURE of system_rgb2lcd_0_0 is
  signal \<const1>\ : STD_LOGIC;
  signal \^pixel_clk\ : STD_LOGIC;
  signal \^rst_n\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of lcd_bl : signal is "xilinx.com:user:lcd:1.0 lcd bl";
  attribute X_INTERFACE_INFO of lcd_de : signal is "xilinx.com:user:lcd:1.0 lcd de";
  attribute X_INTERFACE_INFO of lcd_hs : signal is "xilinx.com:user:lcd:1.0 lcd hs";
  attribute X_INTERFACE_INFO of lcd_pclk : signal is "xilinx.com:user:lcd:1.0 lcd pclk";
  attribute X_INTERFACE_INFO of lcd_rstn : signal is "xilinx.com:signal:reset:1.0 lcd_rstn RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of lcd_rstn : signal is "XIL_INTERFACENAME lcd_rstn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of lcd_vs : signal is "xilinx.com:user:lcd:1.0 lcd vs";
  attribute X_INTERFACE_INFO of pixel_clk : signal is "xilinx.com:signal:clock:1.0 pixel_clk CLK";
  attribute X_INTERFACE_PARAMETER of pixel_clk : signal is "XIL_INTERFACENAME pixel_clk, ASSOCIATED_BUSIF pixel_clk, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rgb_hsync : signal is "xilinx.com:interface:vid_io:1.0 vid_rgb HSYNC";
  attribute X_INTERFACE_INFO of rgb_vde : signal is "xilinx.com:interface:vid_io:1.0 vid_rgb ACTIVE_VIDEO";
  attribute X_INTERFACE_INFO of rgb_vsync : signal is "xilinx.com:interface:vid_io:1.0 vid_rgb VSYNC";
  attribute X_INTERFACE_INFO of rst_n : signal is "xilinx.com:signal:reset:1.0 rst_n RST";
  attribute X_INTERFACE_PARAMETER of rst_n : signal is "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of data : signal is "xilinx.com:user:lcd:1.0 lcd data";
  attribute X_INTERFACE_INFO of rgb_data_in : signal is "xilinx.com:interface:vid_io:1.0 vid_rgb DATA";
begin
  \^pixel_clk\ <= pixel_clk;
  \^rst_n\ <= rst_n;
  lcd_bl <= \<const1>\;
  lcd_pclk <= \^pixel_clk\;
  lcd_rstn <= \^rst_n\;
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.system_rgb2lcd_0_0_rgb2lcd
     port map (
      data(15 downto 0) => data(15 downto 0),
      lcd_de => lcd_de,
      lcd_hs => lcd_hs,
      lcd_vs => lcd_vs,
      pixel_clk => \^pixel_clk\,
      rgb_data_in(15 downto 11) => rgb_data_in(23 downto 19),
      rgb_data_in(10 downto 5) => rgb_data_in(15 downto 10),
      rgb_data_in(4 downto 0) => rgb_data_in(7 downto 3),
      rgb_hsync => rgb_hsync,
      rgb_vde => rgb_vde,
      rgb_vsync => rgb_vsync,
      rst_n => \^rst_n\
    );
end STRUCTURE;
