`include "../parameter/global_parameter.v"


module threshold64(
					  clk,
					  rst,
					  sta,
					  x,
					  y,				  
					  done_sig
					 );
parameter toplimit = 64'h403B000000000000;
parameter lowlimit = 64'h4000000000000000;
parameter INI_N = 64'h0000000000000000;

												
input clk;
input rst;
input sta;
input[63:0] x;
output[63:0] y;
output done_sig;

reg [63:0] y_reg;					 


wire agb_sig1;
wire alb_sig1;
wire agb_sig2;
wire alb_sig2;

DELAY_1CLK #(2) Delay_DONE_SIG0(
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
	.datab ( toplimit ),
	.agb ( agb_sig1 ),
	.alb ( alb_sig1 )
	);

FloatComparator_64	FloatComparator_64_2 (
	.aclr ( rst ),
	.clk_en ( `ena_math ),
	.clock ( clk ),
	.dataa ( x ),
	.datab ( lowlimit ),
	.agb ( agb_sig2 ),
	.alb ( alb_sig2 )
	);


					 
always @ ( posedge clk or posedge rst ) begin
	if(rst)begin
		y_reg <= INI_N;
		
		end
	else if( agb_sig1==1'b1 )begin
		y_reg <= toplimit;		
		end
	else if( alb_sig2==1'b1 )begin
		y_reg <= lowlimit;		
		end
	else begin	   
		y_reg <= x;		
		end
end

assign y = y_reg;


	
/*				 
always @ ( posedge done_sig_comp ) begin
	
	if( agb_sig1==1 )begin
		y_reg <= toplimit;
		done_sig <= 1'b1;
		end
	else if( alb_sig2==1 )begin
		y_reg <= lowlimit;
		done_sig <= 1'b1;
		end
	else begin	   
		y_reg <= x;
		done_sig <= 1'b1;
		end
end
*/

					 					 							 


endmodule					 
					 