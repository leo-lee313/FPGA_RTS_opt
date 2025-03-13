`include "../parameter/global_parameter.v"

module exp_control_system(
								  clk,
								  rst,
								  sta,
								  x,
								  y,
								  done_sig
								  );
											
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] x;

output [`SINGLE - 1:0] y;

output done_sig;

DELAY_1CLK #(17) Delay_DONE_SIG(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig)
										);
										
Exp_nodsp	Exp_nodsp(
							.aclr(rst),
							.clk_en(`ena_math),
							.clock(clk),
							.data(x),
							.result(y)
							);
							 
endmodule
