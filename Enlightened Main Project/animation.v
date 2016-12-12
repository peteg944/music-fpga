`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:05 12/03/2016 
// Design Name: 
// Module Name:    animation 
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
module animationV(clk, rst, height, ram_address, ram_data, mode, on_off);
input clk, rst, mode, on_off; //0 is home mode; 1 is party mode 
input [8:0] ram_address;
output reg [47:0] ram_data;
reg [23:0] top, bottom;

input[3:0] height;
reg [4:0] inner_height;
reg [23:0] color;

//parameter height = 9;
initial begin
top<=0;
bottom<=0;
ram_data <=0;
inner_height<=0;
color<=0;

end

//Top half of panel is controlled by last 24 bits of ram_data

always @ (posedge clk) begin

if ( mode == 1'b1) begin
	if (ram_address == 0) begin
		color<= color+1'b1;
		inner_height<={0,height};
	end
	bottom <= {24{1'b0}};
	top <= {24{1'b0}};

	if (ram_address > 512 - 1 - $unsigned(inner_height)* 32 ) begin
		top <= color;
		//bottom <= {24{1'b0}};
	end
	if (ram_address < $unsigned(inner_height) * 32) begin
		//top <= {24{1'b0}};
		bottom <= color;
	end
	
	ram_data <= {bottom, top};
end 
	
else begin
	if (on_off == 1'b1) begin
		ram_data <= {8'd179, 8'd255, 8'd255, 8'd179, 8'd255, 8'd255};
	end
	else begin
		ram_data <= 48'b0;
	end
end
	
end

endmodule
