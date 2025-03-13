`include "../parameter/Global_parameter.v"

module Cos_fix_1(
				   clk,
				   rst,
				   theta,
				   cos
				  );
			  
input clk;
input rst;
input [`SINGLE - 1:0] theta;

wire [`SINGLE - 1:0] cos_cal;

output [`SINGLE - 1:0] cos;
reg [`SINGLE - 1:0] cos;

costheta	cos_theta(
							 .aclr(rst),
							 .clock(clk),
							 .data(theta),
							 .result(cos_cal)
							);

							
always @(posedge clk or posedge rst) begin
	if(rst) begin
		cos <= 1'b0;
	end
	else if(cos_cal == 32'h3f000000) begin
		cos <= 32'h3f800000;
	end
	else if(cos_cal == 32'hbf000000) begin
		cos <= 32'hbf800000;
	end
	else if(cos_cal == 32'hbf275530) begin
		cos <= 32'h3f7ffff8;
	end	
	else begin
		cos <= cos_cal;
	end
end							

endmodule
