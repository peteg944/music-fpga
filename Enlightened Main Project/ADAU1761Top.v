`timescale 1ns / 1ps

module ADAU1761Top(
	input clk,
	input filter_onoff,
	input AC_GPIO1,
	input AC_GPIO2,
	input AC_GPIO3,
	output AC_GPIO0,
	output AC_ADR0,
	output AC_ADR1,
	output AC_MCLK,
	output AC_SCK,
	inout AC_SDA
);
	
	// 48 MHz clock
	wire clk_48;
	Clock48MHZ c48(
    .CLK_100(clk),
    .CLK_48(clk_48)
	);
	
	// Audio module
	wire [15:0] headphone_left, headphone_right, linein_left, linein_right;
	wire new_sample;
	
	adau1761_izedboard(
	 .clk_48(clk_48),
	 .AC_GPIO1(AC_GPIO1),
	 .AC_GPIO2(AC_GPIO2),
	 .AC_GPIO3(AC_GPIO3),
	 .hphone_l(headphone_left),
	 .hphone_r(headphone_right),
	 .AC_SDA(AC_SDA),
	 .AC_ADR0(AC_ADR0),
	 .AC_ADR1(AC_ADR1),
	 .AC_GPIO0(AC_GPIO0),
	 .AC_MCLK(AC_MCLK),
	 .AC_SCK(AC_SCK),
	 .line_in_l(linein_left),
	 .line_in_r(linein_right),
	 .new_sample(new_sample)
	);
	
	// Send output to input
	assign headphone_left = linein_left;
	assign headphone_right = linein_right;

endmodule
