`include "../parameter/Global_parameter.v"

module PI(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 x,
			 y
		   );

parameter A = 32'h3f800000;
parameter B = 32'h3f800000;

input clk;
input rst;
input rst_user;
input sta;
input [`SINGLE - 1:0] x;

wire [`SINGLE - 1:0] inner_result1;
output [`SINGLE - 1:0] y;

wire [`SINGLE - 1:0] inner_result2;
wire [`SINGLE - 1:0] inner_result3;

wire [`SINGLE - 1:0] x_reg;
wire [`SINGLE - 1:0] y_reg;
//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;

//A = delta_t/2*Ki + Kp
//B = delta_t/2*Ki - Kp
Multiplier_nodsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);
										
Multiplier_nodsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg),
														 .result(inner_result2)
														);
	
Adder_nodsp	Adder_inner_result3(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(y_reg),
										  .result(inner_result3)
										 );

Adder_nodsp	Adder_inner_result4(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result2),
										  .result(y)
										 );

System_partition Storage_x(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(sta),
									.cin(x),
									.cout(x_reg)
								  );
														 
System_partition Storage_y(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(sta),
									.cin(y),
									.cout(y_reg)
								  );
	
endmodule
	
