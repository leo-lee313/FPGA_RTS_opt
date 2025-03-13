`include "../parameter/global_parameter.v"

module  limit_control_system_water(
									  clk,
									  rst,
									  sta,
									  x,
									  y,
									  done_sig
									 ); 
									 
parameter upper_limit = 32'h3f800000;
parameter down_limit = 32'h3f800000;
														
input clk;
input rst;
input sta;
input [`SINGLE - 1:0] x;

output [`SINGLE - 1:0] y;
reg [`SINGLE - 1:0] y;

output done_sig;
wire [`SINGLE - 1:0] x_reg;													
wire output_1,output_2,output_3,output_4;

DELAY_1CLK  #(2) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );

Float_compare_nodsp	Float_compare_1(
											  .clock(clk),
											  .dataa(x),
											  .datab(upper_limit),
											  .agb(output_1),
											  .alb(output_2)
											 );
											 
Float_compare_nodsp	Float_compare_2(
											  .clock(clk),
											  .dataa(x),
											  .datab(down_limit),
											  .agb(output_3),
											  .alb(output_4)
											 );
DELAY_NCLK  #(`SINGLE , 1 ) delay1(
						.clk(clk),
						.rst(rst),
						.d(x),
						.q(x_reg)
					  );											 
always @(posedge clk or posedge rst) begin
	if(rst) begin
		y <= 1'b0;
	end
	else if(output_1) begin
		y <= upper_limit;
	end
	else if(output_4) begin
		y <= down_limit;
	end
	else if(output_3&&output_2) begin
		y <= x_reg;
	end
	else begin
		y <= x_reg;
	end
end
	
endmodule
