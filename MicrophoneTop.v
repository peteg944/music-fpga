`timescale 1ns / 1ps

module MicrophoneTop(
	output spi_clk,
	output spi_mosi,
	output spi_cs,
	input spi_miso,
	input clk,
	input rst,
	output [7:0] sample
);

	reg [12:0] counter; // 13-bit counter to count to the value 0x1388 (dec. 5000)
						// at 100 Mhz, the counter will reach 5000 at a 20 kHz rate
	
	reg start_conv;
	wire [9:0] sample_out;
	Microphone mic(spi_clk, spi_mosi, spi_cs, spi_miso, clk, rst, start_conv, , sample_out);
	
	assign sample = sample_out[9:2];
	
	always @ (posedge clk) begin
		if(rst) begin
			counter <= 13'b0;
			start_conv <= 1'b0;
		end else begin
			if(counter == 13'd5000) begin
				start_conv <= 1'b1;
				counter <= 13'b0;
			end
			else begin
				start_conv <= 1'b0;
				counter <= counter + 1'b1;
			end
		end
	end

endmodule
