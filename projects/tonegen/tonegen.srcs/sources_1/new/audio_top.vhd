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
  btn_c : in std_logic;
  
  codec_sda : inout std_logic;
  codec_scl : inout std_logic;
  codec_addr : out std_logic_vector(1 downto 0);
  
  codec_mclk : out std_logic;
  codec_bclk : out std_logic;
  codec_lrclk : out std_logic;
  codec_din : in std_logic;
  codec_dout : out std_logic
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
  
 component audio_mmcm is
    port(
      sysclk : in std_logic;
      audio_clock : out std_logic;
      i2c_clock : out std_logic);
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
  
  component fixed_tone is
    port(
      clock : in std_logic;
      valid : in std_logic;
      audio_out : out std_logic_vector(23 downto 0));
  end component;
  
  signal tone_sig : std_logic_vector(23 downto 0);
  
  --Digital audio I/Os
  signal left_line, right_line, left_hp, right_hp : std_logic_vector(23 downto 0);
  signal mclk_int, bclk_int, lrclk_int, codec_dout_int : std_logic;
  
  signal segments_ck50 : std_logic_vector(41 downto 0);
  signal segments : std_logic_vector(41 downto 0);
  signal key : std_logic_vector(3 downto 0);
  signal clock_50 : std_logic;
  
  signal audio_clock, i2c_clk_in, i2c_clk_div_pre, i2c_clk_div : std_logic;
  signal audio_valid : std_logic;
  
  --BEGIN DEBUG
  component ila_0 is
    port(
      clk : in std_logic;
      probe0 : in std_logic_vector(23 downto 0);
      probe1 : in std_logic_vector(23 downto 0);
      probe2 : in std_logic_vector(0 downto 0);
      probe3 : in std_logic_vector(0 downto 0);
      probe4 : in std_logic_vector(0 downto 0);
      probe5 : in std_logic_vector(0 downto 0);
      probe6 : in std_logic_vector(0 downto 0));
  end component;
  signal probe0 : std_logic_vector(1 downto 0);
  --END DEBUG
begin
  reset <= not reset_n;
  
  tg : fixed_tone port map(
    clock => audio_clock,
    valid => audio_valid,
    audio_out => tone_sig);
  
  left_hp <= tone_sig;
  right_hp <= tone_sig;
  
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
 
  mmcm2 : audio_mmcm
    port map(
      sysclk => sys_clock,
      audio_clock => audio_clock,
      i2c_clock => i2c_clk_in);
 
 --Divide 5MHz from MMCM to slower I2C clock, as sufficiently slow clock cannot be generated
  i2c_clkdiv : BUFR
    generic map(
      BUFR_DIVIDE => "8",
      SIM_DEVICE => "7SERIES")
    port map(
      O => i2c_clk_div_pre,
      CE => '1',
      CLR => reset,
      I => i2c_clk_in);
  i2c_clkdiv2 : BUFR
    generic map(
      BUFR_DIVIDE => "8",
      SIM_DEVICE => "7SERIES")
    port map(
      O => i2c_clk_div,
      CE => '1',
      CLR => reset,
      I => i2c_clk_div_pre);  
      
--  left_hp <= left_line;
--  right_hp <= right_line;
  
  codec_if : entity work.codec_audio_if
    generic map(
      fs_ratio => 1024,
      bits_per_frame => 64,
      bit_depth => 24,
      lrclk_to_data => 1)
    port map(
      clock => audio_clock,
      reset => reset,
      data_valid => audio_valid,
      
      left_in => left_hp,
      right_in => right_hp,
      left_out => left_line,
      right_out => right_line,
      
      codec_mclk => mclk_int,
      codec_bclk => bclk_int,
      codec_lrclk => lrclk_int,
      codec_din => codec_din,
      codec_dout => codec_dout_int);
  
  codec_mclk <= mclk_int;
  codec_bclk <= bclk_int;
  codec_lrclk <= lrclk_int;
  codec_dout <= codec_dout_int;
  
  codec_ctl : entity work.adau1761_control
    port map(
      reset => reset,
      clock => i2c_clk_div,
      i2c_sda => codec_sda,
      i2c_sck => codec_scl,
      loading_out => open);
  
  codec_addr <= "11";
  
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
      tmds_d2 => hdmi_d2);
      
  key(0) <= not btn_l;
  key(1) <= not btn_c;
  key(2) <= not btn_r;
  key(3) <= not btn_u;
  
  segments <= "100000010000001000000100000010000001000000";
  
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
  
  --BEGIN DEBUG
--  probe0 <= codec_sda & codec_scl;
--  dbg0 : ila_0
--    port map(
--      clk => audio_clock,
--      probe0 => left_line,
--      probe1 => left_hp,
--      probe2(0) => audio_valid,
--      probe3(0) => lrclk_int,
--      probe4(0) => bclk_int,
--      probe5(0) => codec_dout_int,
--      probe6(0) => codec_din);
  --END DEBUG
end Behavioral;
