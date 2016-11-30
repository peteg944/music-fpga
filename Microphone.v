`timescale 1ns / 1ps

module Microphone(
	output spi_clk,				// SPI clock to ADC
	output spi_mosi,			// Data to ADC
	output reg spi_cs,			// Chip select for ADC
	input spi_miso,				// Data from ADC
	input clk,
	input rst,
	input start_sample,			// Set to 1 to sample the ADC
	output reg sample_done,		// Latest sample is ready to be read
	output reg [9:0] sample
);

	// The 10-bit ADC sample
	reg sample_done_d;
	reg [9:0] sample_d;
	
	// SPI module
	reg spi_start, spi_start_d;
	reg spi_cs_d;
	reg [7:0] spi_mosi_byte, spi_mosi_byte_d;
	wire [7:0] spi_miso_byte;
	wire spi_done;
	SPI #(7) spi(clk, rst, spi_miso, spi_mosi, spi_clk, spi_start, spi_mosi_byte, spi_miso_byte, , spi_done);
	
	// States
	reg [3:0] state, state_d; // State of the module
	reg [3:0] state_after, state_after_d; // State to go to after waiting for spi to be done
	localparam	SPI_START =		4'd0,
				SPI_WAIT =			4'd1,
				IDLE =				4'd2,
				CS_LOW =				4'd3,
				SEND_START =		4'd4,
				SEND_CHANNEL =		4'd5,
				RECV_2BITS =		4'd6,
				SEND_ZEROS =		4'd7,
				RECV_8BITS =		4'd8,
				CS_HIGH =			4'd9;
	
	// Sequential logic
	always @ (posedge clk) begin
		if(rst) begin
			sample <= 10'b0;
			sample_done <= 1'b0;
			spi_start <= 1'b0;
			spi_cs <= 1'b1;
			spi_mosi_byte <= 8'b0;
			state <= IDLE;
			state_after <= IDLE;
		end else begin
			sample <= sample_d;
			sample_done <= sample_done_d;
			spi_start <= spi_start_d;
			spi_cs <= spi_cs_d;
			spi_mosi_byte <= spi_mosi_byte_d;
			state <= state_d;
			state_after <= state_after_d;
		end
	end
	
	// Combinational logic
	always @ (*) begin
		sample_d = sample;
		sample_done_d = 1'b0;
		spi_start_d = 1'b0;
		spi_cs_d = spi_cs;
		spi_mosi_byte_d = spi_mosi_byte;
		state_d = state;
		state_after_d = state_after;
		
		case(state)
			IDLE: begin
				if(start_sample == 1'b1) begin
					spi_cs_d = 1'b0; // chip select low
					state_d = SEND_START;
				end
			end
			SEND_START: begin
				spi_mosi_byte_d = 8'h01;
				state_d = SPI_START;
				state_after_d = SEND_CHANNEL;
			end
			SEND_CHANNEL: begin
				spi_mosi_byte_d = 8'h00; // Read from ADC channel 0
				state_d = SPI_START;
				state_after_d = RECV_2BITS;
			end
			RECV_2BITS: begin
				sample_d[9:8] = spi_miso_byte[1:0];
				state_d = SEND_ZEROS;
			end
			SEND_ZEROS: begin
				spi_mosi_byte_d = 8'h00; // Send zeros so we can read the last 8 bits
				state_d = SPI_START;
				state_after_d = RECV_8BITS;
			end
			RECV_8BITS: begin
				sample_d[7:0] = spi_miso_byte;
				state_d = IDLE;
				sample_done_d = 1'b1;
				spi_cs_d = 1'b1; // chip select high
			end
			
			SPI_START: begin
				spi_start_d = 1'b1;
				state_d = SPI_WAIT;
			end
			SPI_WAIT: begin
				if(spi_done)
					state_d = state_after; // go to state we were waiting to go to
			end
		endcase
	end

endmodule
