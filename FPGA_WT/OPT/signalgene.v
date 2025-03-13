`include "../parameter/global_parameter.v"

module signalgene(
											clk,
											sta,
											sim_time,
											counter,

											done_sig
										  );

											
input clk;
input sta;
input [`WIDTH_TIME - 1:0] sim_time;
input [11:0] counter;

output [1000:0] done_sig;
reg [1000:0] done_sig1;

always @(posedge clk or posedge sta) begin
	if(sta) begin
		done_sig1 <= 350'h0;
	end
	else if(counter<=350&&counter>=1&&sim_time>=1) begin
		done_sig1[counter] <= 1'h1;
		done_sig1[counter-1] <= 1'h0;
	end
	else begin
		done_sig1 <= 350'h0;
	end
end										
assign done_sig=done_sig1;
endmodule
