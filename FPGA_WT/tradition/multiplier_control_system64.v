`include "../parameter/global_parameter.v"

module multiplier_control_system64(
											clk,
											rst,
											sta,
											x,
											y,
											xy,
											done_sig
										  );
											
input clk;
input rst;
input sta;
input [`EXTENDED_SINGLE - 1:0] x;
input [`EXTENDED_SINGLE - 1:0] y;

output [`EXTENDED_SINGLE - 1:0] xy;

output done_sig;

DELAY_1CLK #(5) Delay_DONE_SIG(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig)
										);

multiplier_64_dsp     Multiplier(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(x),
									  .datab(y),
									  .result(xy)
									 );

										
endmodule
