`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:34:35 12/07/2016 
// Design Name: 
// Module Name:    wrap 
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
module wrap(
input clk,
input start,
input unload,
input [15 : 0] xn_re,
input [15 : 0] xn_im,
input fwd_inv,
input fwd_inv_we,
output [9 : 0] xn_index,
output[31:0]Magnitude,
output[9 : 0] xk_index
);
wire dv;
wire rfd;
wire busy;
wire done;
wire edone;
//wire[6:0] xk_index;
wire[15:0]xk_re;
wire[15:0]xk_im;
 
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

reg[15:0] temp_re;
reg[15:0] temp_im;
reg[31:0] mag_out;
assign Magnitude = mag_out;

always@(xk_index,dv) begin
    if (dv ==1'b1) begin
    temp_re = xk_re;
    temp_im = xk_im;
    mag_out=(temp_re*temp_re)+(temp_im*temp_im);
    end
end


endmodule
