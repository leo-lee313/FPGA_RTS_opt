`include "../parameter/global_parameter.v"

module dq02abc64_water(
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
parameter const_sqrt_3_divide_2 = 64'h3FEBB67AE85A702F;				  
parameter const_1_divide_2 = 64'h3FE0000000000000;				  
input clk;
input rst;
input sta;
input [`EXTENDED_SINGLE - 1:0] Vd;
input [`EXTENDED_SINGLE - 1:0] Vq;
input [`EXTENDED_SINGLE - 1:0] sin_theta;
input [`EXTENDED_SINGLE - 1:0] cos_theta;
wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay;
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay;

wire [`EXTENDED_SINGLE - 1:0] inner_result_1;
wire [`EXTENDED_SINGLE - 1:0] inner_result_2;
wire [`EXTENDED_SINGLE - 1:0] inner_result_3;
wire [`EXTENDED_SINGLE - 1:0] inner_result_4;
wire [`EXTENDED_SINGLE - 1:0] inner_result_5;
wire [`EXTENDED_SINGLE - 1:0] inner_result_6;
wire [`EXTENDED_SINGLE - 1:0] inner_result_7;
wire [`EXTENDED_SINGLE - 1:0] inner_result_8;
wire [`EXTENDED_SINGLE - 1:0] inner_result_9;
wire [`EXTENDED_SINGLE - 1:0] inner_result_10;
wire [`EXTENDED_SINGLE - 1:0] inner_result_11;
wire [`EXTENDED_SINGLE - 1:0] inner_result_12;
wire [`EXTENDED_SINGLE - 1:0] inner_result_13;
wire [`EXTENDED_SINGLE - 1:0] inner_result_14;
wire [`EXTENDED_SINGLE - 1:0] Va_temp;
output [`EXTENDED_SINGLE - 1:0] Va;
output [`EXTENDED_SINGLE - 1:0] Vb;
output [`EXTENDED_SINGLE - 1:0] Vc;
output done_sig;

DELAY_1CLK  #(24) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );


//Vd/2

multiplier_64_dsp	Multiplier_inner_result1113(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(const_1_divide_2),
														 .result(inner_result_1)
														);

//assign inner_result_1 = (Vd == 32'h00000000 || Vd == 32'h80000000) ? (32'h00000000) : {Vd[31],Vd[30:23] - 1'b1,Vd[22:0]};/////////////////////////////////
//Vq/2
multiplier_64_dsp	Multiplier_inner_result1114(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(const_1_divide_2),
														 .result(inner_result_2)
														);

//assign inner_result_2 = (Vq == 32'h00000000 || Vq == 32'h80000000) ? (32'h00000000) : {Vq[31],Vq[30:23] - 1'b1,Vq[22:0]};/////////////////////////////////

//sqrt(3)/2*Vd
multiplier_64_dsp	Multiplier_inner_result3(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(const_sqrt_3_divide_2),
														 .result(inner_result_3)
														);


//sqrt(3)/2*Vq
multiplier_64_dsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(const_sqrt_3_divide_2),
														 .result(inner_result_4)
														);
//sqrt(3)/2*Vq - Vd/2
ADD_SUB_64		Adder_inner_result_5(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(inner_result_4),
										  .datab(inner_result_1),
										  .result(inner_result_5)
										 );
								  
//sqrt(3)/2*Vd + Vq/2

ADD_SUB_64	Adder_inner_result_6(
											.aclr(rst),
											.add_sub(`add),
											.clk_en(`ena_math),											
											.clock(clk),
											.dataa(inner_result_2),
											.datab(inner_result_3),
											.result(inner_result_6)
										  );
								  
//sqrt(3)/2*Vq + Vd/2

ADD_SUB_64	Adder_inner_result_7(
											.aclr(rst),
											.add_sub(`add),
											.clk_en(`ena_math),
											.clock(clk),
											.dataa(inner_result_1),
											.datab(inner_result_4),
											.result(inner_result_7)
										  );
								  
//sqrt(3)/2*Vd - Vq/2
ADD_SUB_64	Adder_inner_result_8(
											.aclr(rst),
											.add_sub(`sub),
											.clk_en(`ena_math),										
											.clock(clk),
											.dataa(inner_result_3),
											.datab(inner_result_2),
											.result(inner_result_8)
										  );
										  
DELAY_NCLK  #(64,12)  DELAY_NCLK0(
						               .clk(clk),
											.rst(rst),
						               .d(sin_theta),
						               .q(sin_theta_delay)
					                 );
DELAY_NCLK  #(64,12)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(cos_theta),
						               .q(cos_theta_delay)
					                 );										  

//(sqrt(3)/2*Vq - Vd/2)*sin_theta							  
multiplier_64_dsp	Multiplier_inner_result9(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(sin_theta_delay),
														 .result(inner_result_9)
														);
														
//(sqrt(3)/2*Vd + Vq/2)*cos_theta							  
multiplier_64_dsp	Multiplier_inner_result10(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_6),
														 .datab(cos_theta_delay),
														 .result(inner_result_10)
														);
														
//(sqrt(3)/2*Vq + Vd/2)*sin_theta							  
multiplier_64_dsp	Multiplier_inner_result11(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_7),
														 .datab(sin_theta_delay),
														 .result(inner_result_11)
														);
														
//(sqrt(3)/2*Vd - Vq/2)*cos_theta							  
multiplier_64_dsp	Multiplier_inner_result12(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_8),
														 .datab(cos_theta_delay),
														 .result(inner_result_12)
														);
//Vd*sin_theta							  
multiplier_64_dsp	Multiplier_inner_result13(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vd),
														 .datab(sin_theta),
														 .result(inner_result_13)
														);
														
//Vq*cos_theta							  
multiplier_64_dsp	Multiplier_inner_result14(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vq),
														 .datab(cos_theta),
														 .result(inner_result_14)
														);
														
//Va
ADD_SUB_64		Adder_Va(
											.aclr(rst),
											.add_sub(`add),
											.clk_en(`ena_math),										
											.clock(clk),
											.dataa(inner_result_13),
							            .datab(inner_result_14),
							            .result(Va_temp)
										  );

DELAY_NCLK  #(64,12)  DELAY_NCLK2(
						               .clk(clk),
											.rst(rst),
						               .d(Va_temp),
						               .q(Va)
					                 );
										  
//Vb
ADD_SUB_64		Adder_Vb(
											.aclr(rst),
											.add_sub(`sub),
											.clk_en(`ena_math),										
											.clock(clk),
											.dataa(inner_result_9),
							            .datab(inner_result_10),
							            .result(Vb)
										  );
										  
//Vc
ADD_SUB_64		Adder_Vc(
											.aclr(rst),
											.add_sub(`sub),
											.clk_en(`ena_math),										
											.clock(clk),
											.dataa(inner_result_12),
							            .datab(inner_result_11),
							            .result(Vc)
										  );

endmodule


