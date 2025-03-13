`include "../parameter/global_parameter.v"

module PI64_water_v1(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read_x,
			 x,
			 			 			 
			 y,
			 done_sig
		   );

parameter A = 64'h3FF0000000000000;
parameter B = 64'h3FF0000000000000;

input clk;
input rst;
input rst_user;
input sta;
input done_read_x;//before sta 11 clk
input [`EXTENDED_SINGLE - 1:0] x;

output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;

wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;

wire [`EXTENDED_SINGLE - 1:0] x_reg,x_reg_delay;
wire [`EXTENDED_SINGLE - 1:0] y_reg;
wire done_enaread,done_read_x;


//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;
//transfer function=Kp+Ki/s;&& Ki=1/积分时间常数
//A = (delta_t/2)*Ki + Kp
//B = (delta_t/2)*Ki - Kp
DELAY_1CLK  #(19) Delay_DONE_SIG1(
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
										  
DELAY_NCLK  #(64,16)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
					                 );	
										  
multiplier_64_dsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);	
										
multiplier_64_dsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg_delay),
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
										  .result(y)
										 );														

System_FIFO_64 System_FIFO_1(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_x),
								.before_enawrite(sta),
								.cin( x ),
								.cout( x_reg )
							  );

System_FIFO_64 System_FIFO_2(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_enaread),
								.before_enawrite(done_sig),
								.cin( y ),
								.cout( y_reg )
							  );
											 										 
								  
	
endmodule
	
