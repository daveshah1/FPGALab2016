# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k325tffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/dave/lab/projects/ex6/ex6.cache/wt [current_project]
set_property parent.project_path /home/dave/lab/projects/ex6/ex6.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/dave/lab/projects/ex6/ex6.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files -quiet /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/sys_mmcm/sys_mmcm.dcp
set_property used_in_implementation false [get_files /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/sys_mmcm/sys_mmcm.dcp]
read_verilog -library xil_defaultlib {
  /home/dave/lab/exercises/add3_ge5.v
  /home/dave/lab/exercises/div_50000.v
  /home/dave/lab/exercises/hex_2_7seg.v
  /home/dave/lab/exercises/counter_16.v
  /home/dave/lab/exercises/bin2bcd_16.v
  /home/dave/lab/exercises/ex6_top.v
}
read_vhdl -library xil_defaultlib {
  /home/dave/lab/video-misc/video_timing_ctrl.vhd
  /home/dave/lab/dvi/dvi_tx_tmds_phy.vhd
  /home/dave/lab/dvi/dvi_tx_tmds_enc.vhd
  /home/dave/lab/dvi/dvi_tx_clk_drv.vhd
  /home/dave/lab/dvi/dvi_tx_top.vhd
  /home/dave/lab/sevenseg/sevenseg.vhd
  /home/dave/lab/projects/ex6/ex6.srcs/sources_1/new/hdmi_sevenseg_top.vhd
}
read_ip -quiet /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/dvi_pll/dvi_pll.xci
set_property used_in_implementation false [get_files -all /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/dvi_pll/dvi_pll_board.xdc]
set_property used_in_implementation false [get_files -all /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/dvi_pll/dvi_pll.xdc]
set_property used_in_implementation false [get_files -all /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/dvi_pll/dvi_pll_ooc.xdc]
set_property is_locked true [get_files /home/dave/lab/projects/ex6/ex6.srcs/sources_1/ip/dvi_pll/dvi_pll.xci]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/dave/lab/projects/ex6/ex6.srcs/constrs_1/imports/constrs_1/imports/new/genesys2.xdc
set_property used_in_implementation false [get_files /home/dave/lab/projects/ex6/ex6.srcs/constrs_1/imports/constrs_1/imports/new/genesys2.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top hdmi_sevenseg_top -part xc7k325tffg900-2


write_checkpoint -force -noxdef hdmi_sevenseg_top.dcp

catch { report_utilization -file hdmi_sevenseg_top_utilization_synth.rpt -pb hdmi_sevenseg_top_utilization_synth.pb }
