`include "../parameter/global_parameter.v"

module ChooserSwitch64(			 		 		 
			 rst_user,
			 clk,
			 beta_flag,
			 sta,
			 rst,
			 datain1,
			 datain2,
			 			            			 
			 dataout,
	       done_sig_ChooserS		 
			);
		
input rst_user;
input clk;
input beta_flag;
input sta;
input rst;
input [63:0] datain1;
input [63:0] datain2;

output [63:0] dataout;
output done_sig_ChooserS;
reg [63:0] dataout11;


DELAY_1CLK #(1) Delay_DONE_SIG111(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig_ChooserS)
										 );

always@(posedge rst_user or posedge clk)
begin
    if(rst_user==1'b1)
	  begin
	    dataout11<=64'h0000000000000000;
		 
     end
	 else if((rst_user!=1'b1)&&(beta_flag==1'b0))
	   begin
		 dataout11<=datain1;
	   end
	 else if((rst_user!=1'b1)&&(beta_flag==1'b1))
	   begin
		 dataout11<=datain2;
	   end
    
end
assign dataout=dataout11;

endmodule
