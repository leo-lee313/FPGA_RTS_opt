`include "../parameter/global_parameter.v"

module abc2dq0(
					clk,
					rst,
					sta,
					Va,
					Vb,
					Vc,
					sin_theta,
					cos_theta,
					
					Vd,
					Vq,
					done_sig
				  );
				  
parameter const_1_divide_3 = 32'h3eaaaaab;//1/3
parameter const_sqrt_3_divide_3 = 32'h3f13cd3a;//sqrt(3)/3
				  
input clk;
input rst;
input sta;

input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] sin_theta;
input [`SINGLE - 1:0] cos_theta;

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
wire [`SINGLE - 1:0] inner_result_11;

output [`SINGLE - 1:0] Vd;
output [`SINGLE - 1:0] Vq;
output done_sig;

DELAY_1CLK  #(31) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

//Vb + Vc
Adder_nodsp	Adder_inner_result1(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(Vb),
										  .datab(Vc),
										  .result(inner_result_1)
										 );

//Vb - Vc
Adder_nodsp	Adder_inner_result2(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`sub),
										  .clock(clk),
										  .dataa(Vb),
										  .datab(Vc),
										  .result(inner_result_2)
										 );

//2*Va
assign inner_result_3 = {Va[`SINGLE - 1],Va[`SINGLE - 2:`SINGLE - 9] + 1'b1,Va[`SINGLE - 10:0]};

//2*Va - (Vc + Vb)
Adder_nodsp	Adder_inner_result4(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`sub),
										  .clock(clk),
										  .dataa(inner_result_3),
										  .datab(inner_result_1),
										  .result(inner_result_4)
										 );

//1/3*(2*Va - (Vc + Vb))
Multiplier_nodsp_dsp	Multiplier_inner_result5(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_4),
														 .datab(const_1_divide_3),
														 .result(inner_result_5)
														);
														
//sqrt(3)/3*(Vb - Vc)
Multiplier_nodsp_dsp	Multiplier_inner_result6(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_2),
														 .datab(const_sqrt_3_divide_3),
														 .result(inner_result_6)
														);

//sqrt(3)/3*(Vc - Vb)
assign inner_result_7 = {~inner_result_6[`SINGLE - 1],inner_result_6[`SINGLE - 2:0]};

//Vq
Multiplier_nodsp_dsp	Multiplier_inner_result8(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(cos_theta),
														 .result(inner_result_8)
														);
														
Multiplier_nodsp_dsp	Multiplier_inner_result9(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_6),
														 .datab(sin_theta),
														 .result(inner_result_9)
														);

Adder_nodsp	Adder_Vq(
							.aclr(rst),
							.clk_en(`ena_math),
							.add_sub(`add),
							.clock(clk),
							.dataa(inner_result_8),
							.datab(inner_result_9),
							.result(Vq)
						  );

//Vd
Multiplier_nodsp_dsp	Multiplier_inner_result10(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(sin_theta),
														 .result(inner_result_10)
														);
														
Multiplier_nodsp_dsp	Multiplier_inner_result11(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_7),
														 .datab(cos_theta),
														 .result(inner_result_11)
														);

Adder_nodsp	Adder_Vd(
							.aclr(rst),
							.clk_en(`ena_math),
							.add_sub(`add),
							.clock(clk),
							.dataa(inner_result_10),
							.datab(inner_result_11),
							.result(Vd)
						  );
				  
endmodule

