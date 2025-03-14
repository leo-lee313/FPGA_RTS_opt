`include "../parameter/global_parameter.v"

module PI_limit_water1(
					 clk,
					 rst,
					 rst_user,
					 sta,
					 done_read_x,
					 x,
						  
					 y,
					 done_sig
					);

parameter A1 				= 32'h3F000000;//Kp
parameter A2 				= 32'h3751B717;//delta_t/2*Ki
parameter upper_limit 	= 32'h3FC00000;
parameter down_limit 	= 32'hBFC00000;
						 
input clk;
input rst;
input rst_user;
input sta;
input done_read_x;//before sta 15clk
input [`SINGLE - 1:0]  x;

output [`SINGLE - 1:0] y;
output done_sig;

DELAY_1CLK  #(30) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );
/*
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
*/

wire [`SINGLE - 1:0]  output_1;
wire done_sig_PI;
wire done_read_x;
PI_integrator_water1 #(A2 , A2 , upper_limit , down_limit) PI_1(
						 .clk(clk),
						 .rst(rst),
						 .rst_user(rst_user),
						 .sta(sta),
						 .done_read_x(done_read_x),
						 
						 .x(x),
						 .y(output_1),
						 .done_sig(done_sig_PI)
						);
						
																					
wire [`SINGLE - 1:0]  output_3;
wire [`SINGLE - 1:0]  output_3_delay;


Multiplier_nodsp_dsp	Multiplier_1(
										 .aclr(rst),
										 .clk_en(`ena_math),
										 .clock(clk),
										 .dataa(x),
										 .datab(A1),
										 .result(output_3)
										);

DELAY_NCLK  #(`SINGLE , 16 ) delay1(
						.clk(clk),
						.rst(rst),
						.d(output_3),
						.q(output_3_delay)
					  );

										
wire [`SINGLE - 1:0]  output_4;
										
Adder_nodsp	Adder_output_4(
								   .aclr(rst),
								   .clk_en(`ena_math),
								   .add_sub(`add),
								   .clock(clk),
								   .dataa(output_1),
								   .datab(output_3_delay),
								   .result(output_4)
								  );
								 
wire [`SINGLE - 1:0]  y;
wire done_sig_output_5;
								  
limit_control_system_water #(upper_limit , down_limit) limit_output_5(
																					 .clk(clk),
																					 .rst(rst),
																					 .sta(sta),
																					 .x(output_4),
																					 .y(y),
																					 .done_sig(done_sig_output_5)
																					);
								 
endmodule
