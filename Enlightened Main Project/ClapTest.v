`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:23:20 12/08/2016
// Design Name:   Claps
// Module Name:   X:/Desktop/music-fpga-master/music-fpga-master/ClapTest.v
// Project Name:  Enlightened
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Claps
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ClapTest;

	// Inputs
	reg clk_48;
	reg rst;
	reg [9:0] mic_sample;

	// Outputs
	wire home_state;

	// Instantiate the Unit Under Test (UUT)
	Claps uut (
		.clk_48(clk_48), 
		.rst(rst), 
		.mic_sample(mic_sample), 
		.home_state(home_state)
	);
	
	always begin
		#10 clk_48 = ~clk_48;
	end

	initial begin
		// Initialize Inputs
		clk_48 = 0;
		rst = 1;
		mic_sample = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
		mic_sample = 10'h27F;
		
		#100;
		mic_sample = 10'h1FF;
		#40;
		mic_sample = 10'h27F;
	end
      
endmodule

