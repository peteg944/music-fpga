
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Enlightened -dir "X:/Xilinx projects/music-fpga/planAhead_run_1" -part xc7z020clg484-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "MicrophoneTop.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {SPI.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Microphone.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {MicrophoneTop.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top MicrophoneTop $srcset
add_files [list {MicrophoneTop.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc7z020clg484-3
