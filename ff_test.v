`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:11:49 12/07/2016
// Design Name:   fft_core
// Module Name:   X:/My Documents/Anand_Nair_EC551_Lab3/beat1/ff_test.v
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

module ff_test;

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

	always #5 clk =! clk;
	
	// Instantiate the Unit Under Test (UUT)
	fft_core uut (
		.clk(clk), 
		.start(start), 
		.fwd_inv(fwd_inv), 
		.fwd_inv_we(fwd_inv_we), 
		.scale_sch_we(scale_sch_we), 
		.rfd(rfd), 
		.busy(busy), 
		.edone(edone), 
		.done(done), 
		.dv(dv), 
		.xn_re(xn_re), 
		.xn_im(xn_im), 
		.scale_sch(scale_sch), 
		.xn_index(xn_index), 
		.xk_index(xk_index), 
		.xk_re(xk_re), 
		.xk_im(xk_im)
	);

	initial begin

		clk = 0;
		start = 0;
		fwd_inv = 0;
		fwd_inv_we = 0;
		scale_sch_we = 0;
		xn_re = 0;
		xn_im = 0;
		scale_sch = 0;

		#150;
		
		start = 1;
		fwd_inv = 1;
		fwd_inv_we = 1;
		scale_sch_we = 1;
		xn_re = 1;
		scale_sch = 1;
		
		
        
		// Add stimulus here
            
      scale_sch = 10'b1010101011;
      xn_re = 32'h00005678;
      #10;
      scale_sch = 10'b1010101011;
      xn_re = 32'h00001121;
      #10;
      scale_sch = 10'b1010101011;
      xn_re = 32'h00001920;
      #10;
      scale_sch = 10'b1010101011;
      xn_re = 32'h00003245;
      #10;
      scale_sch = 10'b1010101011;
      xn_re = 32'h00001516;
      #10;
      scale_sch = 10'b1010101011;
      xn_re = 32'h00003245;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00001920;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00005678;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00001516;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00001920;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00005678;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00003245;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00001183;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00002348;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00005673;
      #10;
		scale_sch = 10'b1010101011;
      xn_re = 32'h00001234;
      #10;

      
	end
      
endmodule

