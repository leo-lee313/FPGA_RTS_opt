`include "../parameter/Global_parameter.v"

module PQ_cal(
				  clk,
				  rst,
				  sta,
				  Vd,
				  Vq,
				  Id,
				  Iq,
				  P,
				  Q,
				  done_sig
				 );

parameter const_3_divide_2 = 32'h3fc00000;//3/2

input clk;
input rst;
input sta;

input [`SINGLE - 1:0] Vd;
input [`SINGLE - 1:0] Vq;
input [`SINGLE - 1:0] Id;
input [`SINGLE - 1:0] Iq;

wire [`SINGLE - 1:0] inner_result_1;
wire [`SINGLE - 1:0] inner_result_2;
wire [`SINGLE - 1:0] inner_result_3;
wire [`SINGLE - 1:0] inner_result_4;
wire [`SINGLE - 1:0] inner_result_5;
wire [`SINGLE - 1:0] inner_result_6;

output [`SINGLE - 1:0] P;
output [`SINGLE - 1:0] Q;

output done_sig;

DELAY_1CLK  #(17) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

//P
//Vd*Id
Multiplier_nodsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(Id),
														 .result(inner_result_1)
														);
														
//Vq*Iq
Multiplier_nodsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(Iq),
														 .result(inner_result_2)
														);
//Vd*Id + Vq*Iq
Adder_nodsp	Adder_inner_result_3(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_1),
											.datab(inner_result_2),
											.result(inner_result_3)
										  );
								  
//P
Multiplier_nodsp	Multiplier_P(
										 .aclr(rst),
										 .clk_en(`ena_math),
										 .clock(clk),
										 .dataa(inner_result_3),
										 .datab(const_3_divide_2),
										 .result(P)
										);
										
//Q
//Vq*Id
Multiplier_nodsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(Id),
														 .result(inner_result_4)
														);
														
//Vd*Iq
Multiplier_nodsp	Multiplier_inner_result5(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(Iq),
														 .result(inner_result_5)
														);
//Vq*Id - Vd*Iq
Adder_nodsp	Adder_inner_result_6(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(inner_result_4),
											.datab(inner_result_5),
											.result(inner_result_6)
										  );

//Q
Multiplier_nodsp	Multiplier_Q(
										 .aclr(rst),
										 .clk_en(`ena_math),
										 .clock(clk),
										 .dataa(inner_result_6),
										 .datab(const_3_divide_2),
										 .result(Q)
										);

endmodule
