`include "../parameter/Global_parameter.v"

module Comparator(
						clk,
						rst,
						sta,
						input_1,
						input_2,
						output_1,
						output_2,
						done_sig
					  );
			  
input clk;
input rst;
input sta;

input [`SINGLE - 1:0] input_1;
input [`SINGLE - 1:0] input_2;

output output_1;
output output_2;

output done_sig;

DELAY_1CLK  #(1) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );

Float_compare_nodsp	Float_compare(
											  .clock(clk),
											  .dataa(input_1),
											  .datab(input_2),
											  .agb(output_1),
											  .alb(output_2)
											 );

endmodule
