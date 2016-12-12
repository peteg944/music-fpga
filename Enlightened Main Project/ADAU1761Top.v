`timescale 1ns / 1ps

module ADAU1761Top(
	input clk,
	input rst,
	input filter_onoff,
	input filter_select,
	
	// audio codec
	input AC_GPIO1,
	input AC_GPIO2,
	input AC_GPIO3,
	output AC_GPIO0,
	output AC_ADR0,
	output AC_ADR1,
	output AC_MCLK,
	output AC_SCK,
	inout AC_SDA,
	
	// led matrix
	//input [3:0] shift,
	output [2:0] display_rgb1,
	output [2:0] display_rgb2,
	output [3:0] display_addr,
	output display_clk,
	output display_oe,
	output display_lat,
	//input on_off,
	
	// mic/ADC
	output spi_clk,
	output spi_mosi,
	output spi_cs,
	input spi_miso,
	output [7:0] sample, // leds to show mic sample
	
	// oled
	output sclk,
	output sdin,
	output dc,
	output vdd,
	output vbat,
	output reset,
	//output debug1,
	input switch
);
	wire throwaway, bt1, bt2, uart1, uart2, clean;
	reg [3:0] height;
	//reg mode, on_off; 
	
	initial begin
	height <=0;
	//mode <=0;
	//on_off <=0;
	end
	
	/*always @(posedge CLK_OUT2) begin
		mode <=switch;
		if (mode == 1'b0 && clean == 1'b1) begin
			on_off <= ~on_off;
		end
	end*/
	
	always @ (posedge clk_48) begin
		if (filter_onoff) begin
			height <= ((((headphone_left[14:0] >>> 14) ^ headphone_left) - (headphone_left >>>14)) >> 4) - 15;
			end 
		else begin
		height <= (((headphone_left >>> 15) ^ headphone_left) - (headphone_left >>> 15))  >> 4;
		end
	end
	
	// 48 MHz clock
	wire clk_48, CLK_OUT1, CLK_OUT2, LOCKED;
	
	Clock48MHZ c48(// Clock in ports
		    .CLK_100(clk),
			.CLK_48(clk_48),
			.CLK_OUT1(CLK_OUT1),
			.CLK_OUT2(CLK_OUT2),
  // Status and control signals
			.LOCKED(LOCKED)
 );
 
	//debouncer debounce(CLK_OUT2, sample[7], clean);
	
	wire [9:0] mic_output;
	//assign sample = mic_output[9:2]; // high 8 bits
	
 	MicrophoneSampler microphone(
	spi_clk,
	spi_mosi,
	spi_cs,
	spi_miso,
	CLK_OUT2,
	rst,
	mic_output);
	
	OLED oled(sclk,
				sdin,
				dc,
				vdd,
				vbat,
				reset,
				debug1,
				CLK_OUT2,
				rst,
				switch);
	
	// clap module
	wire home_state;
	wire [3:0] debug;
	Claps clapper(clk_48, rst, mic_output, home_state, debug);
	
	assign sample[7:4] = debug;
	assign sample[3:0] = 4'b0;
	
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
	
	fpga_top(
			  .clk(clk),
           .led(throwaway),
           .bluetooth_rxd(bt1),
           .bluetooth_txd(bt2),
           .display_rgb1(display_rgb1),
           .display_rgb2(display_rgb2),
           .display_addr(display_addr),
           .display_clk(display_clk),
           .display_oe(display_oe),
           .display_lat(display_lat),
           .usb_rxd(uart1),
           .usb_txd(uart2),
			  .height(height),
			  .mode(switch),  // Home vs. Party
			  .on_off(home_state), // In home, 1 means light on, 0 means light off
			  .sysclk(CLK_OUT1),
			  .pll_locked(LOCKED));
	
	// Filtering
	wire [15:0] lowpass_left, lowpass_right, highpass_left, highpass_right;
	LowPassFilter ll(clk_48, new_sample, linein_left, lowpass_left);
	LowPassFilter lr(clk_48, new_sample, linein_right, lowpass_right);
	HighPassFilter hl(clk_48, new_sample, linein_left, highpass_left);
	HighPassFilter hr(clk_48, new_sample, linein_right, highpass_right);
	
	assign headphone_left = (filter_onoff) ? (filter_select ? lowpass_left : highpass_left) : linein_left;
	assign headphone_right = (filter_onoff) ? (filter_select ? lowpass_right : highpass_right) : linein_right;
	
	//assign headphone_left = linein_left;
	//assign headphone_right = linein_right;

endmodule

module debouncer(clk, button, clean);
input clk, button;
output reg clean;

parameter delay = 25'h16E3600; // 24 million (half of 48 Mhz, so 0.5 second debounce rate)
reg [24:0] delay_count; 


always@(posedge clk)
	if (button==1) begin
		if (delay_count==delay) begin
			delay_count=delay_count+1'b1;
			clean=1;
		end else begin
			if(delay_count==10'b11111_11111) begin
				clean=0;
				delay_count=10'b11111_11111;
			end else begin
				delay_count=delay_count+1'b1;
				clean=0;
			end
		end
	end else begin
		delay_count=0;
		clean=0;
	end
	
endmodule

