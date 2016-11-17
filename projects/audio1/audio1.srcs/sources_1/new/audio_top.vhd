----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2016 10:30:13
-- Design Name: 
-- Module Name: hdmi_sevenseg_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity audio_top is
  Port (
  clock_p : in std_logic;
  clock_n : in std_logic;
  reset_n : in std_logic;
  
  hdmi_clk : out std_logic_vector(1 downto 0);
  hdmi_d0 : out std_logic_vector(1 downto 0);
  hdmi_d1 : out std_logic_vector(1 downto 0);
  hdmi_d2 : out std_logic_vector(1 downto 0);
  
  leds : out std_logic_vector(7 downto 0);
  sw : in std_logic_vector(7 downto 0);
  
  btn_l : in std_logic;
  btn_r : in std_logic;
  btn_u : in std_logic;
  btn_d : in std_logic;
  btn_c : in std_logic
  );
end audio_top;

architecture Behavioral of audio_top is
  signal sys_clock : std_logic;
  
  signal reset : std_logic;
  signal dvi_pixel_clock, dvi_bit_clock : std_logic;

  signal dvi_data : std_logic_vector(23 downto 0);
  signal dvi_den, dvi_hsync, dvi_vsync : std_logic;
  
  component dvi_pll is
    port(
      sysclk : in std_logic;
      pixel_clock : out std_logic;
      dvi_bit_clock : out std_logic);
  end component;
  
  component sys_mmcm is
    port(
      sysclk : in std_logic;
      clk50 : out std_logic);
  end component;
  
  component ex6_top is
    port(
      CLOCK_50 : in std_logic;
      KEY :  in std_logic_vector(3 downto 0);
      SW :   in std_logic_vector(7 downto 0);
      HEX0 : out std_logic_vector(6 downto 0);
      HEX1 : out std_logic_vector(6 downto 0);
      HEX2 : out std_logic_vector(6 downto 0);
      HEX3 : out std_logic_vector(6 downto 0);
      HEX4 : out std_logic_vector(6 downto 0));
  end component;
  
  signal segments_ck50 : std_logic_vector(41 downto 0);
  signal segments : std_logic_vector(41 downto 0);
  signal key : std_logic_vector(3 downto 0);
  signal clock_50 : std_logic;
begin
  reset <= not reset_n;
  
  clkbuf : IBUFGDS
    generic map(
      DIFF_TERM => TRUE,
      IBUF_LOW_PWR => FALSE,
      IOSTANDARD => "DEFAULT")
    port map(
      O => sys_clock,
      I => clock_p,
      IB => clock_n);
  
  pll1 : dvi_pll
    port map(
      sysclk => sys_clock,
      pixel_clock => dvi_pixel_clock,
      dvi_bit_clock => dvi_bit_clock
    );
  
  mmcm1 : sys_mmcm
    port map(
      sysclk => sys_clock,
      clk50 => clock_50);
  
  dvi_tx : entity work.dvi_tx
    port map(
      pixel_clock => dvi_pixel_clock,
      ddr_bit_clock => dvi_bit_clock,
      reset => reset,
      den => dvi_den,
      hsync => dvi_hsync,
      vsync => dvi_vsync,
      pixel_data => dvi_data,

      tmds_clk => hdmi_clk,
      tmds_d0 => hdmi_d0,
      tmds_d1 => hdmi_d1,
      tmds_d2 => hdmi_d2
    );
  
  legacy : ex6_top
    port map(
      CLOCK_50 => clock_50,
      KEY => key,
      SW => sw,
      HEX0 => segments(41 downto 35),
      HEX1 => segments(34 downto 28),
      HEX2 => segments(27 downto 21),
      HEX3 => segments(20 downto 14),
      HEX4 => segments(13 downto 7));
  
  key(0) <= not btn_l;
  key(1) <= not btn_c;
  key(2) <= not btn_r;
  key(3) <= not btn_u;
  
  segments(6 downto 0) <= "1000000";
  
  process(clock_50)
  begin
    if rising_edge(clock_50) then
      segments_ck50 <= segments;
    end if;
  end process; 
  
  sevenseg : entity work.virtual_7seg
     generic map (
      num_displays => 6,
      fg_colour => x"FF0000",
      bg_colour => x"000000",
      x_offset => 576,
      y_offset => 300,

      video_hlength => 2200,
      video_vlength => 1125,
      
      video_hsync_pol => true,
      video_hsync_len => 44,
      video_hbp_len => 88,
      video_h_visible => 1920,
  
      video_vsync_pol => true,
      video_vsync_len => 5,
      video_vbp_len => 4,
      video_v_visible => 1080)
    port map(
      clock => dvi_pixel_clock,
      enable => '1',
      reset => reset,
  
      segments => segments_ck50,
  
      vsync => dvi_vsync,
      hsync => dvi_hsync,
      den => dvi_den,
      pixel_data => dvi_data);
  
  leds <= x"00";
end Behavioral;
