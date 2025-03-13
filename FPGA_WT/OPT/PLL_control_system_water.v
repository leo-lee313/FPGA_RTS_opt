`include "../parameter/global_parameter.v"

module PLL_control_system_water(
			                clk,
			                sta,
			                rst,
			                rst_user,
			                Va,
			                Vb,
			                Vc,
			                cos,
			                sin,
			                
			                theta,
			                done_sig,
								 done_read_Ia
			                );
					  
parameter const_inv_3       = 32'h3eaaaaab;
parameter const_sqrt_inv_3  = 32'h3F13CD36;
parameter const_inv_2pi     = 32'h3E22F944;

input clk;
input sta;
input rst;
input rst_user;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;

output [`SINGLE - 1:0] sin;
output [`SINGLE - 1:0] cos;
output [`SINGLE - 1:0] theta;
output done_sig,done_read_Ia;

wire done_sig_PI_2,done_readPI2_x;
wire sta_PI1,done_readPI1_x;
wire done_cos,done_sin,done_read;
wire [`SINGLE - 1:0] cos_pre;
wire [`SINGLE - 1:0] inner_result_1,inner_result_1_delay;
wire [`SINGLE - 1:0] inner_result_2;
wire [`SINGLE - 1:0] inner_result_3,inner_result_3_delay;
wire [`SINGLE - 1:0] inner_result_4;
wire [`SINGLE - 1:0] inner_result_5;
wire [`SINGLE - 1:0] inner_result_6;
wire [`SINGLE - 1:0] inner_result_7;
wire [`SINGLE - 1:0] inner_result_8;
wire [`SINGLE - 1:0] inner_result_9;
wire [`SINGLE - 1:0] inner_result_10;
wire [`SINGLE - 1:0] sin_reg;
wire [`SINGLE - 1:0] cos_reg;
wire done_sig_PI_1;

DELAY_1CLK #(128) Delay_done_sig(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig)
										 );

//Va*2
assign inner_result_1 = {Va[`SINGLE - 1],Va[`SINGLE - 2:`SINGLE - 9] + 1'b1,Va[`SINGLE - 10:0]};

//Vc + Vb
Adder_nodsp	Adder_inner_result2(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(Vc),
										  .datab(Vb),
										  .result(inner_result_2)
										 );

//Vc - Vb
Adder_nodsp	Substract_inner_result3(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(Vc),
												.datab(Vb),
												.result(inner_result_3)
											  );
											  
DELAY_NCLK  #(32,7)  DELAY_NCLK0(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_1),
						               .q(inner_result_1_delay)
					                 );											  

//2Va - (Vc + Vb)
Adder_nodsp	Substract_inner_result4(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(inner_result_1_delay),
												.datab(inner_result_2),
												.result(inner_result_4)
											  );

//(2Va - (Vc + Vb))/3
Multiplier_nodsp	Multiplier_inner_result5(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_4),
														.datab(const_inv_3),
														.result(inner_result_5)
														);
														
//(2Va - (Vc + Vb))/3*cos_reg
Multiplier_nodsp	Multiplier_inner_result6(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_5),
														.datab(cos_reg),
														.result(inner_result_6)
														);
//(Vc - Vb)/sqr3

DELAY_NCLK  #(32,7)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_3),
						               .q(inner_result_3_delay)
					                 );


Multiplier_nodsp	Multiplier_inner_result7(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_3_delay),
														.datab(const_sqrt_inv_3),
														.result(inner_result_7)
														);
//(Vc - Vb)/sqr3*sin_reg
Multiplier_nodsp	Multiplier_inner_result8(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_7),
														.datab(sin_reg),
														.result(inner_result_8)
														);

//(2Va - (Vc + Vb))/3*cos_reg - (Vc - Vb)/sqr3*sin_reg														
Adder_nodsp	Substract_inner_result9(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(inner_result_6),
												.datab(inner_result_8),
												.result(inner_result_9)
											  );

DELAY_1CLK #(31) Delay1(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(sta_PI1)
										 );
DELAY_1CLK #(16) Delay2(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_readPI1_x)
										 );
									 
PI_limit_water1  #(32'h43340000,32'h3c6bedfa, 32'h49742400, 32'hC9742400) PI_1(
					 .clk(clk),
					 .rst(rst),
					 .rst_user(rst_user),
					 .sta(sta_PI1),
	             .done_read_x(done_readPI1_x),
					 .x(inner_result_9),
					 .y(inner_result_10),
					 .done_sig(done_sig_PI_1)									  
					);										 
											 																										
DELAY_1CLK #(46) Delay3(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_readPI2_x)
										 );
                 
PI_limit_water1_theta  #(32'h00000000,32'h3696feb5, 32'h501502F9, 32'hD01502F9) PI_2(
					 .clk(clk),
					 .rst(rst),
					 .rst_user(rst_user),
					 .sta(done_sig_PI_1),
	             .done_read_x(done_readPI2_x),
					 .x(inner_result_10),
					 .y(theta),
					 .done_sig(done_sig_PI_2)									  
					);	
					
					
DELAY_1CLK #(35) Delay3rr(
										 .clk(clk),
										 .rst(rst),
										 .d(done_sig_PI_2),
										 .q(done_read_Ia)
										 );
												  				  
Cos_control_system_water cos_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .sta(done_sig_PI_2),
								  .theta(theta),
								  .cos(cos_pre),
								  .done_sig(done_cos)
								  );
								  
DELAY_NCLK  #(32,1)  DELAY_NCLKa0(
						               .clk(clk),
											.rst(rst),
						               .d(cos_pre),
						               .q(cos)
					                 );
										  
Sin_control_system_water sin_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .sta(done_sig_PI_2),
								  .theta(theta),
								  .sin(sin),
								  .done_sig(done_sin)
								  );
								  
DELAY_1CLK #(17) Delay3a(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_read)
										 );
										 
System_FIFO_32 System_FIFO_1(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read),
								.before_enawrite(done_sin),
								.cin( cos ),
								.cout( cos_reg )
							  );	
							  
System_FIFO_32 System_FIFO_2(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read),
								.before_enawrite(done_sin),
								.cin( sin ),
								.cout( sin_reg )
							  );								  
								  
								  
/*								  								 
System_partition  System_partition_cos_theta(
														  .clk(clk),
													     .rst(rst_user),
														  .control_valuation_sig(control_valuation_sig),
														  .cin(cos),
														  .cout(cos_reg)
														  );

System_partition  System_partition_sin_theta(
														  .clk(clk),
													     .rst(rst_user),
														  .control_valuation_sig(control_valuation_sig),
														  .cin(sin),
														  .cout(sin_reg)
														  );
*/



						
endmodule



