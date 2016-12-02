
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name fpga -dir "C:/fpga/planAhead_run_1" -part xc6slx16csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/fpga/fpga_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/fpga} {ipcore_dir} }
set_property target_constrs_file "fpga_top.ucf" [current_fileset -constrset]
add_files [list {fpga_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
