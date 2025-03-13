`include "../parameter/global_parameter.v"

module Q_cal(
				  clk,
				  rst,
				  sta,
				  Va,
				  Vb,
				  Vc,
				  Ia,
				  Ib,
				  Ic,
				  
				  Q,
				  
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
wire [`SINGLE - 1:0] Vab;
wire [`SINGLE - 1:0] Vbc;
wire [`SINGLE - 1:0] Vca;

wire [`SINGLE - 1:0] inner_result_1;
wire [`SINGLE - 1:0] inner_result_2;
wire [`SINGLE - 1:0] inner_result_3;
wire [`SINGLE - 1:0] inner_result_4;
wire [`SINGLE - 1:0] inner_result_5;
wire [`SINGLE - 1:0] inner_result_6;

output [`SINGLE - 1:0] Q;
output done_sig;
parameter const11 = 32'h3F13CD3A;//1/(3^(1/2))=1/1.732050808=0.5773502692
DELAY_1CLK  #(31) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

//Q
//Vab=Va-Vb
Adder_nodsp	Adder_inner_result_1(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(Va),
											.datab(Vb),
											.result(Vab)
										  );
//Vbc=Vb-Vc
Adder_nodsp	Adder_inner_result_2(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(Vb),
											.datab(Vc),
											.result(Vbc)
										  );
										  
//Vca=Vc-Va
Adder_nodsp	Adder_inner_result_3(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(Vc),
											.datab(Va),
											.result(Vca)
										  );										  
										  
//Vab*Ic										  										 
Multiplier_nodsp_dsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vab),
														 .datab(Ic),
														 .result(inner_result_1)
														);
														
//Vbc*Ia
Multiplier_nodsp_dsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vbc),
														 .datab(Ia),
														 .result(inner_result_2)
														);
														
//Vca*Ib														
Multiplier_nodsp_dsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vca),
														 .datab(Ib),
														 .result(inner_result_3)
														);														
														
														
//Vab*Ic+ Vbc*Ia
Adder_nodsp	Adder_inner_result_113(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_1),
											.datab(inner_result_2),
											.result(inner_result_4)
										  );
								  
//Vab*Ic+ Vbc*Ia+Vca*Ib	
Adder_nodsp	Adder_inner_result_4(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_4),
											.datab(inner_result_3),
											.result(inner_result_5)
										  );

//[Vab*Ic+ Vbc*Ia+Vca*Ib]*(3^(1/2))														
Multiplier_nodsp_dsp	Multiplier_inner_result14(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(const11),
														 .result(Q)
														);	



endmodule
