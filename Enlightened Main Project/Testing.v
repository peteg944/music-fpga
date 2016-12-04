`timescale 1ns / 1ps

module Testing(leds, clk, button);

	input clk, button;
	output reg [3:0] leds;
	
	reg [21:0] bounce_counter;
	
	always @ (posedge clk) begin
		if(button) begin
			if(bounce_counter == 22'b0) begin
				leds = leds + 1;
			end
			
			bounce_counter = bounce_counter - 1;
		end
	end

endmodule
