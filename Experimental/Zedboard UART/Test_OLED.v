`timescale 1ns / 1ps

module Test_OLED;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire sclk;
	wire sdin;
	wire dc;
	wire vdd;
	wire vbat;
	wire reset;

	// Instantiate the Unit Under Test (UUT)
	OLED uut (
		.sclk(sclk), 
		.sdin(sdin), 
		.dc(dc), 
		.vdd(vdd), 
		.vbat(vbat),
		.reset(reset), 
		.clk(clk), 
		.rst(rst)
	);
	
	always #5
	clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
	end
      
endmodule

