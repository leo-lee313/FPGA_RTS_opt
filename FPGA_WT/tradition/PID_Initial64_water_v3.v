`include "../parameter/global_parameter.v"

module PID_Initial64_water_v3(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read,
			 x,
			
			 y,
			 done_sig
		   );



						
parameter A = 64'h3FF0000000000000;
parameter B = 64'h3FF0000000000000;
parameter C = 64'h3FF0000000000000;
parameter G = 64'h3FF0000000000000;
parameter idle = 2'd0;
parameter middle = 2'd1;
parameter start = 2'd2;	
input clk;
input rst;
input rst_user;
input sta;
input done_read;//before sta 15 clk
input [`EXTENDED_SINGLE - 1:0] x;

output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;
reg [`SINGLE - 1:0] counter;
reg [1:0] state;

wire done_sig1,ena,done_read;
wire [`EXTENDED_SINGLE - 1:0] initial_value,initial_value_delay;
wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;
wire [`EXTENDED_SINGLE - 1:0] inner_result4;
wire [`EXTENDED_SINGLE - 1:0] x_reg,x_reg_delay;
wire [`EXTENDED_SINGLE - 1:0] y_reg,y_reg_delay;
wire [`EXTENDED_SINGLE - 1:0] y1;
reg [`EXTENDED_SINGLE - 1:0] y_temp;
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
										  
DELAY_1CLK  #(20) Delay_DONE_SIG2(
										  	.clk(clk),
											.rst(rst),
											.d(sta),
											.q(done_sig)
										  );
										  
						
										  
multiplier_64	Multiplier_inner_result0(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(G),
														 .datab(x),
														 .result(initial_value)
														);											  
multiplier_64	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);	
DELAY_NCLK  #(64,13)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
					                 );	
										  
multiplier_64	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg_delay),
														 .result(inner_result2)
														);
														
DELAY_NCLK  #(64,20)  DELAY_NCLK101(
						               .clk(clk),
											.rst(rst),
						               .d(y_reg),
						               .q(y_reg_delay)
					                 );														
														
multiplier_64	Multiplier_inner_result3(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(C),
														 .datab(y_reg_delay),
														 .result(inner_result4)
														);
	

ADD_SUB_64	Adder_inner_result3(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(inner_result2),
										  .result(inner_result3)
										 );
									 
																			 
			 
ADD_SUB_64	Adder_inner_result4(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),										
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result4),
										  .result(y1)
										 );
										 
generate_ena #(`N_WindTurbine ) generate_ena_PID_Initial640  (
						.clk(clk),
						.rst(rst),
						.d(done_sig1),
						.q(ena)
					  );		

DELAY_NCLK  #(`EXTENDED_SINGLE , 14 ) delay111(
						.clk(clk),
						.rst(rst),
						.d(initial_value),
						.q(initial_value_delay)
					  );
				  
					  
					  
always@(posedge clk or posedge rst_user)
   if(rst_user)
	  begin
      state <= idle;
		counter<=32'd0;
	  end
	else
	  case(state)
	     idle:
          begin
			   if(ena == 1'b1)
				   begin
				     y_temp <= initial_value_delay ;
				     state <= middle;
				   end
			   else
				   begin
				     state <= idle;
				   end
		    end
		  middle:
		    begin
			   counter<=counter+1;
				if(counter>=32'd30)
				  begin
				     state <= start;
				     counter<=32'd0;
				  end
			 end  
        start:
		    begin
			   if(ena == 1'b1)
				   begin
				     y_temp <= y1 ;
				     state <= start;
				   end
			   else
				   begin
				      state <= start;
				   end
		    end

	  endcase
	

assign y=y_temp;

	
System_FIFO_64 System_FIFO_1(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read),
								.before_enawrite(sta),
								.cin( x ),
								.cout( x_reg )
							  );
							  
System_FIFO_64 System_FIFO_2(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read),
								.before_enawrite(done_sig),
								.cin( y ),
								.cout( y_reg )
							  );

	
endmodule
