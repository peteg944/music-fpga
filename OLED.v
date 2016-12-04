`timescale 1ns / 1ps

// SCLK -- SPI clock
// SDIN -- SPI data
// DC   -- Data vs. Command select
// Vdd  -- Power for OLED logic
// Reset-- Reset OLED
module OLED(output sclk,
				output sdin,
				output dc,
				output vdd,
				output vbat,
				output reset,
				output debug1,
				input clk,
				input rst,
				input [6:0] mode);
	
	localparam delay_bits = 24;
	localparam delay_time = 24'd350;
	localparam delay_time_long = 24'h00FFFFFF;
	
	reg dc_d, dc_q;
	reg vdd_d, vdd_q;
	reg vbat_d, vbat_q;
	reg reset_d, reset_q;
	reg [5:0] state_d, state_q; // State of the OLED setup, etc.
	reg [5:0] state_after_d, state_after_q; // State to go to after a wait or a delay
	reg [delay_bits-1:0]	delay_d, delay_q; // 24 bits (16777216)
	// 300 cycles -> 3 microseconds (at 100 MHz)
	// 16777216 cycles -> 167 ms at 100 MHz
	
	// SPI module
	reg start_d, start_q;
	reg [7:0] spi_mosi_byte_d, spi_mosi_byte_q;
	wire spi_done;
	SPI spi(clk, rst, , sdin, sclk, start_q, spi_mosi_byte_q, , , spi_done);
	
	// Output assignments
	assign dc = dc_q;
	assign vdd = vdd_q;
	assign vbat = vbat_q;
	assign reset = reset_q;
	// -- sclk and sdin are taken care of by the SPI module
	
	// Debugs
	assign debug1 = spi_done;
	
	// Text
	reg [7:0] home [0:63]; // 64 eight-bit regs
	reg [7:0] party [0:63]; // 64 eight-bit regs		
	reg [7:0] stuff [0:63];
	reg [2:0] repeat_count_d, repeat_count_q; // 8 times
	reg [6:0] text_count_d, text_count_q; // 64 blocks (16 x 4) but need 7bit # for counting purposes
	
	// State parameters
	localparam SPI_START =			6'd0;
	localparam SPI_WAIT =			6'd1;
	localparam DELAY_START =		6'd2;
	localparam DELAY_WAIT =			6'd3;
	localparam IDLE =					6'd4;
	localparam VDD_ON =				6'd5;
	localparam DISP_OFF =			6'd7;
	localparam RESET_ON =			6'd8;
	localparam RESET_OFF =			6'd10;
	localparam CHR_PUMP_1 =			6'd11;
	localparam CHR_PUMP_2 =			6'd12;
	localparam PRE_CHR_1 =			6'd13;
	localparam PRE_CHR_2 =			6'd14;
	localparam VBAT_ON =				6'd15;
	localparam CONTRAST_1 =			6'd17;
	localparam CONTRAST_2 =			6'd18;
	localparam INVERT_1 =			6'd19;
	localparam INVERT_2 =			6'd20;
	localparam COM_CONFIG_1 =		6'd21;
	localparam COM_CONFIG_2 =		6'd22;
	localparam DISP_ON =				6'd23;
	localparam FULL_DISP =			6'd24;
	localparam ADDRESS_MODE_1 =	6'd25;
	localparam ADDRESS_MODE_2 =	6'd26;
	localparam UPDATE_TXT =			6'd27;
	localparam PAGE_ADDR_1 =		6'd28;
	localparam PAGE_ADDR_2 =		6'd29;
	localparam PAGE_ADDR_3 =		6'd30;
	localparam COL_ADDR_1 =			6'd31;
	localparam COL_ADDR_2 =			6'd32;
	localparam COL_ADDR_3 =			6'd33;
	
	initial begin
		$readmemh("default_text.hex", stuff);
		$readmemh("home_text.hex", home);
		$readmemh("party_text.hex", party);
	end
	
	// Sequential for changing states and incrementing the delay counter if necessary
	always @ (posedge clk) begin
		if(rst) begin
			dc_q <= 1'b0;
			vdd_q <= 1'b1;
			vbat_q <= 1'b1;
			reset_q <= 1'b1;
			delay_q <= delay_time;
			state_q <= VDD_ON;
			state_after_q <= IDLE;
			start_q <= 1'b0;
			spi_mosi_byte_q <= 8'b0;
			repeat_count_q <= 3'd7;
			text_count_q <= 7'd0;
		end else begin
			dc_q <= dc_d;
			vdd_q <= vdd_d;
			vbat_q <= vbat_d;
			reset_q <= reset_d;
			delay_q <= delay_d;
			state_q <= state_d;
			state_after_q <= state_after_d;
			start_q <= start_d;
			spi_mosi_byte_q <= spi_mosi_byte_d;
			repeat_count_q <= repeat_count_d;
			text_count_q <= text_count_d;
		end
	end
	
	// Combinational logic based on current state
	always @ (*) begin
		// Assign everything to its previous value
		dc_d = dc_q;
		vdd_d = vdd_q;
		vbat_d = vbat_q;
		reset_d = reset_q;
		delay_d = delay_q;
		state_d = state_q;
		state_after_d = state_after_q;
		start_d = start_q;
		spi_mosi_byte_d = spi_mosi_byte_q;
		repeat_count_d = repeat_count_q;
		text_count_d = text_count_q;
		
		case(state_q) // Assign state_d (next state) based on current state (state_q)
			VDD_ON: begin
				vdd_d = 1'b0;
				state_d = DELAY_START;
				state_after_d = DISP_OFF;
			end
			DISP_OFF: begin
				spi_mosi_byte_d = 8'hAE;
				state_d = SPI_START;
				state_after_d = RESET_ON;
			end
			RESET_ON: begin
				reset_d = 1'b0;
				state_d = DELAY_START;
				state_after_d = RESET_OFF;
			end
			RESET_OFF: begin
				reset_d = 1'b1;
				state_d = DELAY_START;
				state_after_d = CHR_PUMP_1;
			end
			CHR_PUMP_1: begin
				spi_mosi_byte_d = 8'h8D;
				state_d = SPI_START;
				state_after_d = CHR_PUMP_2;
			end
			CHR_PUMP_2: begin
				spi_mosi_byte_d = 8'h14;
				state_d = SPI_START;
				state_after_d = PRE_CHR_1;
			end
			PRE_CHR_1: begin
				spi_mosi_byte_d = 8'hD9;
				state_d = SPI_START;
				state_after_d = PRE_CHR_2;
			end
			PRE_CHR_2: begin
				spi_mosi_byte_d = 8'hF1;
				state_d = SPI_START;
				state_after_d = VBAT_ON;
			end
			VBAT_ON: begin
				vbat_d = 1'b0;
				state_d = DELAY_START;
				state_after_d = CONTRAST_1;
			end
			CONTRAST_1: begin
				spi_mosi_byte_d = 8'h81;
				state_d = SPI_START;
				state_after_d = CONTRAST_2;
			end
			CONTRAST_2: begin
				spi_mosi_byte_d = 8'hF1;
				state_d = SPI_START;
				state_after_d = INVERT_1;
			end
			INVERT_1: begin
				spi_mosi_byte_d = 8'hA0;
				state_d = SPI_START;
				state_after_d = INVERT_2;
			end
			INVERT_2: begin
				spi_mosi_byte_d = 8'hC0;
				state_d = SPI_START;
				state_after_d = COM_CONFIG_1;
			end
			COM_CONFIG_1: begin
				spi_mosi_byte_d = 8'hDA;
				state_d = SPI_START;
				state_after_d = COM_CONFIG_2;
			end
			COM_CONFIG_2: begin
				spi_mosi_byte_d = 8'h00;
				state_d = SPI_START;
				state_after_d = DISP_ON;
			end
			DISP_ON: begin
				spi_mosi_byte_d = 8'hAF;
				state_d = SPI_START;
				state_after_d = ADDRESS_MODE_1;
			end
			ADDRESS_MODE_1: begin
				spi_mosi_byte_d = 8'h20; // Addressing mode
				state_d = SPI_START;
				state_after_d = ADDRESS_MODE_2;
			end
			ADDRESS_MODE_2: begin
				spi_mosi_byte_d = 8'h00; // Horizontal addressing mode
				state_d = SPI_START;
				state_after_d = UPDATE_TXT;
			end
			
			
			FULL_DISP: begin
				spi_mosi_byte_d = 8'hA5;
				state_d = SPI_START;
				state_after_d = IDLE;
			end
			
			
			// SPI transitions
			SPI_START: begin
				start_d = 1'b1; // start the transmission
				state_d = SPI_WAIT; // wait until it finishes transmitting
			end
			SPI_WAIT: begin
				start_d = 1'b0;
				if(spi_done)
					state_d = state_after_q; // Go to the state we were waiting to go to
			end
			
			// Delay transitions
			DELAY_START: begin
				delay_d = delay_time_long;
				state_d = DELAY_WAIT;
			end
			DELAY_WAIT: begin
				if(delay_d == {delay_bits{1'b0}}) // counted down to zero
					state_d = state_after_q; // Go to the state we were waiting to go to
				else
					delay_d = delay_q - 1'b1; // Not done yet, decrement counter
			end
			
			// Writing text
			UPDATE_TXT: begin
				dc_d = 1'b1; // data mode
				state_d = SPI_START;
				
				// Send out the correct byte
				if(mode == 8'b00000001)
					spi_mosi_byte_d = party[text_count_q];
				else if(mode == 8'b0)
					spi_mosi_byte_d = home[text_count_q];
				else if(mode == 8'b10)
					spi_mosi_byte_d = party[text_count_q];
				else if(mode == 8'b11)
					spi_mosi_byte_d = stuff[text_count_q];
				
				// Update repeat and text counters
				if(repeat_count_q == 3'h0) begin
					text_count_d = text_count_q + 1'b1;
					repeat_count_d = 3'd7;
				end else
					repeat_count_d = repeat_count_q - 1'b1;
				
				// Determine next state
				if(text_count_q == 7'd64) begin
					text_count_d = 7'd0;
					dc_d = 1'b0; // back to command mode
					state_after_d = PAGE_ADDR_1;
				end else
					state_after_d = UPDATE_TXT;
			end
			
			// Setting page address to 0 and 4
			PAGE_ADDR_1: begin
				spi_mosi_byte_d = 8'h22; state_d = SPI_START; state_after_d = PAGE_ADDR_2;
			end
			PAGE_ADDR_2: begin
				spi_mosi_byte_d = 8'h00; state_d = SPI_START; state_after_d = PAGE_ADDR_3;
			end
			PAGE_ADDR_3: begin
				spi_mosi_byte_d = 8'h04; state_d = SPI_START; state_after_d = COL_ADDR_1;
			end
			
			// Setting column address to 0 and 127
			COL_ADDR_1: begin
				spi_mosi_byte_d = 8'h21; state_d = SPI_START; state_after_d = COL_ADDR_2;
			end
			COL_ADDR_2: begin
				spi_mosi_byte_d = 8'h00; state_d = SPI_START; state_after_d = COL_ADDR_3;
			end
			COL_ADDR_3: begin
				spi_mosi_byte_d = 8'h7F; state_d = SPI_START; state_after_d = IDLE;
			end
			
			// Idle state
			IDLE: begin
				state_d = DELAY_START; state_after_d = UPDATE_TXT;
			end
		endcase
	end

endmodule
