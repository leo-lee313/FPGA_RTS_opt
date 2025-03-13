`include "../parameter/global_parameter.v"

module PI_threshold64(
					 clk,
					 rst,
					 rst_user,
					 control_valuation_sig,
					 sta,
					 x,
						  
					 y,
					 done_sig
					);

parameter A = 64'h3FF0000000000000;
parameter B = 64'h3FF0000000000000;
parameter upper_limit 	= 64'h3FF0000000000000;
parameter down_limit 	= 64'h3FF0000000000000;
						 
input clk;
input rst;
input rst_user;
input sta;
input control_valuation_sig;
input [`EXTENDED_SINGLE - 1:0] x;

output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;

wire [`EXTENDED_SINGLE - 1:0] inner_result1;


wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;

wire [`EXTENDED_SINGLE - 1:0] x_reg;
wire [`EXTENDED_SINGLE - 1:0] y_reg;
wire [`EXTENDED_SINGLE - 1:0] y_temp;
wire done_sig_pi;
//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;
//transfer function=Kp+Ki/s;&& Ki=1/积分时间常数
//A = (delta_t/2)*Ki + Kp
//B = (delta_t/2)*Ki - Kp
DELAY_1CLK  #(19) Delay_DONE_SIG1(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig_pi)
										  );
										  
									  
multiplier_64	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);	
										
multiplier_64	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg),
														 .result(inner_result2)
		);
	
				
ADD_SUB_64	Adder_inner_result3(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(y_reg),
										  .result(inner_result3)
										 );
ADD_SUB_64	Adder_inner_result4(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result2),
										  .result(y_temp)
										 );														

threshold64  #(upper_limit,down_limit,64'h0000000000000000) threshold14(
					  .clk(clk),
					  .rst(rst),
					  .sta(done_sig_pi),
					  .x(y_temp),
					  .y(y),				  
					  .done_sig(done_sig)
					 );
										 										 																		 
System_partition_64 Storage_x(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(x),
									.cout(x_reg)
								  );
														 
System_partition_64 Storage_y(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(y),
									.cout(y_reg)
								  );
	
endmodule
	
