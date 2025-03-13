`include "../parameter/global_parameter.v"

module P_cal_water (
				  clk,
				  rst_user,
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
input rst_user;
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
wire [`SINGLE - 1:0] P_filterless;
wire done_sig_P1;
wire done_read_x;
output [`SINGLE - 1:0] P;
wire [`SINGLE - 1:0] P_P;

output done_sig;

parameter const_inv_Sbase = 32'h3532F4FC;//1/1500000

DELAY_1CLK  #(24) Delay_DONE_SIG(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig_P1)
										  );
DELAY_1CLK  #(9) Delay_DONE_SIG01(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_read_x)
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
											.result(P_filterless)
										  );
										  
										  
Multiplier_nodsp_dsp	Multiplier0(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(P_filterless),
									  .datab(const_inv_Sbase),
									  .result(P_P)
									 );										  
										  
										  
										  
										  
//////////////////////////////////////////////////////////////////////
/*
PID_Initial32_water_v2 #(32'h399D3D3E,32'h399D3D3E,32'h3F7FD8B1,32'h3F800000) PID10(
			 .clk(clk),
			 .rst(rst),
			 .rst_user(rst_user),
			 .sta(done_sig_P1),
			 .done_read(done_read_x),
			 //.control_valuation_sig(control_valuation_sig),
			 .x(P_P),
			
			 .y(P),
			 .done_sig(done_sig)
		   );	//20

*/
PID_Initial32_water_v3 #(32'h396be064,32'h396be064,32'h3f7fe284,32'h3f800000) PID10(
			 .clk(clk),
			 .rst(rst),
			 .rst_user(rst_user),
			 .sta(done_sig_P1),
			 .done_read(done_read_x),
			 .x(P_P),
			
			 .y(P),
			 .done_sig(done_sig)
		   );	//20																														 
/////////////////////////////////////////////////////////////////////////////////















endmodule




