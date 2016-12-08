`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:52:16 12/07/2016
// Design Name:   fft_core
// Module Name:   X:/My Documents/Anand_Nair_EC551_Lab3/beat1/fft_test.v
// Project Name:  beat1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fft_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fft_test;

	// Inputs
	reg clk;
	reg start;
	reg fwd_inv;
	reg fwd_inv_we;
	reg scale_sch_we;
	reg [15:0] xn_re;
	reg [15:0] xn_im;
	reg [9:0] scale_sch;

	// Outputs
	wire rfd;
	wire busy;
	wire edone;
	wire done;
	wire dv;
	wire [9:0] xn_index;
	wire [9:0] xk_index;
	wire [15:0] xk_re;
	wire [15:0] xk_im;

	// Instantiate the Unit Under Test (UUT)
   fft_core f1 (
  .clk(clk), // input clk
  .start(start), // input start
  .xn_re(xn_re), // input [15 : 0] xn_re
  .xn_im(xn_im), // input [15 : 0] xn_im
  .fwd_inv(fwd_inv), // input fwd_inv
  .fwd_inv_we(fwd_inv_we), // input fwd_inv_we
  .scale_sch(scale_sch), // input [9 : 0] scale_sch
  .scale_sch_we(scale_sch_we), // input scale_sch_we
  .rfd(rfd), // output rfd
  .xn_index(xn_index), // output [9 : 0] xn_index
  .busy(busy), // output busy
  .edone(edone), // output edone
  .done(done), // output done
  .dv(dv), // output dv
  .xk_index(xk_index), // output [9 : 0] xk_index
  .xk_re(xk_re), // output [15 : 0] xk_re
  .xk_im(xk_im) // output [15 : 0] xk_im
);


	initial begin
		// Initialize Inputs
		clk = 0;
		start = 0;
		fwd_inv = 0;
		fwd_inv_we = 0;
		scale_sch_we = 0;
		xn_re = 0;
		xn_im = 0;
		scale_sch = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

