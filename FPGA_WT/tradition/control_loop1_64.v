`include "../parameter/global_parameter.v"


module control_loop1_64(
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

parameter A1 = 64'h3FF0000000000000;
parameter A2 = 64'h3FF0000000000000;
parameter B1 = 64'h3FF0000000000000;
parameter B2 = 64'h3FF0000000000000;
						 
input clk;
input rst;
input rst_user;
input control_valuation_sig;
input sta;

input [63:0]  input_1;
input [63:0]  input_2;
input [63:0]  input_3;
input [63:0]  input_4;

wire [63:0] error_1;
wire [63:0] error_2;

wire [63:0] inner_result1_PI1;
wire [63:0] inner_result2_PI1;
wire [63:0] inner_result3_PI1;
wire [63:0] x_reg_PI1;
wire [63:0] y_reg_PI1;

wire [63:0] inner_result1_PI2;
wire [63:0] inner_result2_PI2;
wire [63:0] inner_result3_PI2;
wire [63:0] x_reg_PI2;
wire [63:0] y_reg_PI2;
wire [63:0] done_sig1;
wire [63:0] output_1_temp;
reg [63:0] y_temp;
wire [63:0] output_2_temp;
reg [63:0] y_temp1;

output [63:0] output_1;
output [63:0] output_2;

output done_sig;




DELAY_1CLK  #(7) Delay_DONE_SIG1(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig1)
										  );
										  
										  
ADD_SUB_64	Adder_error_1(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(input_1),
								        .datab(input_2),
								        .result(error_1)
										 );										  
ADD_SUB_64	Adder_error_2(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(input_3),
								        .datab(input_4),
								        .result(error_2)
										 );										  									 

								 
DELAY_1CLK  #(19) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig1),
											.q(done_sig)
										  );	
PI64  #(A1 , A2) PI_1(
			 .clk(clk),
			 .rst(rst),
			 .rst_user(rst_user),
			 //.sta,
			 .control_valuation_sig(control_valuation_sig),
			 .x(error_1),
			 			 			 
			 .y(output_1)
			 //.done_sig
		   );									  

PI64  #(B1 , B2) PI_2(
			 .clk(clk),
			 .rst(rst),
			 .rst_user(rst_user),
			 //.sta,
			 .control_valuation_sig(control_valuation_sig),
			 .x(error_2),
			 			 			 
			 .y(output_2)
			 //.done_sig
		   );											  


										
endmodule
