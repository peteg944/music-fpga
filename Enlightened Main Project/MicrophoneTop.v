`timescale 1ns / 1ps

module MicrophoneSampler(
	output spi_clk,
	output spi_mosi,
	output spi_cs,
	input spi_miso,
	input clk,
	input rst,
	output [9:0] sample
);
	
	localparam DELAY_20KHZ = 16'h1388; // decimal 5000 (100 mill / 20,000 = 5000)
	localparam DELAY_40KHZ = 16'h09C4; // decimal 2500 (100 mill / 40,000 = 2500)
	reg [12:0] counter; // 16-bit counter
	
	reg start_conv;
	wire [9:0] sample_out;
	Microphone mic(spi_clk, spi_mosi, spi_cs, spi_miso, clk, rst, start_conv, , sample);
	
	always @ (posedge clk) begin
		if(rst) begin
			counter <= 13'b0;
			start_conv <= 1'b0;
		end else begin
			if(counter == DELAY_40KHZ) begin
				start_conv <= 1'b1;
				counter <= 13'b0;
			end
			else begin
				start_conv <= 1'b0;
				counter <= counter + 1'b1;
				
				/*
				sample <= 10'h0;
				if(sample_out >= 10'h1FF)
					sample[0] <= 1'b1;
				if(sample_out >= 10'h23F)
					sample[1] <= 1'b1;
				if(sample_out >= 10'h27F)
					sample[2] <= 1'b1;
				if(sample_out >= 10'h2BF)
					sample[3] <= 1'b1;
				if(sample_out >= 10'h2FF)
					sample[4] <= 1'b1;
				if(sample_out >= 10'h33F)
					sample[5] <= 1'b1;
				if(sample_out >= 10'h37F)
					sample[6] <= 1'b1;
				if(sample_out >= 10'h3BF)
					sample[7] <= 1'b1;
				*/
			end
		end
	end

endmodule
