`include "../parameter/global_parameter.v"


module ComparePm(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 x,
			 					 
			 y,
			 done_sig
		   );

parameter A = 32'h00000000;


input clk;
input rst;
input rst_user;
input sta;
input [31:0] x;
output done_sig;
output [31:0] y;
reg [31:0] y_tem;

wire output_1;
wire output_2;



DELAY_1CLK  #(5) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );


Comparator  FloatComparator_32_inst(
						.clk( clk ),
						.rst( rst ),
						//.sta,
						.input_1(x),
						.input_2(A),
						.output_1(output_1),
						.output_2(output_2)
						//.done_sig
					  );
			  										 
	
always@(posedge clk or posedge rst)
begin  
   if(rst) begin
	    y_tem<=32'h00000000;
      end 
	else if(output_2) begin
	    y_tem<=A;
      end 
   else if(output_1) begin
		  y_tem<=x;
      end 
end
assign y=y_tem;	
	
endmodule
