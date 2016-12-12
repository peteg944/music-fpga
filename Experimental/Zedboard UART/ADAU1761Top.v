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
	inout AC_SDA,
	input [3:0] shift,
		output [2:0] display_rgb1,
		output [2:0] display_rgb2,
		output [3:0] display_addr,
		output display_clk,
		output display_oe,
		output display_lat,
		//input on_off,
		
			output spi_clk,
	output spi_mosi,
	output spi_cs,
	input spi_miso,
		input rst,
	output [7:0] sample,
	output usb_rxd,
   input usb_txd,
	input mode, 
	input uart_active
		
);
	wire throwaway, bt1, bt2, uart1, uart2, clean;
	reg [3:0] height;
	reg on_off; 
	
	initial begin
	height <=0;
	on_off <=0;
	end
	
	always @(posedge CLK_OUT2) begin
		if (mode == 1'b0 && clean == 1'b1) begin
			on_off <= ~on_off;
		end
	end
	always @ (posedge clk_48) begin
		if (filter_onoff) begin
			height <= ((((headphone_left[14:0] >>> 14) ^ headphone_left) - (headphone_left >>>14)) >> shift) - 15;
			end 
		else begin
		height <= (((headphone_left >>> 15) ^ headphone_left) - (headphone_left >>> 15))  >> 4;
		end
	end
	
	
	// 48 MHz clock
	wire clk_48, CLK_OUT1, CLK_OUT2, CLK_OUT4,  LOCKED;
	
	Clock48MHZ c48(// Clock in ports
		    .CLK_100(clk),
			.CLK_48(clk_48),
			.CLK_OUT1(CLK_OUT1),
			.CLK_OUT2(CLK_OUT2),
			.CLK_OUT4(CLK_OUT4),
  // Status and control signals
			.LOCKED(LOCKED)
 );
 
	
 	MicrophoneSampler microphone(
	spi_clk,
	spi_mosi,
	spi_cs,
	spi_miso,
	CLK_OUT2,
	rst,
	sample);

 
/*	Clock48MHZ c48(
    .CLK_100(clk),
    .CLK_48(clk_48)
	);*/
	
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
           .usb_rxd(usb_rxd),
           .usb_txd(usb_txd),
			  .height(height),
			  .mode(mode),
			  .on_off(on_off),
			  .sysclk(CLK_OUT1),
			  .uartclk(CLK_OUT4),
			  .uart_active(uart_active),
			  .pll_locked(LOCKED));
	
	wire [15:0] filter_out_left, filter_out_right;
	SystolicFilter(clk_48, new_sample, linein_left, filter_out_left);
	SystolicFilter(clk_48, new_sample, linein_right, filter_out_right);
	
	assign headphone_left = (filter_onoff) ? filter_out_left : linein_left;
	assign headphone_right = (filter_onoff) ? filter_out_right : linein_right;

endmodule


module debouncer(clk, button, clean);
input clk, button;
output reg clean;

parameter delay = 500;
reg [8:0] delay_count; 


always@(posedge clk)
	if (button==1) begin
		if (delay_count==delay) begin
			assign delay_count=delay_count+1'b1;
			assign clean=1;
		end else begin
			if(delay_count==9'b1111_11111) begin
				assign clean=0;
				assign delay_count=9'b1111_11111;
			end else begin
				assign delay_count=delay_count+1'b1;
				assign clean=0;
			end
		end
	end else begin
		assign delay_count=0;
		assign clean=0;
	end
	
endmodule

