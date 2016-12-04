`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:05 12/03/2016 
// Design Name: 
// Module Name:    MULT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MULT(
	input [a_width-1 : 0] a,
	input [b_width-1 : 0] b,
	output [a_width+b_width-1 : 0] result
    );

	wire sign;
	wire [a_width-1 : 0] temp_a;
	wire [b_width-1 : 0] temp_b;
	wire [a_width+b_width-1 : 0] temp_long;
	
	assign sign = a[a_width-1] ^ b[b_width-1];
	assign temp_a = (a[a_width-1] == 1'b1)? ~(a - 1'b1) : a;   
	assign temp_b = (b[b_width-1] == 1'b1)? ~(b - 1'b1) : b;   
	assign temp_long = temp_a * temp_b; 
	assign product = (sign == 1'b1) ? ~(temp_long - 1'b1) : temp_long;   

endmodule
