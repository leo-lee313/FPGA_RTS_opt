`include "../parameter/global_parameter.v"

module PI_integrator64_water_v1(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read_x,
			 x,			 
			 y,
			 done_sig
		   );
			
parameter A = 64'h3FFFFFFEF39085F5;
parameter B = 64'h3FF0000000000000;
parameter upper_limit = 64'h3FF0000000000000;
parameter down_limit = 64'h3FF0000000000000;

input clk;
input rst;
input rst_user;
input sta;
input done_read_x;//before sta 10 clk
input [`EXTENDED_SINGLE - 1:0] x;
output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;
wire done_sig_1;



wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] y1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;
wire [`EXTENDED_SINGLE - 1:0] x_reg;
wire [`EXTENDED_SINGLE - 1:0] y_reg;

wire [`EXTENDED_SINGLE - 1:0] x_reg_delay;

wire before_enaread_y,done_read_x;

//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;
//transfer function=Kp+Ki/s;&& Ki=1/积分时间常数
//A = (delta_t/2)*Ki + Kp
//B = (delta_t/2)*Ki - Kp
DELAY_1CLK  #(19) Delay_DONE_SIG1(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig_1)
										  );

DELAY_1CLK  #(3) Delay_done_sig1(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(before_enaread_y)
										  );	
										  
DELAY_NCLK  #(64,15)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
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
										  .result(y1)
										 );														


limit_control_system64_water #(upper_limit , down_limit) limit_output_2(
									 .clk(clk),
									 .rst(rst),
									 .sta(done_sig_1),
									 .x(y1),
									 .y(y),
									 .done_sig(done_sig)
									 ); 
										 					 
System_FIFO_64 System_FIFO_1(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(before_enaread_y),
								.before_enawrite(done_sig),
								.cin( y ),
								.cout( y_reg )
							  );
							  	
System_FIFO_64 System_FIFO_2(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_x),
								.before_enawrite(sta),
								.cin( x ),
								.cout( x_reg )
							  );

endmodule
	
