`include "../parameter/global_parameter.v"

module Cos_control_system_water_1(
				   clk,
				   rst,
					sta,
				   theta,
				   cos,
					done_sig
				  );
			  			  
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] theta;

wire [`SINGLE - 1:0] cos_cal;

output [`SINGLE - 1:0] cos;
reg [`SINGLE - 1:0] cos;
output done_sig;
							
Cos_fix_1	cos_theta_module(
								  .clk(clk),
								  .rst(rst),
								  .theta(theta),
								  .cos(cos_cal)
								 );
								 
							
always @(posedge clk or posedge rst) begin
	if(rst) begin
		cos <= 1'b0;
	end
	//else if(cos_cal == 32'h3f000000) begin
		//cos <= 32'h3f800000;
	//end
	//else if(cos_cal == 32'hbf000000) begin
		//cos <= 32'hbf800000;
	//end
	else begin
		cos <= cos_cal;
	end
end							

DELAY_1CLK  #(37) Delay_done_sig(
										.clk(clk),
										.rst(rst),
										.d(sta),
										.q(done_sig)
										);


endmodule
