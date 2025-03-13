`include "../parameter/global_parameter.v"

module sin_module(
											clk,
											rst,
											sta,
											theta,
											
											sin_theta,
											done_sig
										  );
											
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] theta;


output [`SINGLE - 1:0] sin_theta;
output done_sig;

DELAY_1CLK #(36) Delay_DONE_SIG0(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );
								
Sin_fix	 sin_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .theta(theta),
								  .sin(sin_theta)
								  );
								  

endmodule
