library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Codec Audio Interface

--Copyright (C) 2016 David Shah
--Licensed under the MIT License

entity codec_audio_if is
  generic(
    fs_ratio : natural := 1024; --ratio between sampling frequency and input clock
    bits_per_frame : natural := 64; --number of bits per LRCLK frame -- note (fs_ratio/bits_per_frame) must be a power of two
    bit_depth : natural := 24; --audio bit depth
    lrclk_to_data : natural := 1); --LRCLK to data delay in BCK periods
  port(
    --User interface
    clock : in std_logic;
    reset : in std_logic; --active high, synchronous
    data_valid : out std_logic; --asserted 1 every fs_ratio clocks

    left_in : in std_logic_vector(bit_depth - 1 downto 0); --left and right inputs to codec DAC
    right_in : in std_logic_vector(bit_depth - 1 downto 0);

    left_out : out std_logic_vector(bit_depth - 1 downto 0); --left and right outputs from codec ADC
    right_out : out std_logic_vector(bit_depth - 1 downto 0);

    --CODEC interface
    codec_mclk : out std_logic; --this is just clock, repeated for readability and futureproofing
    codec_bclk : out std_logic; --codec serial bit clock
    codec_lrclk : out std_logic; --codec L/R framing
    codec_din : in std_logic; --serial data in from codec ADC
    codec_dout : out std_logic); --serial data out to codec DAC
end codec_audio_if;

architecture Behavioral of codec_audio_if is
  constant bclk_period : natural := (fs_ratio / bits_per_frame);
  constant field_period : natural := (bits_per_frame / 2);
  constant frame_end : natural := fs_ratio - 1;
  constant left_field_start : natural := lrclk_to_data;
  constant left_field_end : natural := lrclk_to_data + bit_depth - 1;
  constant right_field_start : natural := field_period + left_field_start;
  constant right_field_end : natural := field_period + left_field_end;

  signal master_counter : natural range 0 to fs_ratio - 1 := 0;
  signal bit_index : natural range 0 to bits_per_frame - 1;
  signal index_in_bclk : natural range 0 to bclk_period - 1;

  signal inl_shiftreg, inr_shiftreg, outl_shiftreg, outr_shiftreg : std_logic_vector(bit_depth - 1 downto 0);

  constant data_sample_pos : natural := bclk_period / 2;
  constant data_shiftout_pos : natural := 1;

begin

  --Main counter
  process(clock)
  begin
    if rising_edge(clock) then
      if reset = '1' then
        master_counter <= 0;
      else
        if master_counter = frame_end then
          master_counter <= 0;
        else
          master_counter <= master_counter + 1;
        end if;
      end if;
    end if;
  end process;

  bit_index <= master_counter / bclk_period;
  index_in_bclk <= master_counter mod bclk_period;

  --Shift Registers
  process(clock)
  begin
    if rising_edge(clock) then
      --Input shift register
      if master_counter = frame_end then --parallel load
        inl_shiftreg <= left_in;
        inr_shiftreg <= right_in;
      else
        if index_in_bclk = data_shiftout_pos then
          if bit_index >= left_field_start and bit_index <= left_field_end then
            inl_shiftreg(bit_depth - 1 downto 1) <= inl_shiftreg(bit_depth - 2 downto 0);
            inl_shiftreg(0) <= '0';
          end if;

          if bit_index >= right_field_start and bit_index <= right_field_end then
            inr_shiftreg(bit_depth - 1 downto 1) <= inr_shiftreg(bit_depth - 2 downto 0);
            inr_shiftreg(0) <= '0';
          end if;
        end if;
      end if;

      --Output shift register
      if master_counter = frame_end - 1 then --so valid as soon as data_outr_shiftregvalid asserted
        left_out <= outl_shiftreg;
        right_out <= outr_shiftreg;
      else
        if index_in_bclk = data_sample_pos then
          if bit_index >= left_field_start and bit_index <= left_field_end then
            outl_shiftreg(bit_depth - 1 downto 1) <= outl_shiftreg(bit_depth - 2 downto 0);
            outl_shiftreg(0) <= codec_din;
          end if;

          if bit_index >= right_field_start and bit_index <= right_field_end then
            outr_shiftreg(bit_depth - 1 downto 1) <= outr_shiftreg(bit_depth - 2 downto 0);
            outr_shiftreg(0) <= codec_din;
          end if;
        end if;
      end if;
    end if;
  end process;

  codec_dout <= inl_shiftreg(bit_depth - 1) when bit_index >= left_field_start and bit_index <= left_field_end else
                inr_shiftreg(bit_depth - 1) when bit_index >= right_field_start and bit_index <= right_field_end else
                '0';

  data_valid <= '1' when master_counter = frame_end else '0';

  codec_mclk <= clock;
  codec_bclk <= '0' when index_in_bclk < (bclk_period / 2) else '1';
  codec_lrclk <= '0' when bit_index < (bits_per_frame / 2) else '1';
end architecture;
