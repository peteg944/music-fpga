
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Enlightened -dir "C:/Users/User/Documents/Xilinx Projects/Enlightened/planAhead_run_3" -part xc7z020clg484-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "OLED.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../SPITest/SPI.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {OLED.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top OLED $srcset
add_files [list {OLED.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc7z020clg484-3
