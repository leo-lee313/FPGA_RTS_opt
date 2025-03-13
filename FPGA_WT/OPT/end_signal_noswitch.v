module end_signal_noswitch(
				      clk,
					   rst,
					   sig1,
					   sig2,
						sig3,
						sig4,
						sig5,
					   sig_out
					  );
					  
input clk;
input rst;
input sig1;
input sig2;
input sig3;
input sig4;
input sig5;


output sig_out;
reg sig_out;

wire sig;

reg[2:0] i;

assign sig = sig1&sig2&sig3&sig4&sig5;
//assign sig = sig1&sig2;

always @ ( posedge clk or posedge rst ) begin
	if(rst) begin
		i <= 1'd0;
		sig_out <= 1'b0;
	end
	else
		case(i)
			
			1'b0      : if(sig) begin
								i <= i + 1'b1;
								sig_out <= 1'b1;
							end
							
			1'b1      : sig_out <= 1'b0;
			
			default   : sig_out <= 1'b0;
		
		endcase

end

endmodule
