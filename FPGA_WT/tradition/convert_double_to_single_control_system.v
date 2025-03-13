`include "../parameter/global_parameter.v"

module convert_double_to_single_control_system(
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

input [`EXTENDED_SINGLE - 1:0] x;
output [`SINGLE - 1:0]y;

output done_sig;

DELAY_1CLK  #(3) Delay_sta_user_d(
						               .clk(clk),
						               .rst(rst),
						               .d(sta),
						               .q(done_sig)
					                  );

EXTENDED_SINGLE2SINGLE	EXTENDED_SINGLE2SINGLE (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(x),
													        .result(y)
													        );
															  
endmodule															  