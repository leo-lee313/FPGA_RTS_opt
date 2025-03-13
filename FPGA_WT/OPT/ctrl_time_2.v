`include "../parameter/global_parameter.v"


module ctrl_time_2(
								clk,
								sta,
								counter,
								time_1,
								value_1,
								time_2,
								value_2,
								
								y
							  );
							  
input clk;
input sta;
input [11:0] counter;
input [11:0] time_1,time_2;
input [`EXTENDED_SINGLE - 1:0]  value_1,value_2;

output reg [`EXTENDED_SINGLE - 1:0] y;

reg [1:0] cacou;
always@ (posedge clk or posedge sta) begin
	if(sta) begin
		cacou <= 2'b0;
	end
	else begin
		if((counter==time_1-1)||(counter==time_2-1)) begin
		cacou <= cacou+2'b1;
		end
	end
end

muxer2 muxer2(
.clock(clk),
.sel(cacou),
.data0x(64'b0),
.data1x(value_1),
.data2x(value_2),

.result(y)
);

endmodule
