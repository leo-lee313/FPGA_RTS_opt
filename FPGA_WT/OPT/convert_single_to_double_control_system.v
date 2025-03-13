`include "../parameter/global_parameter.v"

module convert_single_to_double_control_system(
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
output [`EXTENDED_SINGLE - 1:0]y;

output done_sig;

DELAY_1CLK  #(2) Delay_sta_user_d(
						               .clk(clk),
						               .rst(rst),
						               .d(sta),
						               .q(done_sig)
					                  );

SINGLE2EXTENDED_SINGLE	SINGLE2EXTENDED_SINGLE (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(x),
													        .result(y)
													        );
															  
endmodule															  