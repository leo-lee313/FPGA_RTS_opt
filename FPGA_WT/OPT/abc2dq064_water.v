`include "../parameter/global_parameter.v"

module abc2dq064_water(
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
				  
parameter const_1_divide_3 = 64'h3FD5555555555555;//1/3
parameter const_sqrt_3_divide_3 = 64'h3FE279A74591A01F;//sqrt(3)/3
parameter const_2 = 64'h4000000000000000;//2				  
input clk;
input rst;
input sta;

input [`EXTENDED_SINGLE - 1:0] Va;
input [`EXTENDED_SINGLE - 1:0] Vb;
input [`EXTENDED_SINGLE - 1:0] Vc;
input [`EXTENDED_SINGLE - 1:0] sin_theta;
input [`EXTENDED_SINGLE - 1:0] cos_theta;

wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay;
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay;

wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay1;
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay1;
wire [`EXTENDED_SINGLE - 1:0] inner_result_1;
wire [`EXTENDED_SINGLE - 1:0] inner_result_2;
wire [`EXTENDED_SINGLE - 1:0] inner_result_3,inner_result_3_delay;
wire [`EXTENDED_SINGLE - 1:0] inner_result_4;
wire [`EXTENDED_SINGLE - 1:0] inner_result_5;
wire [`EXTENDED_SINGLE - 1:0] inner_result_6;
wire [`EXTENDED_SINGLE - 1:0] inner_result_7;
wire [`EXTENDED_SINGLE - 1:0] inner_result_8;
wire [`EXTENDED_SINGLE - 1:0] inner_result_9,inner_result_9_delay;
wire [`EXTENDED_SINGLE - 1:0] inner_result_10;
wire [`EXTENDED_SINGLE - 1:0] inner_result_11,inner_result_11_delay;

output [`EXTENDED_SINGLE - 1:0] Vd;
output [`EXTENDED_SINGLE - 1:0] Vq;
output done_sig;

DELAY_1CLK  #(31) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );

//Vb + Vc
ADD_SUB_64		Adder_inner_result1(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(Vb),
										  .datab(Vc),
										  .result(inner_result_1)
										 );

//Vb - Vc
ADD_SUB_64		Adder_inner_result2(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(Vb),
										  .datab(Vc),
										  .result(inner_result_2)
										 );


//2*Va
//assign inner_result_3 = {Va[`SINGLE - 1],Va[`SINGLE - 2:`SINGLE - 9] + 1'b1,Va[`SINGLE - 10:0]};

multiplier_64_dsp	Multiplier_inner_result11(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Va),
														 .datab(const_2),
														 .result(inner_result_3)
														);
														
DELAY_NCLK  #(64,2)  DELAY_NCLK0(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_3),
						               .q(inner_result_3_delay)
					                 );														
														
//2*Va - (Vc + Vb)
ADD_SUB_64		Adder_inner_result4(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(inner_result_3_delay),
										  .datab(inner_result_1),
										  .result(inner_result_4)
										 );


//1/3*(2*Va - (Vc + Vb))
multiplier_64_dsp	Multiplier_inner_result5(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_4),
														 .datab(const_1_divide_3),
														 .result(inner_result_5)
														);
DELAY_NCLK  #(64,19)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(cos_theta),
						               .q(cos_theta_delay)
					                 );
										  
multiplier_64_dsp	Multiplier_inner_result8(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(cos_theta_delay),
														 .result(inner_result_8)
														);														
														
														
//sqrt(3)/3*(Vb - Vc)
multiplier_64_dsp	Multiplier_inner_result6(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_2),
														 .datab(const_sqrt_3_divide_3),
														 .result(inner_result_6)
														);

//sqrt(3)/3*(Vc - Vb)
assign inner_result_7 = {~inner_result_6[`EXTENDED_SINGLE - 1],inner_result_6[`EXTENDED_SINGLE - 2:0]};

//Vq

DELAY_NCLK  #(64,12)  DELAY_NCLK10(
						               .clk(clk),
											.rst(rst),
						               .d(sin_theta),
						               .q(sin_theta_delay)
					                 );
														
multiplier_64_dsp	Multiplier_inner_result9(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_6),
														 .datab(sin_theta_delay),
														 .result(inner_result_9)
														);
														
DELAY_NCLK  #(64,7)  DELAY_NCLK6(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_9),
						               .q(inner_result_9_delay)
					                 );
										  
ADD_SUB_64		Adder_Vq(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(inner_result_8),
							           .datab(inner_result_9_delay),
							           .result(Vq)
										 );														
														
//Vd
DELAY_NCLK  #(64,7)  DELAY_NCLK3(
						               .clk(clk),
											.rst(rst),
						               .d(sin_theta_delay),
						               .q(sin_theta_delay1)
					                 );
										  
DELAY_NCLK  #(64,12)  DELAY_NCLK5(
						               .clk(clk),
											.rst(rst),
						               .d(cos_theta),
						               .q(cos_theta_delay1)
					                 );
										  
multiplier_64_dsp	Multiplier_inner_result10(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5),
														 .datab(sin_theta_delay1),
														 .result(inner_result_10)
														);
														
multiplier_64_dsp	Multiplier_inner_result1111(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_7),
														 .datab(cos_theta_delay1),
														 .result(inner_result_11)
														);
														
DELAY_NCLK  #(64,7)  DELAY_NCLK2(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_11),
						               .q(inner_result_11_delay)
					                 );														
														
ADD_SUB_64		Adder_Vd(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(inner_result_10),
							           .datab(inner_result_11_delay),
							           .result(Vd)
										 );

endmodule

