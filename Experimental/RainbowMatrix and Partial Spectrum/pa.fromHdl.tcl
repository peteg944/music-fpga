
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Enlightened -dir "X:/Xilinx projects/music-fpga/planAhead_run_1" -part xc7z020clg484-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "ADAU1761Top.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ipcore_dir/Clock48MHZ.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/Clock48MHZ/example_design/Clock48MHZ_exdes.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {i3c2.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {adau1761_configuraiton_data.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {i2s_data_interface.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {i2c.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ADAU1761_interface.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {adau1761_izedboard.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ADAU1761Top.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top ADAU1761Top $srcset
add_files [list {ADAU1761Top.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc7z020clg484-3
