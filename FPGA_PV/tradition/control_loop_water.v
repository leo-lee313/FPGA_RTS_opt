`include "../parameter/Global_parameter.v"

module control_loop_water(
						  clk,
						  rst,
						  rst_user,
						  done_read_x,
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
parameter B1 = 32'h3F800000;
parameter B2 = 32'h3F800000;
						 
input clk;
input rst;
input rst_user;
input done_read_x;
input sta;

input [`SINGLE - 1:0]  input_1;
input [`SINGLE - 1:0]  input_2;
input [`SINGLE - 1:0]  input_3;
input [`SINGLE - 1:0]  input_4;

wire [`SINGLE - 1:0] error_1;
wire [`SINGLE - 1:0] error_2;

output [`SINGLE - 1:0] output_1;
output [`SINGLE - 1:0] output_2;

output done_sig;
wire sta_PI1,done_sig_PI_1,done_sig_PI_2;

DELAY_1CLK  #(28) Delay_DONE_SIG(
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
								 );//J24//J30

Adder_nodsp	Adder_error_2(
								  .aclr(rst),
								  .clk_en(`ena_math),
								  .add_sub(`sub),
								  .clock(clk),
								  .dataa(input_3),
								  .datab(input_4),
								  .result(error_2)
								 );//J25//J31
								 
DELAY_1CLK  #(7) Delay_DONE_SIG1(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(sta_PI1)
										  );								 
								 
/*
PI #(A1 , A2) PI_1(
						 .clk(clk),
						 .rst(rst),
						 .rst_user(rst_user),
						 .sta(control_valuation_sig),
						 .x(error_1),
						 .y(output_1)
						);
*/
						
PI_integrator_water1 #(A1 , A2) PI_1(
						 .clk(clk),
						 .rst(rst),
						 .rst_user(rst_user),
						 .sta(sta_PI1),
						 .done_read_x(done_read_x),
						 
						 .x(error_1),
						 .y(output_1),
						 .done_sig(done_sig_PI_1)
						);						
						
/*						
PI #(B1 , B2) PI_2(
						 .clk(clk),
						 .rst(rst),
						 .rst_user(rst_user),
						 .sta(control_valuation_sig),
						 .x(error_2),
						 .y(output_2)
						);
						
*/						
PI_integrator_water1 #(B1 , B2) PI_2(
						 .clk(clk),
						 .rst(rst),
						 .rst_user(rst_user),
						 .sta(sta_PI1),
						 .done_read_x(done_read_x),
						 
						 .x(error_2),
						 .y(output_2),
						 .done_sig(done_sig_PI_2)
						);							

endmodule
