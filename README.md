# Imperial FPGA Lab Nov/Dec 2016

As I was doing the lab on my own, I have decided to make things more interesting by
doing it on a Genesys 2 development board instead of the DE1-SoC.

This board is powered by the Xilinx Kintex-7 XC7K325T FPGA so the Xilinx Vivado IDE
was used instead of Quartus.

A significant amount of support code has been written to enable the lab exercies to be
run on the board in an environment as similar as possible to the DE1-SoC.

The Genesys 2 does not have any 7-segment displays. As a result I have implemented
virtual 7-segment displays on a monitor connected to the HDMI output. This uses a DVI transmitter core
I've written previously. Note that DVI signalling is used as it's slightly simpler to implement
than HDMI and HDMI devices will accept it (HDMI signalling is very similar but includes audio). In any
case I'm connecting the board to a monitor with a DVI to HDMI adapter cable.

Also instead of using the expansion board with seperate SPI ADCs and DACs; I'm using the built-in audio
codec IC (Analog Devices ADAU1761). This uses I²C for control and I²S for audio data. I have written
the code to configure it with sensible register values to use the headphone output/line input; and provide
an audio interface to the FPGA code similar to the 'official' one.

The main difference in the audio processing blocks is that they use 24-bit sampling depth
and 48kHz sample rate as opposed to 10-bit/10kHz; which provides significantly improved audio quality.
The audio codec also supports stereo audio, to take advantage of this I have instantiated the echo blocks
twice, once for each channel.

The custom driver code for the virtual 7-segment and audio codec; as well as the top level entities; have been
written in VHDL which I prefer to Verilog. The blocks created for the lab exercises have been written in Verilog
as required.

The custom driver code is all released under the MIT License. The DVI interface code has already appeared in a previous
repository of mine (a [4k camera interface](https://github.com/daveshah1/CSI2Rx)).
