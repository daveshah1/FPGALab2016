# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -msgmgr_mode ooc_run
create_project -in_memory -part xc7k325tffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/dave/lab/projects/tonegen/tonegen.cache/wt [current_project]
set_property parent.project_path /home/dave/lab/projects/tonegen/tonegen.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/dave/lab/projects/tonegen/tonegen.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom.xci
set_property is_locked true [get_files /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom.xci]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

set cached_ip [config_ip_cache -export -no_bom -use_project_ipc -dir /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1 -new_name sine_rom -ip [get_ips sine_rom]]

if { $cached_ip eq {} } {

synth_design -top sine_rom -part xc7k325tffg900-2 -mode out_of_context

#---------------------------------------------------------
# Generate Checkpoint/Stub/Simulation Files For IP Cache
#---------------------------------------------------------
catch {
 write_checkpoint -force -noxdef -rename_prefix sine_rom_ sine_rom.dcp

 set ipCachedFiles {}
 write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sine_rom_stub.v
 lappend ipCachedFiles sine_rom_stub.v

 write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sine_rom_stub.vhdl
 lappend ipCachedFiles sine_rom_stub.vhdl

 write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sine_rom_sim_netlist.v
 lappend ipCachedFiles sine_rom_sim_netlist.v

 write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sine_rom_sim_netlist.vhdl
 lappend ipCachedFiles sine_rom_sim_netlist.vhdl

 config_ip_cache -add -dcp sine_rom.dcp -move_files $ipCachedFiles -use_project_ipc -ip [get_ips sine_rom]
}

rename_ref -prefix_all sine_rom_

write_checkpoint -force -noxdef sine_rom.dcp

catch { report_utilization -file sine_rom_utilization_synth.rpt -pb sine_rom_utilization_synth.pb }

if { [catch {
  file copy -force /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1/sine_rom.dcp /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}


} else {


if { [catch {
  file copy -force /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1/sine_rom.dcp /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  file rename -force /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1/sine_rom_stub.v /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1/sine_rom_stub.vhdl /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1/sine_rom_sim_netlist.v /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  file rename -force /home/dave/lab/projects/tonegen/tonegen.runs/sine_rom_synth_1/sine_rom_sim_netlist.vhdl /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

}; # end if cached_ip 

if {[file isdir /home/dave/lab/projects/tonegen/tonegen.ip_user_files/ip/sine_rom]} {
  catch { 
    file copy -force /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.v /home/dave/lab/projects/tonegen/tonegen.ip_user_files/ip/sine_rom
  }
}

if {[file isdir /home/dave/lab/projects/tonegen/tonegen.ip_user_files/ip/sine_rom]} {
  catch { 
    file copy -force /home/dave/lab/projects/tonegen/tonegen.srcs/sources_1/ip/sine_rom/sine_rom_stub.vhdl /home/dave/lab/projects/tonegen/tonegen.ip_user_files/ip/sine_rom
  }
}
