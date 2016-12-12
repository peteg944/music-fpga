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
module animationV(clk, rst, height, ram_address, ram_data, mode, on_off, xn_index);
input clk, rst, mode, on_off; //0 is home mode; 1 is party mode 
input [8:0] ram_address;
input [7:0] xn_index;
output reg [47:0] ram_data;
reg [23:0] top, bottom;

input[3:0] height;
//wire [4:0] temp_height;
//reg [5:0] inner_height;
//reg [23:0] color;
integer i = 0;
reg [3:0] temp_height;
reg [4:0] mem [0:15] ;
//reg [5:0] mem_1 [0:15] ;
reg [7:0] temp_index;
//reg [4:0] height_temp;
//reg [3:0] height_top;
//reg [3:0] height_bottom;

parameter Red 			= {8'd0  , 8'd0,   8'd255};
parameter Tuna 		= {8'd153, 8'd153, 8'd255};
parameter Brwn 		= {8'd0  , 8'd104, 8'd204};
parameter Orange 		= {8'd0  , 8'd128, 8'd255};
parameter Yellow 		= {8'd0  , 8'd255, 8'd255};
parameter Yellow2 	= {8'd102, 8'd204, 8'd0  };
parameter Green 		= {8'd0  , 8'd255, 8'd128};
parameter DrkGreen 	= {8'd0  , 8'd255, 8'd0  };
parameter LgtGreen 	= {8'd153, 8'd255, 8'd153};
parameter LgtGreen2	= {8'd128, 8'd255, 8'd0  };
parameter Cyan 		= {8'd255, 8'd255, 8'd0  };
parameter Sky 			= {8'd255, 8'd255, 8'd153};
parameter DrkBlue 	= {8'd204, 8'd102, 8'd0  };
parameter Blue 		= {8'd255, 8'd0,   8'd0  };
parameter Purple 		= {8'd255, 8'd0,   8'd127};
parameter Pink 		= {8'd255, 8'd0,   8'd255};
parameter Pink2 		= {8'd127, 8'd0,   8'd255};

//assign temp_height = (((height >>> 15) ^ height) - (height >>> 15))  >> 4;
initial begin
top<=0;
bottom<=0;
ram_data <=0;
//inner_height<=0;
//color<=0;
//addsub<=0;
//temp_index <= 0;
for (i = 0;i<16; i = i+1) begin
	mem[i] <= 4'b0;
end
end

//Top half of panel is controlled by last 24 bits of ram_data
always @(posedge clk) begin
	///temp_height <= height;
	//if (temp_height != height) begin // new data coming in
		mem[xn_index] <= {1'b0, height};
	//end
end


always @ (posedge clk) begin

	
if ( mode == 1'b1) begin
	//if (ram_address == 0) begin
	//	color<= color+1'b1;
	//	inner_height<={0,height};
	//end
	bottom <= {24{1'b0}};
	top <= {24{1'b0}};
		if (ram_address % 32 >= 0 && ram_address % 32 < 2) begin
			if (ram_address > 512 - 1 - $unsigned(mem[0]) * 32) begin
				top <= Red;
			end
			if (ram_address < $unsigned(mem[0]) * 32) begin
				bottom <= Red;
			end
		end


		if (ram_address % 32 >= 2 && ram_address % 32 < 4) begin
			if (ram_address > 512 - 1 - $unsigned(mem[1]) * 32) begin
				top <= Tuna;
			end
			if (ram_address < $unsigned(mem[1]) * 32) begin
				bottom <= Tuna;
			end
		end

		if (ram_address % 32 >= 4 && ram_address % 32 < 6) begin
			if (ram_address > 512 - 1 - $unsigned(mem[2]) * 32) begin
				top <= Brwn;
			end
			if (ram_address < $unsigned(mem[2]) * 32) begin
				bottom <= Brwn;
			end
		end

		if (ram_address % 32 >= 6 && ram_address % 32 < 8) begin
			if (ram_address > 512 - 1 - $unsigned(mem[3]) * 32) begin
				top <= Orange;
			end
			if (ram_address < $unsigned(mem[3]) * 32) begin
				bottom <= Orange;
			end
		end

		if (ram_address % 32 >= 8 && ram_address % 32 < 10) begin
			if (ram_address > 512 - 1 - $unsigned(mem[4]) * 32) begin
				top <= Yellow;
			end
			if (ram_address < $unsigned(mem[4]) * 32) begin
				bottom <= Yellow;
			end
		end

		if (ram_address % 32 >= 10 && ram_address % 32 < 12) begin
			if (ram_address > 512 - 1 - $unsigned(mem[5]) * 32) begin
				top <= Yellow2;
			end
			if (ram_address < $unsigned(mem[5]) * 32) begin
				bottom <= Yellow2;
			end
		end

		if (ram_address % 32 >= 12 && ram_address % 32 < 14) begin
			if (ram_address > 512 - 1 - $unsigned(mem[6]) * 32) begin
				top <= Green;
			end
			if (ram_address < $unsigned(mem[6]) * 32) begin
				bottom <= Green;
			end
		end

		if (ram_address % 32 >= 14 && ram_address % 32 < 16) begin
			if (ram_address > 512 - 1 - $unsigned(mem[7]) * 32) begin
				top <= DrkGreen;
			end
			if (ram_address < $unsigned(mem[7]) * 32) begin
				bottom <= DrkGreen;
			end
		end

		if (ram_address % 32 >= 16 && ram_address % 32 < 18) begin
			if (ram_address > 512 - 1 - $unsigned(mem[8]) * 32) begin
				top <= LgtGreen;
			end
			if (ram_address < $unsigned(mem[8]) * 32) begin
				bottom <= LgtGreen;
			end
		end

		if (ram_address % 32 >= 18 && ram_address % 32 < 20) begin
			if (ram_address > 512 - 1 - $unsigned(mem[9]) * 32) begin
				top <= LgtGreen2;
			end
			if (ram_address < $unsigned(mem[9]) * 32) begin
				bottom <= LgtGreen2;
			end
		end

		if (ram_address % 32 >= 20 && ram_address % 32 < 22) begin
			if (ram_address > 512 - 1 - $unsigned(mem[10]) * 32) begin
				top <= Cyan;
			end
			if (ram_address < $unsigned(mem[10]) * 32) begin
				bottom <= Cyan;
			end
		end

		if (ram_address % 32 >= 22 && ram_address % 32 < 24) begin
			if (ram_address > 512 - 1 - $unsigned(mem[11]) * 32) begin
				top <= Sky;
			end
			if (ram_address < $unsigned(mem[11]) * 32) begin
				bottom <= Sky;
			end
		end

		if (ram_address % 32 >= 24 && ram_address % 32 < 26) begin
			if (ram_address > 512 - 1 - $unsigned(mem[12]) * 32) begin
				top <= DrkBlue;
			end
			if (ram_address < $unsigned(mem[12]) * 32) begin
				bottom <= DrkBlue;
			end
		end

		if (ram_address % 32 >= 26 && ram_address % 32 < 28) begin
			if (ram_address > 512 - 1 - $unsigned(mem[13]) * 32) begin
				top <= Blue;
			end
			if (ram_address < $unsigned(mem[13]) * 32) begin
				bottom <= Blue;
			end
		end

		if (ram_address % 32 >= 28 && ram_address % 32 < 30) begin
			if (ram_address > 512 - 1 - $unsigned(mem[14]) * 32) begin
				top <= Purple;
			end
			if (ram_address < $unsigned(mem[14]) * 32) begin
				bottom <= Purple;
			end
		end

		if (ram_address % 32 >= 30 && ram_address % 32 < 32) begin
			if (ram_address > 512 - 1 - $unsigned(mem[15]) * 32) begin
				top <= Pink;
			end
			if (ram_address < $unsigned(mem[15]) * 32) begin
				bottom <= Pink;
			end
		end


	
	/*
		if (ram_address % 32 >= 0 && ram_address % 32 < 2) begin
			if (ram_address > 512 - 1 - $unsigned(mem[0]) * 32) begin
				top <= Red;
			end
			//if (ram_address < $unsigned(mem_1[0]) * 32) begin
			else if (ram_address > 512 - 1 - $unsigned(mem_1[0]) * 32) begin
				bottom <= Red;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
		else if (ram_address % 32 >= 2 && ram_address % 32 < 4) begin
			if (ram_address > 512 - 1 - $unsigned(mem[1]) * 32) begin
				top <= Tuna;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[1]) * 32) begin
				bottom <= Tuna;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
		
		else if (ram_address % 32 >= 4 && ram_address % 32 < 6) begin
			if (ram_address > 512 - 1 - $unsigned(mem[2]) * 32) begin
				top <= Brwn;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[2]) * 32) begin
				bottom <= Brwn;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	
		else if (ram_address % 32 >= 6 && ram_address % 32 < 8) begin
			if (ram_address > 512 - 1 - $unsigned(mem[3]) * 32) begin
				top <= Orange;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[3]) * 32) begin
				bottom <= Orange;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end

		else if (ram_address % 32 >= 8 && ram_address % 32 < 10) begin
			if (ram_address > 512 - 1 - $unsigned(mem[4]) * 32) begin
				top <= Yellow;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[4]) * 32) begin
				bottom <= Yellow;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	
		else if (ram_address % 32 >= 10 && ram_address % 32 < 12) begin
			if (ram_address > 512 - 1 - $unsigned(mem[5]) * 32) begin
				top <= Yellow2;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[5]) * 32) begin
				bottom <= Yellow2;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end

		else if (ram_address % 32 >= 12 && ram_address % 32 < 14) begin
			if (ram_address > 512 - 1 - $unsigned(mem[6]) * 32) begin
				top <= Green;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[6]) * 32) begin
				bottom <= Green;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	

		else if (ram_address % 32 >= 14 && ram_address % 32 < 16) begin
			if (ram_address > 512 - 1 - $unsigned(mem[7]) * 32) begin
				top <= DrkGreen;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[7]) * 32) begin
				bottom <= DrkGreen;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
		else if (ram_address % 32 >= 16 && ram_address % 32 < 18) begin //only this two column works? yes?
			if (ram_address > 512 - 1 - $unsigned(mem[8]) * 32) begin
				top <= LgtGreen;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[8]) * 32) begin
				bottom <= LgtGreen;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
		else if (ram_address % 32 >= 18 && ram_address % 32 < 20) begin
			if (ram_address > 512 - 1 - $unsigned(mem[9]) * 32) begin
				top <= LgtGreen2;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[9]) * 32) begin
				bottom <= LgtGreen2;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
		else if (ram_address % 32 >= 20 && ram_address % 32 < 22) begin
			if (ram_address > 512 - 1 - $unsigned(mem[10]) * 32) begin
				top <= Cyan;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[10]) * 32) begin
				bottom <= Cyan;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	
		else if (ram_address % 32 >= 22 && ram_address % 32 < 24) begin
			if (ram_address > 512 - 1 - $unsigned(mem[11]) * 32) begin
				top <= Sky;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[11]) * 32) begin
				bottom <= Sky;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end

		else if (ram_address % 32 >= 24 && ram_address % 32 < 26) begin
			if (ram_address > 512 - 1 - $unsigned(mem[12]) * 32) begin
				top <= DrkBlue;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[12]) * 32) begin
				bottom <= DrkBlue;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	
		else if (ram_address % 32 >= 26 && ram_address % 32 < 28) begin
			if (ram_address > 512 - 1 - $unsigned(mem[13]) * 32) begin
				top <= Blue;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[13]) * 32) begin
				bottom <= Blue;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end

		else if (ram_address % 32 >= 28 && ram_address % 32 < 30) begin
			if (ram_address > 512 - 1 - $unsigned(mem[14]) * 32) begin
				top <= Purple;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[14]) * 32) begin
				bottom <= Purple;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	

		else if (ram_address % 32 >= 30 && ram_address % 32 < 32) begin
			if (ram_address > 512 - 1 - $unsigned(mem[15]) * 32) begin
				top <= Pink;
			end
			else if (ram_address > 512 - 1 - $unsigned(mem_1[15]) * 32) begin
				bottom <= Pink;
			end
			else begin
				bottom <= {24{1'b0}};
				top <= {24{1'b0}};
			end
		end
	*/
		
	/*
	if (ram_address > 512 - 1 - $unsigned(inner_height)* 32 ) begin
		top <= color;
		//bottom <= {24{1'b0}};
	end
	if (ram_address < $unsigned(inner_height) * 32) begin
		//top <= {24{1'b0}};
		bottom <= color;
	end
	*/
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
