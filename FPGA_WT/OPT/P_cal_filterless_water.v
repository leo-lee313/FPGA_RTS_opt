`include "../parameter/global_parameter.v"

module P_cal_filterless_water(
				  clk,
				  rst,
				  sta,
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
wire [`SINGLE - 1:0] inner_result_3_delay;
output [`SINGLE - 1:0] P;
output done_sig;


DELAY_1CLK  #(19) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

//P
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
										  
DELAY_NCLK  #(32,7)  DELAY_NCLK0(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_3),
						               .q(inner_result_3_delay)
					                 );
										  
//P1
Adder_nodsp	Adder_inner_result_4(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_4),
											.datab(inner_result_3_delay),
											.result(P)
										  );


//////////////////////////////////////////////////////////////////////////////									


endmodule
