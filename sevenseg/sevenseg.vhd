library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity virtual_7seg is
  generic(

    --Display settings
    num_displays : natural := 6;
    fg_colour : std_logic_vector(23 downto 0) := x"FF0000";
    bg_colour : std_logic_vector(23 downto 0) := x"000000";
    x_offset : natural := 576;
    y_offset : natural := 300;
    --Video parameters
    video_hlength : natural := 2200; --total visible and blanking pixels per line
    video_vlength : natural := 1125; --total visible and blanking lines per frame

    video_hsync_pol : boolean := true; --hsync polarity: true for positive sync, false for negative sync (does not affect framebuffer outputs)
    video_hsync_len : natural := 44; --horizontal sync length in pixels
    video_hbp_len : natural := 88; --horizontal back porch length (excluding sync)
    video_h_visible : natural := 1920; --number of visible pixels per line

    video_vsync_pol : boolean := true; --vsync polarity: true for positive sync, false for negative sync
    video_vsync_len : natural := 5; --vertical sync length in lines
    video_vbp_len : natural := 4; --vertical back porch length (excluding sync)
    video_v_visible : natural := 1080 --number of visible lines per frame
  );
  port(
    clock : in std_logic;
    enable : in std_logic;
    reset : in std_logic;

    segments : in std_logic_vector((7 * num_displays) - 1 downto 0); --note MSW is rightmost

    vsync : out std_logic;
    hsync : out std_logic;
    den : out std_logic;
    pixel_data : out std_logic_vector(23 downto 0)

  );
end virtual_7seg;



architecture Behavioral of virtual_7seg is

  type displays_t is array (0 to num_displays - 1) of std_logic_vector(6 downto 0);
  signal displays_pre_1, displays_pre_2, displays : displays_t;
  signal vsync_int, hsync_int, den_int : std_logic;
  signal pixel_int : std_logic_vector(23 downto 0);

  signal pixel_x : natural range 0 to video_h_visible - 1;
  signal pixel_y : natural range 0 to video_v_visible - 1;
begin
  process(clock)
  begin
    --Use multiple input registers to avoid any metastability issues
    if rising_edge(clock) then
      if enable = '1' then
        for i in 0 to num_displays - 1 loop
          displays_pre_1(i) <= segments((7 * i) + 6 downto (7 * i));
        end loop;
        displays_pre_2 <= displays_pre_1;
        displays <= displays_pre_2;
      end if;
    end if;
  end process;

  --Segment generator
  process(pixel_x, pixel_y, displays)
    variable disp_x : natural range 0 to video_h_visible - 1;
    variable disp_y : natural range 0 to video_v_visible - 1;

    variable cur_display : natural;
    variable xpos_in_display : natural;
  begin
    disp_x := pixel_x - x_offset;
    disp_y := pixel_y - y_offset;
    cur_display := disp_x / 128;
    xpos_in_display :=  disp_x mod 128;

    if (cur_display < num_displays) and (pixel_x >= x_offset) and (pixel_y >= y_offset) then
      if disp_y >= 160 and disp_y <= 180 and xpos_in_display >= 20 and xpos_in_display <= 108 and displays(cur_display)(0) = '0' then --segment a
        pixel_int <= fg_colour;
      elsif disp_y >= 160 and disp_y <= 240 and xpos_in_display >= 88 and xpos_in_display <= 108 and displays(cur_display)(1) = '0' then --segment b
        pixel_int <= fg_colour;
      elsif disp_y >= 240 and disp_y <= 320 and xpos_in_display >= 88 and xpos_in_display <= 108 and displays(cur_display)(2) = '0' then --segment c
        pixel_int <= fg_colour;
      elsif disp_y >= 300 and disp_y <= 320 and xpos_in_display >= 20 and xpos_in_display <= 108 and displays(cur_display)(3) = '0' then --segment d
        pixel_int <= fg_colour;
      elsif disp_y >= 240 and disp_y <= 320 and xpos_in_display >= 20 and xpos_in_display <= 40 and displays(cur_display)(4) = '0' then --segment e
        pixel_int <= fg_colour;
      elsif disp_y >= 160 and disp_y <= 240 and xpos_in_display >= 20 and xpos_in_display <= 40 and displays(cur_display)(5) = '0' then --segment f
        pixel_int <= fg_colour;
      elsif disp_y >= 230 and disp_y <= 250 and xpos_in_display >= 20 and xpos_in_display <= 108 and displays(cur_display)(6) = '0' then --segment g
        pixel_int <= fg_colour;
      else
        pixel_int <= bg_colour;
      end if;
    else
      pixel_int <= bg_colour;
    end if;
  end process;

  --Register outputs
  process(clock)
  begin
    if rising_edge(clock) then
      if enable = '1' then
        hsync <= hsync_int;
        vsync <= vsync_int;
        den <= den_int;
        pixel_data <= pixel_int;
      end if;
    end if;
  end process;

  --Video timing generator
  tmg : entity work.video_timing_ctrl
    generic map(
      video_hlength => video_hlength,
      video_vlength => video_vlength,

      video_hsync_pol => video_hsync_pol,
      video_hsync_len => video_hsync_len,
      video_hbp_len => video_hbp_len,
      video_h_visible => video_h_visible,

      video_vsync_pol => video_vsync_pol,
      video_vsync_len => video_vsync_len,
      video_vbp_len => video_vbp_len,
      video_v_visible => video_v_visible
    )
    port map(
      pixel_clock => clock,
      reset => reset,
      ext_sync => '0',
      timing_h_pos => open,
      timing_v_pos => open,
      pixel_x => pixel_x,
      pixel_y => pixel_y,
      video_vsync => vsync_int,
      video_hsync => hsync_int,
      video_den => den_int,
      video_line_start => open
    );
end Behavioral;
