gui_open_window Wave
gui_sg_create Clock48MHZ_group
gui_list_add_group -id Wave.1 {Clock48MHZ_group}
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.test_phase}
gui_set_radix -radix {ascii} -signals {Clock48MHZ_tb.test_phase}
gui_sg_addsignal -group Clock48MHZ_group {{Input_clocks}} -divider
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.CLK_IN1}
gui_sg_addsignal -group Clock48MHZ_group {{Output_clocks}} -divider
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.dut.clk}
gui_list_expand -id Wave.1 Clock48MHZ_tb.dut.clk
gui_sg_addsignal -group Clock48MHZ_group {{Status_control}} -divider
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.RESET}
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.LOCKED}
gui_sg_addsignal -group Clock48MHZ_group {{Counters}} -divider
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.COUNT}
gui_sg_addsignal -group Clock48MHZ_group {Clock48MHZ_tb.dut.counter}
gui_list_expand -id Wave.1 Clock48MHZ_tb.dut.counter
gui_zoom -window Wave.1 -full
