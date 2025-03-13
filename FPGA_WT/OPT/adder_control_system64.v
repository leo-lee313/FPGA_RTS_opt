`include "../parameter/global_parameter.v"

module adder_control_system64(
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
input [`EXTENDED_SINGLE - 1:0] x;
input [`EXTENDED_SINGLE - 1:0] y;

output [`EXTENDED_SINGLE - 1:0] xy;

output done_sig;

DELAY_1CLK #(7) Delay_DONE_SIG(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig)
										);

ADD_SUB_64	Adder(
										  .aclr(rst),
										  .add_sub(add_sub),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(x),
						              .datab(y),
						              .result(xy)
										 );
										
							 
endmodule