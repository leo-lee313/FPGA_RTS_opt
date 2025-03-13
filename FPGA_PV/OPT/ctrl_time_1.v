`include "../parameter/global_parameter.v"


module ctrl_time_1(
								clk,
								sta,
								counter,
								time_1,
								value_1,
								
								y
							  );
							  
input clk;
input sta;
input [11:0] counter;
input [11:0] time_1;
input [`EXTENDED_SINGLE - 1:0]  value_1;

output reg [`EXTENDED_SINGLE - 1:0] y;

reg cacou;
always@ (posedge clk or posedge sta) begin
	if(sta) begin
		cacou <=1'b0;
	end
	else begin
		if((counter==time_1-1)) begin
		cacou <= cacou+1'b1;
		end
	end
end

muxer1 muxer1(
.clock(clk),
.sel(cacou),
.data0x(64'b0),
.data1x(value_1),

.result(y)
);

endmodule
