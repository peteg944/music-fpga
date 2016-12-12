`timescale 1ns / 1ps

module LowPassFilter(clk, new_sample, input_sample, output_sample);

	input clk;
	input new_sample;
	
	reg enable_systolic;
	wire clk_systolic;
	
	input [15:0] input_sample;
	output [15:0] output_sample;
	
	reg [2:0] state;
	localparam IDLE = 3'd0,
					CLK_A = 3'd1,
					CLK_B = 3'd2,
					CLK_C = 3'd3,
					CLK_D = 3'd4;
	
	initial begin
		state <= IDLE;
		enable_systolic <= 1'b0;
	end
	
	always @ (posedge clk) begin
		case(state)
			IDLE: begin
				if(new_sample)
					state <= CLK_A;
				else
					state <= IDLE;
			end
			CLK_A: begin
				enable_systolic <= 1'b1;
				state <= CLK_B;
			end
			CLK_B: begin
				enable_systolic <= 1'b1;
				state <= CLK_C;
			end
			CLK_C: begin
				enable_systolic <= 1'b0;
				state <= IDLE;
			end
		endcase
	end
	
	localparam NUM_COEFFS = 99; // 57
	localparam BITS_COEFF = 8;
	localparam NUM_COEFFS_BITS = NUM_COEFFS * BITS_COEFF;
	
	/*
    // Simulator coefficients
    localparam [NUM_COEFFS_BITS-1:0] COEFFS = {
		8'sd1,
		8'sd1,
		8'sd1,
		-8'sd1
	};
    */
	
	/*
    // Low pass coefficients
	localparam [NUM_COEFFS_BITS-1:0] COEFFS = {
		6'd0,
		6'd0,
		6'd0,
		6'd1,
		6'd1,
		6'd2,
		6'd3,
		6'd5,
		6'd7,
		6'd10,
		6'd12,
		6'd15,
		6'd19,
		6'd22,
		6'd25,
		6'd28,
		6'd31,
		6'd33,
		6'd34,
		6'd34,
		6'd34,
		6'd33,
		6'd31,
		6'd28,
		6'd25,
		6'd22,
		6'd19,
		6'd15,
		6'd12,
		6'd10,
		6'd7,
		6'd5,
		6'd3,
		6'd2,
		6'd1,
		6'd1,
		6'd0,
		6'd0,
		6'd0
	};
	*/
	
	// low pass 99 coeff, 100 Hz stop freq, 60 dB attenuate, 48 khz sampling freq, multiplier: 4926
	localparam [NUM_COEFFS_BITS-1:0] COEFFS = {
		8'sd0,
		8'sd1,
		8'sd1,
		8'sd1,
		8'sd1,
		8'sd1,
		8'sd2,
		8'sd2,
		8'sd2,
		8'sd2,
		8'sd3,
		8'sd3,
		8'sd4,
		8'sd4,
		8'sd4,
		8'sd5,
		8'sd5,
		8'sd6,
		8'sd6,
		8'sd7,
		8'sd8,
		8'sd8,
		8'sd9,
		8'sd9,
		8'sd10,
		8'sd11,
		8'sd11,
		8'sd12,
		8'sd12,
		8'sd13,
		8'sd14,
		8'sd14,
		8'sd15,
		8'sd15,
		8'sd16,
		8'sd16,
		8'sd17,
		8'sd17,
		8'sd18,
		8'sd18,
		8'sd19,
		8'sd19,
		8'sd19,
		8'sd20,
		8'sd20,
		8'sd20,
		8'sd20,
		8'sd20,
		8'sd21,
		8'sd21,
		8'sd21,
		8'sd20,
		8'sd20,
		8'sd20,
		8'sd20,
		8'sd20,
		8'sd19,
		8'sd19,
		8'sd19,
		8'sd18,
		8'sd18,
		8'sd17,
		8'sd17,
		8'sd16,
		8'sd16,
		8'sd15,
		8'sd15,
		8'sd14,
		8'sd14,
		8'sd13,
		8'sd12,
		8'sd12,
		8'sd11,
		8'sd11,
		8'sd10,
		8'sd9,
		8'sd9,
		8'sd8,
		8'sd8,
		8'sd7,
		8'sd6,
		8'sd6,
		8'sd5,
		8'sd5,
		8'sd4,
		8'sd4,
		8'sd4,
		8'sd3,
		8'sd3,
		8'sd2,
		8'sd2,
		8'sd2,
		8'sd2,
		8'sd1,
		8'sd1,
		8'sd1,
		8'sd1,
		8'sd1,
		8'sd0
	};
	
	wire [31:0] a_out [0:NUM_COEFFS];
	wire [31:0] b_out [0:NUM_COEFFS];
	
	genvar j;
	generate
		for(j = 0; j < NUM_COEFFS; j = j+1) begin: GEN
			processingUnit #(COEFFS[NUM_COEFFS_BITS-1-(j*BITS_COEFF):NUM_COEFFS_BITS-(j*BITS_COEFF)-BITS_COEFF]) gen_proc(
				.clk(clk),
				.a_in(a_out[j]),
				.a_out(a_out[j+1]),
				.b_out(b_out[j]),
				.b_in(b_out[j+1]),
				.enable(enable_systolic)
			);
		end
	endgenerate
	
	assign a_out[0] = {{16{input_sample[15]}}, input_sample}; // sign extend to 32 bits
	assign b_out[NUM_COEFFS] = 32'h0;
	assign output_sample = b_out[0][26:10]; // divide by 1024
	
endmodule

/*
	processingUnit #(1) p00 (clk, systolic_input, a_out[0], systolic_output, b_out[17], enable_systolic);
	processingUnit #(3) p01 (clk, a_out[0], 		a_out[1],  b_out[17],	 	b_out[16], enable_systolic);
	processingUnit #(5) p02 (clk, a_out[1], 		a_out[2],  b_out[16],	 	b_out[15], enable_systolic);
	processingUnit #(7) p03 (clk, a_out[2], 		a_out[3],  b_out[15],		b_out[14], enable_systolic);
	processingUnit #(11)p04 (clk, a_out[3],		a_out[4],  b_out[14],		b_out[13], enable_systolic);
	processingUnit #(13)p05 (clk, a_out[4], 		a_out[5],  b_out[13],	 	b_out[12], enable_systolic);
	processingUnit #(16)p06 (clk, a_out[5], 		a_out[6],  b_out[12],		b_out[11], enable_systolic);
	processingUnit #(19)p07 (clk, a_out[6], 		a_out[7],  b_out[11],		b_out[10], enable_systolic);
	processingUnit #(20)p08 (clk, a_out[7], 		a_out[8],  b_out[10],		b_out[9], enable_systolic);
	processingUnit #(21)p09 (clk, a_out[8], 		a_out[9],  b_out[9], 	 	b_out[8], enable_systolic);
	processingUnit #(20)p10 (clk, a_out[9], 		a_out[10], b_out[8], 	 	b_out[7], enable_systolic);
	processingUnit #(19)p11 (clk, a_out[10], 		a_out[11], b_out[7],			b_out[6], enable_systolic);
	processingUnit #(16)p12 (clk, a_out[11],		a_out[12], b_out[6],			b_out[5], enable_systolic);
	processingUnit #(13)p13 (clk, a_out[12], 		a_out[13], b_out[5],		 	b_out[4], enable_systolic);
	processingUnit #(11)p14 (clk, a_out[13], 		a_out[14], b_out[4],			b_out[3], enable_systolic);
	processingUnit #(7) p15 (clk, a_out[14], 		a_out[15], b_out[3],			b_out[2], enable_systolic);
	processingUnit #(5) p16 (clk, a_out[15], 		a_out[16], b_out[2],			b_out[1], enable_systolic);
	processingUnit #(3) p17 (clk, a_out[16], 		a_out[17], b_out[1],			b_out[0], enable_systolic);
	processingUnit #(1) p18 (clk, a_out[17], 					, b_out[0],			32'h0,	 enable_systolic);*/
