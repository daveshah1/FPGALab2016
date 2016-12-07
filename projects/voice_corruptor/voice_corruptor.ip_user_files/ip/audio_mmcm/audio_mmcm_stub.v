// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (lin64) Build 1682563 Mon Oct 10 19:07:26 MDT 2016
// Date        : Thu Nov 17 17:34:16 2016
// Host        : david-desktop-arch running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/dave/lab/projects/audio1/audio1.srcs/sources_1/ip/audio_mmcm/audio_mmcm_stub.v
// Design      : audio_mmcm
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module audio_mmcm(audio_clock, i2c_clock, sysclk)
/* synthesis syn_black_box black_box_pad_pin="audio_clock,i2c_clock,sysclk" */;
  output audio_clock;
  output i2c_clock;
  input sysclk;
endmodule
