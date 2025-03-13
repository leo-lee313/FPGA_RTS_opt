`include "../parameter/global_parameter.v"


module ctrl_time_ADDSUB_11(
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
								time_8,
								value_8,
								time_9,
								value_9,
								time_10,
								value_10,
								time_11,
								value_11,
								
								y
							  );
							  
input clk;
input sta;
input [11:0] counter;
input [11:0] time_1,time_2,time_3,time_4,time_5,time_6,time_7,time_8,time_9,time_10,time_11;
input value_1,value_2,value_3,value_4,value_5,value_6,value_7,value_8,value_9,value_10,value_11;


output reg y;

reg [3:0] cacou;
always@ (posedge clk or posedge sta) begin
	if(sta) begin
		cacou <= 4'b0;
	end
	else begin
		if((counter==time_1-1)||(counter==time_2-1)||(counter==time_3-1)||(counter==time_4-1)||(counter==time_5-1)||(counter==time_6-1)||(counter==time_7-1)||(counter==time_8-1)||(counter==time_9-1)||(counter==time_10-1)||(counter==time_11-1)) begin
		cacou <= cacou+4'b1;
		end
	end
end

muxer11_math muxer11math(
.clock(clk),
.sel(cacou),
.data0(1'b0),
.data1(value_1),
.data2(value_2),
.data3(value_3),
.data4(value_4),
.data5(value_5),
.data6(value_6),
.data7(value_7),
.data8(value_8),
.data9(value_9),
.data10(value_10),
.data11(value_11),

.result(y)
);

endmodule
