`include "../parameter/global_parameter.v"

module control_loop_limit(
								  clk,
								  rst,
								  rst_user,
								  control_valuation_sig,
								  sta,
								  input_1,
								  input_2,
								  input_3,
								  input_4,
								  
								  output_1,
								  output_2,
								  done_sig
								 );

parameter A1 = 32'h3F800000;
parameter A2 = 32'h3F800000;
parameter upper_limit_1 = 32'h3F800000;
parameter down_limit_1  = 32'h3F800000;
parameter B1 = 32'h3F800000;
parameter B2 = 32'h3F800000;
parameter upper_limit_2 = 32'h3F800000;
parameter down_limit_2  = 32'h3F800000;
						 
input clk;
input rst;
input rst_user;
input control_valuation_sig;
input sta;

input [`SINGLE - 1:0]  input_1;
input [`SINGLE - 1:0]  input_2;
input [`SINGLE - 1:0]  input_3;
input [`SINGLE - 1:0]  input_4;

wire [`SINGLE - 1:0] error_1;
wire [`SINGLE - 1:0] error_2;

wire [`SINGLE - 1:0] inner_result1_PI1;
wire [`SINGLE - 1:0] inner_result2_PI1;
wire [`SINGLE - 1:0] inner_result3_PI1;
wire [`SINGLE - 1:0] x_reg_PI1;
wire [`SINGLE - 1:0] y_reg_PI1;

wire [`SINGLE - 1:0] inner_result1_PI2;
wire [`SINGLE - 1:0] inner_result2_PI2;
wire [`SINGLE - 1:0] inner_result3_PI2;
wire [`SINGLE - 1:0] x_reg_PI2;
wire [`SINGLE - 1:0] y_reg_PI2;

output [`SINGLE - 1:0] output_1;
output [`SINGLE - 1:0] output_2;

output done_sig;

DELAY_1CLK  #(37) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

Adder_nodsp	Adder_error_1(
								  .aclr(rst),
								  .clk_en(`ena_math),
								  .add_sub(`sub),
								  .clock(clk),
								  .dataa(input_1),
								  .datab(input_2),
								  .result(error_1)
								 );

Adder_nodsp	Adder_error_2(
								  .aclr(rst),
								  .clk_en(`ena_math),
								  .add_sub(`sub),
								  .clock(clk),
								  .dataa(input_3),
								  .datab(input_4),
								  .result(error_2)
								 );
								 
wire done_output_1,done_output_2;
wire done_sig_1,done_sig_2;
								 
PI_limit #(A1,A2,upper_limit_1,down_limit_1) PI_limit_output_1(
																					.clk(clk),
																					.rst(rst),
																					.rst_user(rst_user),
																					.control_valuation_sig(control_valuation_sig),
																					.sta(sta),
																					.x(error_1),
																						  
																					.y(output_1),
																					.done_sig(done_sig_1)
																				  );
																				 
PI_limit #(B1,B2,upper_limit_2,down_limit_2) PI_limit_output_2(
																					.clk(clk),
																					.rst(rst),
																					.rst_user(rst_user),
																					.control_valuation_sig(control_valuation_sig),
																					.sta(sta),
																					.x(error_2),
																					  
																					.y(output_2),
																					.done_sig(done_sig_2)
																				  );

endmodule
