`include "../parameter/global_parameter.v"

module PI_limit64_water_v1(
					 clk,
					 rst,
					 rst_user,
					 sta,
					 done_read_x,
					 x,
						  
					 y,
					 done_sig
					);

parameter A1 = 64'h3FF0000000000000;//Kp
parameter A2 = 64'h3FF0000000000000;//delta_t/2*Ki										
parameter upper_limit 	= 64'h3FF0000000000000;
parameter down_limit 	= 64'h3FF0000000000000;
						 
input clk;
input rst;
input rst_user;
input sta;
input done_read_x;//before sta 10 clk
input [`EXTENDED_SINGLE - 1:0]  x;

output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;

DELAY_1CLK  #(30) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

wire [`EXTENDED_SINGLE - 1:0] output_1;
wire done_sig_PI;
wire done_read_x;

PI_integrator64_water_v1 #(A2 , A2 , upper_limit , down_limit) PI_1(
						 .clk(clk),
						 .rst(rst),
						 .rst_user(rst_user),
						 .sta(sta),
						 .done_read_x(done_read_x),
						 .x(x),
						 
						 .y(output_1),
						 .done_sig(done_sig_PI)
						);
						
/////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////
						
wire [`EXTENDED_SINGLE - 1:0]   output_3;
wire [`EXTENDED_SINGLE - 1:0]  output_3_delay;

multiplier_64	Multiplier_1(
										 .aclr(rst),
										 .clk_en(`ena_math),
										 .clock(clk),
										 .dataa(x),
										 .datab(A1),
										 .result(output_3)
										);

DELAY_NCLK  #(`EXTENDED_SINGLE , 16 ) delay1(
						.clk(clk),
						.rst(rst),
						.d(output_3),
						.q(output_3_delay)
					  );
										
wire [`EXTENDED_SINGLE - 1:0]   output_4;
									
ADD_SUB_64	Adder_output_4(
								   .aclr(rst),								 
								   .add_sub(`add),
									.clk_en(`ena_math),
								   .clock(clk),
								   .dataa(output_1),
								   .datab(output_3_delay),
								   .result(output_4)
								  );
								 
wire [`EXTENDED_SINGLE - 1:0]   y;
wire done_sig_output_5;
								  
limit_control_system64_water #(upper_limit , down_limit) limit_output_5(
																					 .clk(clk),
																					 .rst(rst),
																					 .sta(sta),
																					 .x(output_4),
																					 .y(y),
																					 .done_sig(done_sig_output_5)
																					);
								 
endmodule
