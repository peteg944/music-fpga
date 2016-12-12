`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:19:34 12/08/2016
// Design Name:   wrap_FFT
// Module Name:   X:/Desktop/Project_stuff/music-fpga-master/FFT_TEST.v
// Project Name:  Enlightened
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: wrap_FFT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FFT_TEST;

	// Inputs
	reg clk;
	reg [15:0] data_in;
	reg data_in_valid;
	reg slave_ready;

	// Outputs
	wire [15:0] data_out;
	wire data_in_ready;
	wire data_out_valid;
	wire [7:0] output_index;

	// Instantiate the Unit Under Test (UUT)
	wrap_FFT uut (
		.clk(clk), 
		//.input_index(input_index),
		.data_in(data_in), 
		.data_out(data_out), 
		.data_in_ready(data_in_ready), 
		.data_in_valid(data_in_valid), 
		.data_out_valid(data_out_valid), 
		.slave_ready(slave_ready), 
		.output_index(output_index)
	);

always begin
	#5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		data_in = 0;
		data_in_valid = 0;
		slave_ready = 0;
		//input_index = 0;

		// Wait 100 ns for global reset to finish
		#10 data_in_valid = 1;slave_ready = 1;
		#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
		#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
				#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
				#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
				#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
				#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
				#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;
				#10 data_in = 10'b1010110011;//input_index = 8'd0;
		#10 data_in = 10'b1010111111;//input_index = 8'd1;
		#10 data_in = 10'b1010110111;//input_index = 8'd2;
		#10 data_in = 10'b1011110011;//input_index = 8'd3;
		#10 data_in = 10'b1010110011;//input_index = 8'd4;
		#10 data_in = 10'b1010111111;//input_index = 8'd5;
		#10 data_in = 10'b1010101111;//input_index = 8'd6;
		#10 data_in = 10'b1010110011;//input_index = 8'd7;
		#10 data_in = 10'b1010010111;//input_index = 8'd8;
		#10 data_in = 10'b1010110011;//input_index = 8'd9;
		#10 data_in = 10'b1010110011;//input_index = 8'd10;
		#10 data_in = 10'b1010111011;//input_index = 8'd11;
		#10 data_in = 10'b1010110011;//input_index = 8'd12;
		#10 data_in = 10'b1010110011;//input_index = 8'd13;
		#10 data_in = 10'b1010001011;//input_index = 8'd14;
		#10 data_in = 10'b1010110011;//input_index = 8'd15;

		// Add stimulus here

	end
	endmodule

