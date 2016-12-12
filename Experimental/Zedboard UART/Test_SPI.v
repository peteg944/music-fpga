`timescale 1ns / 1ps

module Test_SPI;

	// Inputs
	reg clk;
	reg rst;
	reg miso;
	reg start;
	reg [7:0] data_in;

	// Outputs
	wire mosi;
	wire sck;
	wire [7:0] data_out;
	wire busy;
	wire new_data;

	// Instantiate the Unit Under Test (UUT)
	SPI uut (
		.clk(clk), 
		.rst(rst), 
		.miso(miso), 
		.mosi(mosi), 
		.sck(sck), 
		.start(start), 
		.data_in(data_in), 
		.data_out(data_out), 
		.busy(busy), 
		.new_data(new_data)
	);
	
	always begin
		#10 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		miso = 0;
		start = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
		#10;
		
		data_in = 8'b10111001;
		start = 1;
		
		#10;
		start = 0;
	end
      
endmodule

