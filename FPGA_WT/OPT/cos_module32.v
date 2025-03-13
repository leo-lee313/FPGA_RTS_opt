`include "../parameter/global_parameter.v"

module cos_module32(
											clk,
											rst,
											sta,
											theta,
											
											cos_theta,
											done_sig
										  );
											
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] theta;


output [`SINGLE - 1:0] cos_theta;
output done_sig;

DELAY_1CLK #(36) Delay_DONE_SIG0(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );
								
costheta	 cos1(
								  .aclr(rst),
								  .clock(clk),								 
								  .data(theta),
								  .result(cos_theta)
								  );								  

endmodule


								 

