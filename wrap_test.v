`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:13:04 12/07/2016
// Design Name:   wrap
// Module Name:   X:/My Documents/Anand_Nair_EC551_Lab3/beat1/wrap_test.v
// Project Name:  beat1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: wrap
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module wrap_test;

	// Inputs
	reg clk;
	reg start;
	reg unload;
	reg [15:0] xn_re;
	reg [15:0] xn_im;
	reg fwd_inv;
	reg fwd_inv_we;

	// Outputs
	wire [9:0] xn_index;
	wire [31:0] Magnitude;
	wire [9:0] xk_index;

	always #5 clk =! clk;
	
	// Instantiate the Unit Under Test (UUT)
	wrap uut (
		.clk(clk), 
		.start(start), 
		.unload(unload), 
		.xn_re(xn_re), 
		.xn_im(xn_im), 
		.fwd_inv(fwd_inv), 
		.fwd_inv_we(fwd_inv_we), 
		.xn_index(xn_index), 
		.Magnitude(Magnitude), 
		.xk_index(xk_index)
	);

	initial begin
	
		clk = 0;
		start = 0;
		unload = 0;
		xn_re = 0;
		xn_im = 0;
		fwd_inv = 0;
		fwd_inv_we = 0;
		
		#150;
		
		start = 1;
		unload = 1;
		fwd_inv = 1;
		fwd_inv_we = 1;
		xn_re = 1;
		
      xn_re = 32'h00005678;
      #10;
    
      xn_re = 32'h00001121;
      #10;
      
      xn_re = 32'h00001920;
      #10;
      
      xn_re = 32'h00003245;
      #10;
      
      xn_re = 32'h00001516;
      #10;
      
      xn_re = 32'h00003245;
      #10;
		
      xn_re = 32'h00001920;
      #10;
		
      xn_re = 32'h00005678;
      #10;
		
      xn_re = 32'h00001516;
      #10;
		
      xn_re = 32'h00001920;
      #10;
		
      xn_re = 32'h00005678;
      #10;
		
      xn_re = 32'h00003245;
      #10;
		
      xn_re = 32'h00001183;
      #10;
		
      xn_re = 32'h00002348;
      #10;
		
      xn_re = 32'h00005673;
      #10;
		
      xn_re = 32'h00001234;
      #10;
        
		// Add stimulus here

	end
      
endmodule

