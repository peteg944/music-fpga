`timescale 1ns / 1ps

module Claps(
	input clk_48,
	input rst,
	input [9:0] mic_sample,
	output reg home_state,			// 1 if light should be on, 0 if not on
	output [3:0] debug
);
	
	// State variables
	reg [2:0] state, state_d;
	reg [2:0] state_after, state_after_d;
	reg [31:0] delay, delay_d;
	reg home_state_d;
	
//	initial begin
//	home_state <= 0;
//	end
	
	localparam THRESHOLD = 10'd770; // (770/1023)
	localparam DELAY_SIM = 32'h4;
	localparam DELAY_QUARTERSEC = 32'hB71B00; // 12 million (48 mhz / 4 = 12 mill)
	localparam DELAY_2SEC = 32'h5B8D800; // 96 million (double 48 Mhz, so 2 seconds)
	
	localparam WAIT_CLAP1 = 3'd0,
					DELAY_CLAP2 = 3'd1,
					WAIT_CLAP2 = 3'd2,
					TOGGLE_STATE = 3'd3,
					DELAY_RESET = 3'd4;
					
	assign debug = state;
	
	// sequential logic
	always @ (posedge clk_48 or posedge rst) begin
		if(rst) begin
			state <= WAIT_CLAP1;
			state_after <= WAIT_CLAP1;
			delay <= 32'h0;
			home_state <= 1'b0;
		end else begin
			state <= state_d;
			state_after <= state_after_d;
			delay <= delay_d;
			home_state <= home_state_d;
		end
	end
	
	// combinational logic
	always @ (*) begin
		// set previous values
		state_d = state;
		state_after_d = state_after;
		delay_d = delay;
		home_state_d = home_state;
		
		case(state)
			WAIT_CLAP1: begin
				if(mic_sample > THRESHOLD) begin
					state_d = DELAY_CLAP2;
					delay_d = DELAY_QUARTERSEC; // set up for delay
				end else
					state_d = WAIT_CLAP1;
			end
			DELAY_CLAP2: begin
				if(delay == 32'b0) begin
					state_d = WAIT_CLAP2;
					delay_d = DELAY_2SEC; // set up for delay
				end else
					delay_d = delay - 1'b1;
			end
			WAIT_CLAP2: begin
				if(delay == 32'b0) begin
					state_d = WAIT_CLAP1; // took too long for second clap
				end else begin
					delay_d = delay - 1'b1;
					if(mic_sample > THRESHOLD)
						state_d = TOGGLE_STATE;
					else
						state_d = WAIT_CLAP2;
				end
			end
			TOGGLE_STATE: begin
				state_d = DELAY_RESET;
				delay_d = DELAY_2SEC;
				
				if(home_state == 1'b1)
					home_state_d = 1'b0;
				else
					home_state_d = 1'b1;
			end
			DELAY_RESET: begin
				if(delay == 32'b0)
					state_d = WAIT_CLAP1;
				else
					delay_d = delay - 1'b1;
			end
		endcase
	end

endmodule
