`include "../parameter/Global_parameter.v"

module PLL_verify(
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
					  
//parameter const_2 = 32'h40000000;
parameter const_inv_3 = 32'h3eaaaaab;
parameter const_sqrt_inv_3 = 32'h3F13CD36;
parameter const_inv_2pi = 32'h3E22F944;
//parameter const_pi_inv_2 = 32'h3FC90FDB;
//parameter const_11 = 32'h3fc905ec;

input clk;
input sta;
input rst;
input rst_user;
input control_valuation_sig;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;

reg [`SINGLE - 1:0] inner_result_1;
wire [`SINGLE - 1:0] inner_result_1_delay;
wire [`SINGLE - 1:0] inner_result_2;
wire [`SINGLE - 1:0] inner_result_3;
wire [`SINGLE - 1:0] inner_result_4;

reg [`SINGLE - 1:0] inner_result_5;
reg [`SINGLE - 1:0] inner_result_6;

reg [`SINGLE - 1:0] multiplier_inner_result5_multiply_cos1;
reg [`SINGLE - 1:0] multiplier_inner_result5_multiply_cos2;
wire [`SINGLE - 1:0] multiplier_inner_result5_multiply_cos3;

wire sig1,sig2,sig3;

reg [`SINGLE - 1:0] inner_result_7;
reg [`SINGLE - 1:0] inner_result_8;

reg [`SINGLE - 1:0] multiplier_inner_result7_multiply_sin1;
reg [`SINGLE - 1:0] multiplier_inner_result7_multiply_sin2;
wire [`SINGLE - 1:0] multiplier_inner_result7_multiply_sin3;

wire sig4,sig5,sig6;

wire [`SINGLE - 1:0] inner_result_9;
wire [`SINGLE - 1:0] inner_result_10;

output [`SINGLE - 1:0] frequence;
output [`SINGLE - 1:0] theta;

output done_sig;

output [`SINGLE - 1:0] sin;
output [`SINGLE - 1:0] cos;

wire [`SINGLE - 1:0] sin_reg;
wire [`SINGLE - 1:0] cos_reg;


//Mutiply 2
always@ (posedge clk or posedge rst) begin
	if(rst) begin
		inner_result_1 <= 1'b0;
	end
	else begin
		inner_result_1 <= {Va[`SINGLE - 1],Va[`SINGLE - 2:`SINGLE - 9] + 1'b1,Va[`SINGLE - 10:0]};
	end
end

DELAY_NCLK #( `SINGLE , 6 ) delay_inner_result_1(
								.clk(clk),
								.rst(rst),
								.d(inner_result_1),
								.q(inner_result_1_delay)
								);

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
												.dataa(inner_result_1_delay),
												.datab(inner_result_2),
												.result(inner_result_4)
											  );

//(2Va - (Vc + Vb))*3 || multiply cos

DELAY_1CLK  #(14) Delay_14clk_sig2(
										  	  .clk(clk),
											  .rst(rst),
											  .d(sta),
											  .q(sig2)
											 );

DELAY_1CLK  #(6) Delay_20clk_sig1(
											 .clk(clk),
											 .rst(rst),
											 .d(sig2),
											 .q(sig1)
										   );
									  									 
DELAY_1CLK  #(6) Delay_26clk_sig3(
											 .clk(clk),
											 .rst(rst),
											 .d(sig1),
											 .q(sig3)
										   );

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		multiplier_inner_result5_multiply_cos1 <= 1'b0;
	end
	else if(sig2) begin
		multiplier_inner_result5_multiply_cos1 <= const_inv_3;
	end
	else if(sig1) begin
		multiplier_inner_result5_multiply_cos1 <= multiplier_inner_result5_multiply_cos3;
	end
	else begin
		multiplier_inner_result5_multiply_cos1 <= multiplier_inner_result5_multiply_cos1;
	end
end

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		multiplier_inner_result5_multiply_cos2 <= 1'b0;	
	end
	else if(sig2) begin
		multiplier_inner_result5_multiply_cos2 <= inner_result_4;
	end
	else if(sig1) begin
		multiplier_inner_result5_multiply_cos2 <= cos_reg;
		//multiplier_inner_result5_multiply_cos2 <= 32'h40000000;
	end
	else begin
		multiplier_inner_result5_multiply_cos2 <= multiplier_inner_result5_multiply_cos2;
	end
end

