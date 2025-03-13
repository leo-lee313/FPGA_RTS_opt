`include "../parameter/global_parameter.v"

module divider_control_system(
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
input [`SINGLE - 1:0] x;
input [`SINGLE - 1:0] y;

output [`SINGLE - 1:0] xy;

output done_sig;

DELAY_1CLK #(6) Delay_DONE_SIG(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig)
										);
										
Divide_nodsp	Divider(
							  .aclr(rst),
							  .clk_en(`ena_math),
							  .clock(clk),
							  .dataa(x),
							  .datab(y),
							  .result(xy)								 
							 );
							 
endmodule
