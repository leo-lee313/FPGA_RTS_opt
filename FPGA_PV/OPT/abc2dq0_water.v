`include "../parameter/global_parameter.v"

module abc2dq0_water(
					clk,
					rst,					
					Va,
					Vb,
					Vc,
					sin_theta,
					cos_theta,
					
					Vd,
					Vq					
				  );
				  
parameter const_1_divide_3 = 32'h3eaaaaab;//1/3
parameter const_sqrt_3_divide_3 = 32'h3f13cd3a;//sqrt(3)/3
parameter const_2 = 32'h40000000;//2				  
input clk;
input rst;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] sin_theta;
input [`SINGLE - 1:0] cos_theta;

output [`SINGLE - 1:0] Vd;
output [`SINGLE - 1:0] Vq;

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
wire [`SINGLE - 1:0] inner_result_6_delay;
wire [`SINGLE - 1:0] inner_result_5_delay;
wire [`SINGLE - 1:0] inner_result_3_delay;									  
wire [`SINGLE - 1:0] inner_result_7_delay;
//Vb + Vc
Adder_nodsp	Adder_inner_result1(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(Vb),
										  .datab(Vc),
										  .result(inner_result_1)
										 );//J12//J17
										 
//Vb - Vc
Adder_nodsp		Adder_inner_result2(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`sub),										  										
										  .clock(clk),
										  .dataa(Vb),
										  .datab(Vc),
										  .result(inner_result_2)
										 );//J13//J18


//2*Va
assign inner_result_3 = {Va[`SINGLE - 1],Va[`SINGLE - 2:`SINGLE - 9] + 1'b1,Va[`SINGLE - 10:0]};//C13//C21

//Multiplier_nodsp_dsp	Multiplier_inner_result11(
//														 .aclr(rst),
//														 .clk_en(`ena_math),
//														 .clock(clk),
//														 .dataa(Va),
//														 .datab(const_2),
//														 .result(inner_result_3)
//														);
														
DELAY_NCLK  #(32,7)  DELAY_NCLK0(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_3),
						               .q(inner_result_3_delay)
					                 );														
														
//2*Va - (Vc + Vb)

Adder_nodsp	Adder_inner_result4(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`sub),
										  .clock(clk),
										  .dataa(inner_result_3_delay),
										  .datab(inner_result_1),
										  .result(inner_result_4)
										 );//J14//J19

//1/3*(2*Va - (Vc + Vb))
Multiplier_nodsp	Multiplier_inner_result5(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_4),
														 .datab(const_1_divide_3),
														 .result(inner_result_5)
														);//C14//C22
DELAY_NCLK  #(32,103)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_5),
						               .q(inner_result_5_delay)
					                 );
										  
Multiplier_nodsp	Multiplier_inner_result8(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5_delay),
														 .datab(cos_theta),
														 .result(inner_result_8)
														);	//C15	//C23												
														
														
//sqrt(3)/3*(Vb - Vc)
Multiplier_nodsp	Multiplier_inner_result6(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_2),
														 .datab(const_sqrt_3_divide_3),
														 .result(inner_result_6)
														);//C16//C24

//sqrt(3)/3*(Vc - Vb)
assign inner_result_7 = {~inner_result_6[`SINGLE - 1],inner_result_6[`SINGLE - 2:0]};//C17//C25

//Vq

DELAY_NCLK  #(32,110)  DELAY_NCLK10(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_6),
						               .q(inner_result_6_delay)
					                 );
														
Multiplier_nodsp	Multiplier_inner_result9(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_6_delay),
														 .datab(sin_theta),
														 .result(inner_result_9)
														);//C18//C26
														
										  
Adder_nodsp	Adder_Vq(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result_8),
							           .datab(inner_result_9),
							           .result(Vq)
										 );	//J15	//J20								  
														
														
//Vd
										  
Multiplier_nodsp	Multiplier_inner_result10(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_5_delay),
														 .datab(sin_theta),
														 .result(inner_result_10)
														);//C19//C27


DELAY_NCLK  #(32,110)  DELAY_NCLK11(
						               .clk(clk),
											.rst(rst),
						               .d(inner_result_7),
						               .q(inner_result_7_delay)
					                 );
														
Multiplier_nodsp	Multiplier_inner_result1111(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(inner_result_7_delay),
														 .datab(cos_theta),
														 .result(inner_result_11)
														);//C20//C28
														
										  
Adder_nodsp	Adder_Vd(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result_10),
							           .datab(inner_result_11),
							           .result(Vd)
										 );		//J16		//J21						  
																									
										 
										 
endmodule

