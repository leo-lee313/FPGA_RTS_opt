`include "../parameter/global_parameter.v"

module PID_Initial(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 control_valuation_sig,
			 x,
			
			 y,
			 done_sig
		   );



						
parameter A = 32'h3f800000;
parameter B = 32'h3f800000;
parameter C = 32'h3f800000;
parameter G = 32'h3f800000;

input clk;
input rst;
input rst_user;
input sta;
input control_valuation_sig;
input [`SINGLE - 1:0] x;

output [`SINGLE - 1:0] y;
output done_sig;
reg [`SINGLE - 1:0] counter;
reg [`SINGLE - 1:0] counter1;
reg [`SINGLE - 1:0] counter2;
wire done_sig1;
wire [`SINGLE - 1:0] initial_value;
wire [`SINGLE - 1:0] inner_result1;
wire [`SINGLE - 1:0] inner_result2;
wire [`SINGLE - 1:0] inner_result3;
wire [`SINGLE - 1:0] inner_result4;

wire [`SINGLE - 1:0] x_reg;
wire [`SINGLE - 1:0] y_reg;
wire [`SINGLE - 1:0] y1;
reg [`SINGLE - 1:0] y_temp;
//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;
//transfer function=(N0+N1*S)/(D0+D1*S)
//A = (N1+(N0/2)*delta_t)/(D1+(D0/2)*delta_t)
//B = (-N1+(N0/2)*delta_t)/(D1+(D0/2)*delta_t)
//C = (D1-(D0/2)*delta_t)/(D1+(D0/2)*delta_t)
DELAY_1CLK  #(19) Delay_DONE_SIG1(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig1)
										  );
										  
DELAY_1CLK  #(21) Delay_DONE_SIG2(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );										  
Multiplier_nodsp	Multiplier_inner_result0(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(G),
														 .datab(x),
														 .result(initial_value)
														);											  
Multiplier_nodsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);	
				
Multiplier_nodsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg),
														 .result(inner_result2)
														);
Multiplier_nodsp	Multiplier_inner_result3(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(C),
														 .datab(y_reg),
														 .result(inner_result4)
														);
										 
Adder_nodsp	Adder_inner_result3(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),										  
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(inner_result2),
										  .result(inner_result3)
										 );
									 
																			 
			 
Adder_nodsp	Adder_inner_result4(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),										  										
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result4),
										  .result(y1)
										 );
										 
	
									 
always@(posedge clk)
begin
    if(rst_user == 1)
	  begin
	    counter<=32'd0;
		 counter1<=32'd0;
		 counter2<=32'd0;
     end
	 if((counter==32'd0)&&(control_valuation_sig==1'b1))
	   begin
			 counter1<=32'd1;
          counter2<=32'd1;			 
      end
	if((counter1==32'd1)&&(counter2==32'd1)&&(done_sig1==1'b1))
	   begin
		    y_temp<=initial_value;
		    counter1<=32'd0;
          counter<=32'd1;	       
      end
   if((counter1!=32'd1)&&(counter2==32'd1)&& (done_sig1==1'b1))
	   begin
		    y_temp<=y1;
      end		
end

assign y=y_temp;

System_partition Storage_x(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(x),
									.cout(x_reg)
								  );
								  
														 
System_partition Storage_y(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(y),
									.cout(y_reg)
								  );
	

endmodule

