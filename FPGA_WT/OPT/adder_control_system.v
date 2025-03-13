`include "../parameter/global_parameter.v"

module adder_control_system(
									 clk,
									 rst,
									 sta,
									 add_sub,
									 x,
									 y,
									 xy,
									 done_sig
								   );
											
input clk;
input rst;
input sta;
input add_sub;
input [`SINGLE - 1:0] x;
input [`SINGLE - 1:0] y;

output [`SINGLE - 1:0] xy;

output done_sig;

DELAY_1CLK #(7) Delay_DONE_SIG(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig)
										);
										
Adder_nodsp	Adder(
						.aclr(rst),
						.add_sub(add_sub),
						.clk_en(`ena_math),
						.clock(clk),
						.dataa(x),
						.datab(y),
						.result(xy)								 
					  );
							 
endmodule
