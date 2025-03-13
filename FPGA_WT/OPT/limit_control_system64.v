`include "../parameter/global_parameter.v"

module  limit_control_system64(
									  clk,
									  rst,
									  sta,
									  x,
									  y,
									  done_sig
									 ); 
									 
parameter upper_limit = 64'h403B000000000000;
parameter down_limit = 64'h4000000000000000;
														
input clk;
input rst;
input sta;
input [`EXTENDED_SINGLE - 1:0] x;

output [`EXTENDED_SINGLE - 1:0] y;
reg [`EXTENDED_SINGLE - 1:0] y;

output done_sig;
													
wire output_1,output_2,output_3,output_4;

DELAY_1CLK  #(2) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );

FloatComparator_64	FloatComparator_64_1 (
	.aclr ( rst ),
	.clk_en ( `ena_math ),
	.clock ( clk ),
	.dataa ( x ),
	.datab ( upper_limit ),
	.agb ( output_1 ),
	.alb ( output_2 )
	);
	
FloatComparator_64	FloatComparator_64_2 (
	.aclr ( rst ),
	.clk_en ( `ena_math ),
	.clock ( clk ),
	.dataa ( x ),
	.datab ( down_limit ),
	.agb ( output_3 ),
	.alb ( output_4 )
	);	
											 
always @(posedge clk or posedge rst) begin
	if(rst) begin
		y <= 64'h0;
	end
	else if(output_1) begin
		y <= upper_limit;
	end
	else if(output_4) begin
		y <= down_limit;
	end
	else if(output_3&output_2) begin
		y <= x;
	end
	else begin
		y <= x;
	end
end
	
endmodule
