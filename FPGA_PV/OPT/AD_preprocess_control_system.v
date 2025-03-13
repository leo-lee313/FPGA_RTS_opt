`include "../parameter/Global_parameter.v"

module AD_preprocess_control_system(
												clk,
												rst,
												sta,
												times,
												ad_mean,
												ad_result,
												done_sig
											  );
											  
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] times;

input [18:0] ad_mean;

wire [`SINGLE - 1:0] ad_float;

output [`SINGLE - 1:0] ad_result;

wire done_sig_fix2float;
wire done_sig_multiplier;

output done_sig;

assign done_sig = done_sig_multiplier;

FIX2FLOAT_AD_CONTROL_SYSTEM	FIX2FLOAT_AD_CONTROL_SYSTEM (
																			  .aclr(rst),
																			  .clk_en(`ena_math),
																			  .clock(clk),
																			  .dataa(ad_mean),
																			  .result(ad_float)
																			 );
																			 
DELAY_1CLK #(6) DELAY_FIX2FLOAT(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig_fix2float)
										 );

multiplier_control_system multiplier(
												 .clk(clk),
												 .rst(rst),
												 .sta(done_sig_fix2float),
												 .x(ad_float),
												 .y(times),
												 .xy(ad_result),
												 .done_sig(done_sig_multiplier)
												);
												
												
												
endmodule
