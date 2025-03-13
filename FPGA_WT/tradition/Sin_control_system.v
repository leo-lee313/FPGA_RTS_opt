`include "../parameter/global_parameter.v"

module Sin_control_system(
					          clk,
					          rst,
								 sta,
					          theta,
					          sin,
								 done_sig
					          );
			  
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] theta;

wire [`SINGLE - 1:0] sin_cal;

output [`SINGLE - 1:0] sin;
reg [`SINGLE - 1:0] sin;

output done_sig;

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
	else if(sin_cal == 32'hBE800000) begin
		sin <= 32'hBF000000;
	end
   else begin
		sin <= sin_cal;
	end	
end							
/*									 
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
	else begin
		sin <= sin_cal;
	end
end							
*/							

DELAY_1CLK  #(37) Delay_done_sig(
										.clk(clk),
										.rst(rst),
										.d(sta),
										.q(done_sig)
										);
endmodule
