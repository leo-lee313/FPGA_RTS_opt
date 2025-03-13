`include "../parameter/global_parameter.v"


module ctrl_time_7(
								clk,
								sta,
								counter,
								time_1,
								value_1,
								time_2,
								value_2,
								time_3,
								value_3,
								time_4,
								value_4,
								time_5,
								value_5,
								time_6,
								value_6,
								time_7,
								value_7,
								
								y
							  );
							  
input clk;
input sta;
input [11:0] counter;
input [11:0] time_1,time_2,time_3,time_4,time_5,time_6,time_7;
input [`EXTENDED_SINGLE - 1:0]  value_1,value_2,value_3,value_4,value_5,value_6,value_7;

output reg [`EXTENDED_SINGLE - 1:0] y;

reg [2:0] cacou;
always@ (posedge clk or posedge sta) begin
	if(sta) begin
		cacou <= 3'b0;
	end
	else begin
		if((counter==time_1-1)||(counter==time_2-1)||(counter==time_3-1)||(counter==time_4-1)||(counter==time_5-1)||(counter==time_6-1)||(counter==time_7-1)) begin
		cacou <= cacou+3'b1;
		end
	end
end

muxer7 muxer7(
.clock(clk),
.sel(cacou),
.data0x(64'b0),
.data1x(value_1),
.data2x(value_2),
.data3x(value_3),
.data4x(value_4),
.data5x(value_5),
.data6x(value_6),
.data7x(value_7),

.result(y)
);

endmodule
