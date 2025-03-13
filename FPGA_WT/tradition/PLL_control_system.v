`include "../parameter/global_parameter.v"

module PLL_control_system(
			                clk,
			                sta,
			                rst,
			                rst_user,
			                control_valuation_sig,
			                Va,
			                Vb,
			                Vc,
			                cos,
			                sin,
			                
			                frequence,
			                theta,
			                done_sig
			                );
					  
parameter const_inv_3       = 32'h3eaaaaab;
parameter const_sqrt_inv_3  = 32'h3F13CD36;
parameter const_inv_2pi     = 32'h3E22F944;

input clk;
input sta;
input rst;
input rst_user;
input control_valuation_sig;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;

output [`SINGLE - 1:0] sin;
output [`SINGLE - 1:0] cos;
output [`SINGLE - 1:0] frequence;
output [`SINGLE - 1:0] theta;
output done_sig;

wire [`SINGLE - 1:0] inner_result_1;
wire [`SINGLE - 1:0] inner_result_2;
wire [`SINGLE - 1:0] inner_result_3;
wire [`SINGLE - 1:0] inner_result_4;
wire [`SINGLE - 1:0] inner_result_5;
wire [`SINGLE - 1:0] inner_result_6;
wire [`SINGLE - 1:0] inner_result_7;
wire [`SINGLE - 1:0] inner_result_8;
wire [`SINGLE - 1:0] inner_result_9;
wire [`SINGLE - 1:0] inner_result_10;

wire [`SINGLE - 1:0] sin_reg;
wire [`SINGLE - 1:0] cos_reg;

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

//2Va - (Vc + Vb)
Adder_nodsp	Substract_inner_result4(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(inner_result_1),
												.datab(inner_result_2),
												.result(inner_result_4)
											  );

//(2Va - (Vc + Vb))/3
Multiplier_nodsp_dsp	Multiplier_inner_result5(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_4),
														.datab(const_inv_3),
														.result(inner_result_5)
														);
														
//(2Va - (Vc + Vb))/3*cos_reg
Multiplier_nodsp_dsp	Multiplier_inner_result6(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_5),
														.datab(cos_reg),
														.result(inner_result_6)
														);
//(Vc - Vb)/sqr3
Multiplier_nodsp_dsp	Multiplier_inner_result7(
														.aclr(rst),
														.clk_en(`ena_math),
														.clock(clk),
														.dataa(inner_result_3),
														.datab(const_sqrt_inv_3),
														.result(inner_result_7)
														);
//(Vc - Vb)/sqr3*sin_reg
Multiplier_nodsp_dsp	Multiplier_inner_result8(
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
wire done_sig_PI_1;
														
PI_limit #(32'h43340000 , 32'h3B9D4952, 32'h49742400, 32'hC9742400) PI_1(
					 .clk(clk),
					 .rst(rst),
					 .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(sta),
					 .x(inner_result_9),
					 
					 .y(inner_result_10),
					 .done_sig(done_sig_PI_1)
					);													
														
Multiplier_nodsp_dsp	Multiplier_frequence(
												  .aclr(rst),
												  .clk_en(`ena_math),
												  .clock(clk),
												  .dataa(inner_result_10),
												  .datab(const_inv_2pi),
												  .result(frequence)
												  );
wire done_sig_PI_2;
												  
PI_limit #(32'h00000000 , 32'h35C9539C, 32'h501502F9, 32'hD01502F9) PI_2(
					 .clk(clk),
					 .rst(rst),
					 .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(sta),
					 .x(inner_result_10),
					 
					 .y(theta),
					 .done_sig(done_sig_PI_2)
					);
/*												  
Cos_fix	 cos_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .theta(theta),
								  .cos(cos)
								  );
							 
Sin_fix	 sin_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .theta(theta),
								  .sin(sin)
								  );
*/

Sin_control_system Sin_control_system(
					          .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PI_2),
					          .theta(theta),
								 .sin(sin)
								 //.done_sig
					          );
								  
Cos_control_system  Cos_control_system(
					          .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PI_2),
					          .theta(theta),
								 .cos(cos)
								 //.done_sig
					          );

								 
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
						
endmodule
