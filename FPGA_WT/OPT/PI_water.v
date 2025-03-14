`include "../parameter/global_parameter.v"

module PI_water(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read_x,
			 x,
			 y,
			 done_sig
		   );

parameter A = 32'h3f800000;
parameter B = 32'h3f800000;

input clk;
input rst;
input rst_user;
input sta;
input [`SINGLE - 1:0] x;
input done_read_x;//before sta 9 clk
output [`SINGLE - 1:0] y;
output  done_sig;
wire [`SINGLE - 1:0] inner_result1;
wire [`SINGLE - 1:0] inner_result2;
wire [`SINGLE - 1:0] inner_result3;
wire [`SINGLE - 1:0] x_reg_delay;
wire [`SINGLE - 1:0] x_reg;
wire [`SINGLE - 1:0] y_reg;
wire done_enaread;
//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;

//A = delta_t/2*Ki + Kp
//B = delta_t/2*Ki - Kp
DELAY_1CLK  #(19) Delay_done_sig(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										  );
										  
DELAY_1CLK  #(3) Delay_done_sig1(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_enaread)
										  );
										  
DELAY_NCLK  #(32,14)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
					                 );
										  
Multiplier_nodsp_dsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);
										
Multiplier_nodsp_dsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg_delay),
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

System_FIFO_32 System_FIFO_1(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_x),
								.before_enawrite(sta),
								.cin( x ),
								.cout( x_reg )
							  );

System_FIFO_32 System_FIFO_2(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_enaread),
								.before_enawrite(done_sig),
								.cin( y ),
								.cout( y_reg )
							  );
								  
endmodule
	
