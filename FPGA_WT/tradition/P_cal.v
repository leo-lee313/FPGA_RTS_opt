`include "../parameter/global_parameter.v"

module P_cal(
				  clk,
				  rst_user,
				  rst,
				  sta,
				  control_valuation_sig,
				  Va,
				  Vb,
				  Vc,
				  Ia,
				  Ib,
				  Ic,
				  P,
				  
				  done_sig
				 );

input clk;
input rst;
input rst_user;
input control_valuation_sig;
input sta;

input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] Ia;
input [`SINGLE - 1:0] Ib;
input [`SINGLE - 1:0] Ic;


wire [`SINGLE - 1:0] inner_result_1;
wire [`SINGLE - 1:0] inner_result_2;
wire [`SINGLE - 1:0] inner_result_3;
wire [`SINGLE - 1:0] inner_result_4;
wire [`SINGLE - 1:0] inner_result_5;
wire [`SINGLE - 1:0] inner_result_6;
wire [`SINGLE - 1:0] P1;
wire [`SINGLE - 1:0] P2;
wire [`SINGLE - 1:0] P3;
wire [`SINGLE - 1:0] P4;

wire done_sig_P1;
wire done_sig_P2;
wire done_sig_P3;
wire done_sig_P4;


output [`SINGLE - 1:0] P;
output done_sig;

parameter const_50       = 32'h42480000;//50.000000

DELAY_1CLK  #(19) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig_P1)
										  );

//P1
//Va*Ia
Multiplier_nodsp_dsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Va),
														 .datab(Ia),
														 .result(inner_result_1)
														);
														
//Vb*Ib
Multiplier_nodsp_dsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vb),
														 .datab(Ib),
														 .result(inner_result_2)
														);
														
//Vc*Ic														
Multiplier_nodsp_dsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vc),
														 .datab(Ic),
														 .result(inner_result_3)
														);														
														
														
//Va*Ia+ Vb*Ib
Adder_nodsp	Adder_inner_result_3(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_1),
											.datab(inner_result_2),
											.result(inner_result_4)
										  );
								  
//P1
Adder_nodsp	Adder_inner_result_4(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_4),
											.datab(inner_result_3),
											.result(P1)
										  );


//////////////////////////////////////////////////////////////////////////////


/*
PI #(32'h3627C5AC , 32'h3627C5AC) PI_P1(
														 .clk(clk),
														 .rst(rst),
														 .rst_user(rst_user),
														 .sta(done_sig_P1),
														 .control_valuation_sig(control_valuation_sig),
														 .x(P1),
														 .y(P2),
														 .done_sig(done_sig_P2)
														);
*/
PI_limit  #(32'h00000000,32'h35C9539C,32'h60AD78EC,32'hE0AD78EC) PI_P1(
					.clk(clk),
					.rst(rst),
					.rst_user(rst_user),
					.control_valuation_sig(control_valuation_sig),
					.sta(done_sig_P1),
					.x(P1),
					
				   .y(P2),
					.done_sig(done_sig_P2)
					);

																												
Delay_control_system   Delay_mean(
											.clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.sta(done_sig_P2),
											.x(P2),
											
											.y(P3),
											.done_sig(done_sig_P3)
										   );
										  										  
adder_control_system   adder_P4(
											  .clk(clk),
											  .rst(rst),
											  .sta(done_sig_P3),
											  .add_sub(`sub),
											  .x(P2),
											  .y(P3),
											  .xy(P4),
											  .done_sig(done_sig_P4)
										     );
										  
multiplier_control_system_dsp   multiplier_P5(
													      .clk(clk),
													      .rst(rst),
													      .sta(done_sig_P4),
													      .x(P4),
													      .y(const_50),
													      .xy(P),
													      .done_sig(done_sig)
													      );
										



/////////////////////////////////////////////////////////////////////////////////


endmodule
