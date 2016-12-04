`timescale 1ns / 1ps

module ADAU1761Top(
	input clk,
	input [6:0] sw, //Switch
	input filter_onoff,
	input AC_GPIO1,
	input AC_GPIO2,
	input AC_GPIO3,
	output AC_GPIO0,
	output AC_ADR0,
	output AC_ADR1,
	output AC_MCLK,
	output AC_SCK,
	inout AC_SDA,
	input rst,  //begin the oLED stuff
	output sclk,
	output sdin,
	output dc,
	output vdd,
	output vbat,
	output reset,
	output debug1
	
	
	
);
	
	parameter Width = 16;
	// 48 MHz clock
	wire clk_48;
	Clock48MHZ c48(
    .CLK_100(clk),
    .CLK_48(clk_48)
	);
	
	// Audio module // 16 bits for each sample of data
	reg [Width-1 : 0] headphone_left, headphone_right, linein_left, linein_right;
	wire new_sample;
	
	wire [Width+5-1:0] filter0_l, filter0_r;
	wire [Width+5-1:0] filter1_l, filter1_r;
	wire [Width+5-1:0] filter2_l, filter2_r;
	
	wire [Width+5-1:0] line_in_ex_l, line_in_ex_r;
	reg [6:0] sw_synced;
	parameter hi = Width - 1;
	
	always @(posedge clk_48) begin
		sw_synced <= sw;
	end
	
	assign line_in_ex_l = linein_left[hi] & linein_left[hi] & linein_left[hi] & linein_left[hi] & linein_left[hi] & linein_left;
	assign line_in_ex_r = linein_right[hi] & linein_right[hi] & linein_right[hi] & linein_right[hi] & linein_right[hi] & linein_right;
	
	
	adau1761_izedboard( //line_in into the zedboard....headPhone out of the zedboard
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
	// Filter with different window width, ie. number of samples per sum
	low_pass_moving_sum #(.data_width(Width+5),.window_width(8)) lpms1_l (.clk(clk_48), .enable(new_sample), .sample_in(line_in_ex_l), .sample_out(filter1_l)); //line_in_ex and filter are 20bits
	low_pass_moving_sum #(.data_width(Width+5),.window_width(8)) lpms1_r (.clk(clk_48), .enable(new_sample), .sample_in(line_in_ex_r), .sample_out(filter1_r));
	low_pass_moving_sum #(.data_width(Width+5),.window_width(16)) lpms2_l (.clk(clk_48), .enable(new_sample), .sample_in(line_in_ex_l), .sample_out(filter2_l));
	low_pass_moving_sum #(.data_width(Width+5),.window_width(16)) lpms2_r (.clk(clk_48), .enable(new_sample), .sample_in(line_in_ex_r), .sample_out(filter2_r));
	
	always @(posedge clk_48) begin
		case (sw_synced)
			2'b00 : begin headphone_left <= linein_left; headphone_right <= linein_right; end
			2'b01 : begin headphone_left <= linein_left; headphone_right <= filter1_r[17:2]; end
			2'b10 : begin headphone_left <= filter1_l[17:2]; headphone_right <= linein_right; end
			2'b11 : begin headphone_left <= filter2_l[18:3]; headphone_right <= filter2_r[18:3]; end
		endcase
			
	end
	
	OLED cool (.clk(clk_48), .rst(rst), .mode(sw_synced), .sclk(sclk), .sdin(sdin), .dc(dc), .vdd(vdd), .vbat(vbat), .reset(reset), .debug1(debug1));
	
	

endmodule
