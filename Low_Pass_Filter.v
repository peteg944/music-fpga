`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:30 12/03/2016 
// Design Name: 
// Module Name:    Low_Pass_Filter 
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


module Low_Pass_Filter(
	input clk,
	input enable,
	input reg [data_width-1 : 0] sample_in,
	output reg [data_width-1 : 0] sample_out
    );
	 
	 parameter data_width = 16;
	 parameter window_width = 5;
	 
	 reg unsigned[data_width-1 : 0] total = 0;
	 reg [data_width-1 : 0] end_sample;
	 reg delay_line [window_width * data_width-1 : 0] = 0;
	 
	 initial begin
	 end
	 


endmodule
