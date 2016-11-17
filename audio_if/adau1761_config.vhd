library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--ADAU1761 configuration

--Copyright (C) 2016 David Shah
--Licensed under the MIT License


entity adau1761_config is
port (clock : in std_logic; --this allows a blockram to be elaborated
  		address : in std_logic_vector(8 downto 0);
  		--This is the I2C data to be written
  		--2 MSBs are address, 1 MSB is data
  		data : out std_logic_vector(23 downto 0));
end adau1761_config;

architecture behv_cd of adau1761_config is
begin
	process(clock)
	begin
		if rising_edge(clock) then
			case address(8 downto 0) is
				when "0" & x"00" =>
					data <= x"400007"; --PLL off, core clock enables, 1024xFs
        when "0" & x"10" =>
          data <= x"400A01"; --Left record mixer enable
        when "0" & x"11" =>
          data <= x"400B05"; --Left record mixer: AUX (Genesys 2 Line In) gain 0dB
        when "0" & x"12" =>
          data <= x"400C01"; --Right record mixer enable
        when "0" & x"13" =>
          data <= x"400D05"; --Right record mixer: AUX (Genesys 2 Line In) gain 0dB
        when "0" & x"20" =>
          data <= x"401500"; --Serial port: use R17 Fs, 50% LRCLK duty, falling edge BCLK and LRCLK polarity, stereo, slave
        when "0" & x"21" =>
          data <= x"401600"; --Serial port: 64 bits per LRCLK frame, ADC and DAC left first, MSB first, data delay 1 from LRCLK edge
        when "0" & x"22" =>
          data <= x"401700"; --Converter: first DAC pair, 128x ADC and DAC oversampling, Fs sampling rate
        when "0" & x"23" =>
          data <= x"401800"; --Converter: first ADC pair
        when "0" & x"30" =>
          data <= x"401C21"; --Left playback mixer: unmute left DAC in, mute aux input in
        when "0" & x"31" =>
          data <= x"401E41"; --Right playback mixer: unmute right DAC in, mute aux input in
        when "0" & x"32" =>
          data <= x"4023C1"; --Left headphone out: -9dB volume, HP output enabled
        when "0" & x"33" =>
          data <= x"4024C1"; --Right headphone out: -9dB volume, HP output disabled
        when "0" & x"34" =>
          data <= x"402903"; --Playback power management: no power saving, enable L+R outputs
        when "0" & x"40" =>
          data <= x"402A03"; --DAC Control: Stereo, normal polarity, no de-emphasis, both DACs enabled
        when "0" & x"41" =>
          data <= x"402B00"; --Left DAC: no digital attenuation
        when "0" & x"42" =>
          data <= x"402C00"; --Right DAC: no digital attenuation
        when "0" & x"50" =>
          data <= x"40F97F"; --All clocks enabled
        when "0" & x"51" =>
          data <= x"40FA01"; --Clock generator 1 enabled
				when others =>
					data <= x"000000";
			end case;
		end if;
	end process;
end behv_cd;
