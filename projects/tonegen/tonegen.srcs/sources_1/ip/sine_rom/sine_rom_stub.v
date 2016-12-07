// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (lin64) Build 1682563 Mon Oct 10 19:07:26 MDT 2016
// Date        : Wed Dec  7 14:13:55 2016
// Host        : david-desktop-arch running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.v
// Design      : sine_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_4,Vivado 2016.3" *)
module sine_rom(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[9:0],douta[9:0]" */;
  input clka;
  input [9:0]addra;
  output [9:0]douta;
endmodule
