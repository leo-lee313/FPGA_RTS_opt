`include "../parameter/Global_parameter.v"

module dq02abc(
					clk,
					rst,
					sta,
					Vd,
					Vq,
					sin_theta,
					cos_theta,
					
					Va,
					Vb,
					Vc,
					done_sig
				  );

parameter const_sqrt_3_divide_2 = 32'h3f5db3d7;//				  
				  
input clk;
input rst;
input sta;

input [`SINGLE - 1:0] Vd;
input [`SINGLE - 1:0] Vq;
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
wire [`SINGLE - 1:0] inner_result_12;
wire [`SINGLE - 1:0] inner_result_13;
wire [`SINGLE - 1:0] inner_result_14;
output [`SINGLE - 1:0] Va;
output [`SINGLE - 1:0] Vb;
output [`SINGLE - 1:0] Vc;

output done_sig;

DELAY_1CLK  #(24) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

//assign phase_inc = (phase >= `PHASE_NUM_INC) ? ( phase - `PHASE_NUM_INC) : (phase + `INC);
//Vd/2
assign inner_result_1 = (Vd == 32'h00000000 || Vd == 32'h80000000) ? (32'h00000000) : {Vd[31],Vd[30:23] - 1'b1,Vd[22:0]};
//Vq/2
assign inner_result_2 = (Vq == 32'h00000000 || Vq == 32'h80000000) ? (32'h00000000) : {Vq[31],Vq[30:23] - 1'b1,Vq[22:0]};
//sqrt(3)/2*Vd
Multiplier_nodsp	Multiplier_inner_result3(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(const_sqrt_3_divide_2),
														 .result(inner_result_3)
														);
//sqrt(3)/2*Vq
Multiplier_nodsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(const_sqrt_3_divide_2),
														 .result(inner_result_4)
														);
//sqrt(3)/2*Vq - Vd/2
Adder_nodsp	Adder_inner_result_5(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(inner_result_4),
											.datab(inner_result_1),
											.result(inner_result_5)
										  );
								  
//sqrt(3)/2*Vd + Vq/2
Adder_nodsp	Adder_inner_result_6(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_2),
											.datab(inner_result_3),
											.result(inner_result_6)
										  );
								  
//sqrt(3)/2*Vq + Vd/2
Adder_nodsp	Adder_inner_result_7(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(inner_result_1),
											.datab(inner_result_4),
											.result(inner_result_7)
										  );
								  
//sqrt(3)/2*Vd - Vq/2
Adder_nodsp	Adder_inner_result_8(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(inner_result_3),
											.datab(inner_result_2),
											.result(inner_result_8)
										  );

//(sqrt(3)/2*Vq - Vd/2)*sin_theta							  
Multiplier_nodsp	Multiplier_inner_result9(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(sin_theta),
														 .result(inner_result_9)
														);
														
//(sqrt(3)/2*Vd + Vq/2)*cos_theta							  
Multiplier_nodsp	Multiplier_inner_result10(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_6),
														 .datab(cos_theta),
														 .result(inner_result_10)
														);
														
//(sqrt(3)/2*Vq + Vd/2)*sin_theta							  
Multiplier_nodsp	Multiplier_inner_result11(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_7),
														 .datab(sin_theta),
														 .result(inner_result_11)
														);
														
//(sqrt(3)/2*Vd - Vq/2)*cos_theta							  
Multiplier_nodsp	Multiplier_inner_result12(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_8),
														 .datab(cos_theta),
														 .result(inner_result_12)
														);
//Vd*sin_theta							  
Multiplier_nodsp	Multiplier_inner_result13(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(sin_theta),
														 .result(inner_result_13)
														);
														
//Vq*cos_theta							  
Multiplier_nodsp	Multiplier_inner_result14(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(cos_theta),
														 .result(inner_result_14)
														);
														
//Va
Adder_nodsp	Adder_Va(
							.aclr(rst),
							.clk_en(`ena_math),
							.add_sub(`add),
							.clock(clk),
							.dataa(inner_result_13),
							.datab(inner_result_14),
							.result(Va)
						  );
//Vb
Adder_nodsp	Adder_Vb(
							.aclr(rst),
							.clk_en(`ena_math),
							.add_sub(`sub),
							.clock(clk),
							.dataa(inner_result_9),
							.datab(inner_result_10),
							.result(Vb)
						  );
//Vc
Adder_nodsp	Adder_Vc(
							.aclr(rst),
							.clk_en(`ena_math),
							.add_sub(`sub),
							.clock(clk),
							.dataa(inner_result_12),
							.datab(inner_result_11),
							.result(Vc)
						  );

endmodule