Multiplier_nodsp	Multiplier_inner_result5_multiply_cos(
														  .aclr(rst),
														  .clk_en(`ena_math),
														  .clock(clk),
														  .dataa(multiplier_inner_result5_multiply_cos1),
														  .datab(multiplier_inner_result5_multiply_cos2),
														  .result(multiplier_inner_result5_multiply_cos3)
														 );

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		inner_result_5 <= 1'b0;
		inner_result_6 <= 1'b0;
	end
	else if(sig1) begin
		inner_result_5 <= multiplier_inner_result5_multiply_cos3;
		inner_result_6 <= inner_result_6;
	end
	else if(sig3) begin
		inner_result_5 <= inner_result_5;
		inner_result_6 <= multiplier_inner_result5_multiply_cos3;
	end
	else begin
		inner_result_5 <= inner_result_5;
		inner_result_6 <= inner_result_6;
	end
end

DELAY_1CLK  #(7) Delay_7clk_sig5(
										   .clk(clk),
										   .rst(rst),
										   .d(sta),
										   .q(sig5)
										  );

DELAY_1CLK  #(6) Delay_13clk_sig4(
											 .clk(clk),
											 .rst(rst),
											 .d(sig5),
											 .q(sig4)
										   );
									  									 
DELAY_1CLK  #(6) Delay_19clk_sig6(
											 .clk(clk),
											 .rst(rst),
											 .d(sig4),
											 .q(sig6)
										   );

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		multiplier_inner_result7_multiply_sin1 <= 1'b0;
	end
	else if(sig5) begin
		multiplier_inner_result7_multiply_sin1 <= const_sqrt_inv_3;
	end
	else if(sig4) begin
		multiplier_inner_result7_multiply_sin1 <= multiplier_inner_result7_multiply_sin3;
	end
	else begin
		multiplier_inner_result7_multiply_sin1 <= multiplier_inner_result7_multiply_sin1;
	end
end

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		multiplier_inner_result7_multiply_sin2 <= 1'b0;	
	end
	else if(sig5) begin
		multiplier_inner_result7_multiply_sin2 <= inner_result_3;
	end
	else if(sig4) begin
		multiplier_inner_result7_multiply_sin2 <= sin_reg;
		//multiplier_inner_result7_multiply_sin2 <= 32'h40400000;
	end
	else begin
		multiplier_inner_result7_multiply_sin2 <= multiplier_inner_result7_multiply_sin2;
	end
end

Multiplier_nodsp	Multiplier_inner_result7_multiply_sin(
																		  .aclr(rst),
																		  .clk_en(`ena_math),
																		  .clock(clk),
																		  .dataa(multiplier_inner_result7_multiply_sin1),
																		  .datab(multiplier_inner_result7_multiply_sin2),
																		  .result(multiplier_inner_result7_multiply_sin3)
																		 );

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		inner_result_7 <= 1'b0;
		inner_result_8 <= 1'b0;
	end
	else if(sig4) begin
		inner_result_7 <= multiplier_inner_result7_multiply_sin3;
		inner_result_8 <= inner_result_8;
	end
	else if(sig6) begin
		inner_result_7 <= inner_result_7;
		inner_result_8 <= multiplier_inner_result7_multiply_sin3;
	end
	else begin
		inner_result_7 <= inner_result_7;
		inner_result_8 <= inner_result_8;
	end
end

Adder_nodsp	Substract_inner_result9(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(inner_result_6),
												.datab(inner_result_8),
												.result(inner_result_9)
											  );

PI #(32'h4334013B , 32'hC333FEC5) PI_1(
													.clk(clk),
													.rst(rst),
													.rst_user(rst_user),
													.sta(control_valuation_sig),
													.x(inner_result_9),
													.y(inner_result_10)
												  );
												  
Multiplier_nodsp	Multiplier_frequence(
													.aclr(rst),
													.clk_en(`ena_math),
													.clock(clk),
													.dataa(inner_result_10),
													.datab(const_inv_2pi),
													.result(frequence)
												  );
/*		 
PI #(32'h35C9539C , 32'h35C9539C) PI_2(
													.clk(clk),
													.rst(rst),
													.rst_user(rst_user),
													.sta(control_valuation_sig),
													.x(inner_result_10),
													.y(theta)
												  );
*/

PI_theta #(32'h35C9539C , 32'h35C9539C) PI_2(
			 .clk(clk),
			 .rst(rst),
			 .rst_user(rst_user),
			 .control_valuation_sig(control_valuation_sig),
			 .x(inner_result_10),
			 .y(theta)
		   );
			
Cos_fix	cos_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .theta(theta),
								  .cos(cos)
								 );
							 
Sin_fix	sin_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .theta(theta),
								  .sin(sin)
								 );
								 
DELAY_1CLK  #(91) Delay_46clk_sig7(
											 .clk(clk),
											 .rst(rst),
											 .d(sig3),
											 .q(done_sig)
										   );
											
/*								 
DELAY_1CLK  #(83) Delay_46clk_sig7(
											 .clk(clk),
											 .rst(rst),
											 .d(sig3),
											 .q(done_sig)
										   );
*/																																												
/*
always@ (posedge clk or posedge rst) begin
	if(rst) begin
		sin <= 1'b0;
		cos <= 1'b0;
	end
	else if(sig9) begin
		sin <= sin;
		cos <= sin_cos;
	end
	else if(sig10) begin
		sin <= sin_cos;
		cos <= cos;
	end
	else begin
		sin <= sin;
		cos <= cos;
	end
end
*/

System_partition System_partition_cos_theta(
														  .clk(clk),
													     .rst(rst_user),
														  .control_valuation_sig(control_valuation_sig),
														  .cin(cos),
														  .cout(cos_reg)
														 );

System_partition System_partition_sin_theta(
														  .clk(clk),
													     .rst(rst_user),
														  .control_valuation_sig(control_valuation_sig),
														  .cin(sin),
														  .cout(sin_reg)
														 );
						
endmodule
