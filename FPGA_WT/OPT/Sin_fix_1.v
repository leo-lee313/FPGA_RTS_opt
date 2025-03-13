`include "../parameter/Global_parameter.v"

module Sin_fix_1(
					clk,
					rst,
					theta,
					sin
				  );
			  
input clk;
input rst;
input [`SINGLE - 1:0] theta;

wire [`SINGLE - 1:0] sin_cal;

output [`SINGLE - 1:0] sin;
reg [`SINGLE - 1:0] sin;

Sin_theta	sin_theta(
							 .aclr(rst),
							 .clk_en(`ena_math),
							 .clock(clk),
							 .data(theta),
							 .result(sin_cal)
							);

							
always @(posedge clk or posedge rst) begin
	if(rst) begin
		sin <= 1'b0;
	end
	else if(sin_cal == 32'h3f000000) begin
		sin <= 32'h3f800000;
	end
	else if(sin_cal == 32'hbf000000) begin
		sin <= 32'hbf800000;
	end
	else if(sin_cal == 32'hbf41bdce) begin
		sin <= 32'hba84ba1e;
	end
	else begin
		sin <= sin_cal;
	end
end							

endmodule
