`include "../parameter/global_parameter.v"

module PID_initial_threshold64_water(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read,
			 control_valuation_sig,
			 x,
			
			 y,
			 done_sig
		   );
			
parameter A = 64'h3FF0000000000000;
parameter B = 64'h3FF0000000000000;
parameter C = 64'h3FF0000000000000;
parameter G = 64'h3FF0000000000000;
parameter upper_limit 	= 64'h3FF0000000000000;
parameter down_limit 	= 64'h3FF0000000000000;

input clk;
input rst;
input rst_user;
input sta,done_read;//done_read before sta 10 clk
input control_valuation_sig;
input [`EXTENDED_SINGLE - 1:0] x;

output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;
reg [`SINGLE - 1:0] counter;
reg [`SINGLE - 1:0] counter1;
reg [`SINGLE - 1:0] counter2,counter3;	

wire done_sig1,ena,done_read;

wire ena_write_y,ena_read_y,full_sig_y,empty_sig_y;
wire [5:0] usedw_y;

wire ena_write_x,full_sig_x,empty_sig_x;
wire [5:0] usedw_x;

wire [`EXTENDED_SINGLE - 1:0] initial_value,initial_value1,initial_value_delay;
wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;
wire [`EXTENDED_SINGLE - 1:0] inner_result4;

wire [`EXTENDED_SINGLE - 1:0] x_reg,x_reg_delay;
wire [`EXTENDED_SINGLE - 1:0] y_reg,y_reg_delay;
wire [`EXTENDED_SINGLE - 1:0] y1;
wire [`EXTENDED_SINGLE - 1:0] y2;
reg [`EXTENDED_SINGLE - 1:0] y_temp;

wire done_sig_pi,ena_read_x;
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
											.q(done_sig_pi)
										  );


DELAY_NCLK  #(64,9)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
					                 );
										 
DELAY_NCLK  #(64,16)  DELAY_NCLK10(
						               .clk(clk),
											.rst(rst),
						               .d(y_reg),
						               .q(y_reg_delay)
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
				
multiplier_64	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg_delay),
														 .result(inner_result2)
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
										  .result(y2)
										 );
										 
limit_control_system64_water  #(upper_limit,down_limit) threshold14(
					  .clk(clk),
					  .rst(rst),
					  .sta(done_sig_pi),
					  .x(y2),
					  .y(y1),				  
					  .done_sig(done_sig1)
									 ); 
									 
limit_control_system64_water  #(upper_limit,down_limit) threshold15(
					  .clk(clk),
					  .rst(rst),
					  //.sta(done_sig_pi),
					  .x(initial_value),
					  .y(initial_value1)				  
					  //.done_sig(done_sig1)
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
						.d(initial_value1),
						.q(initial_value_delay)
					  );	
					  
always@(posedge clk)
begin
    if(rst_user == 1)
	  begin
	    counter<=32'd0;
		 counter1<=32'd0;
		 counter2<=32'd0;
		 counter3<=32'd0;
     end
//if((counter==32'd0)&&(control_valuation_sig==1'b1))
	 if((counter==32'd0)&&(sta==1'b1))
	   begin
			 counter1<=32'd1;
          counter2<=32'd1;			 
      end
	if((counter1==32'd1)&&(counter2==32'd1)&&(ena==1'b1))
	   begin
		    y_temp<=initial_value_delay;
		    //counter1<=32'd0;
          counter<=counter+1;	       
      end
   if((counter3==32'd1)&&(counter2==32'd1)&& (ena==1'b1))
	   begin
		    y_temp<=y1;
			 counter<=`N_WindTurbine;
      end	
	if((counter==`N_WindTurbine))
	   begin
		    counter3<=32'd1;
			 counter1<=32'd0;
      end		
end

assign y=y_temp;


DELAY_1CLK  #(1) Delay_DONE_SIG2(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig1),
											.q(done_sig)
										  );
										  
										  
generate_ena #(`N_WindTurbine ) generate_ena_PID_Initial64  (
						.clk(clk),
						.rst(rst),
						.d(sta),
						.q(ena_write_x)
					  );	
					  
generate_ena #(`N_WindTurbine ) generate_ena_PID_Initial641  (
						.clk(clk),
						.rst(rst),
						.d(done_sig),
						.q(ena_write_y)
					  );
					  
generate_ena #(`N_WindTurbine ) generate_ena_PID_Initial642  (
						.clk(clk),
						.rst(rst),
						.d(done_read),
						.q(ena_read_y)
					  );
generate_ena #(`N_WindTurbine ) generate_ena_PID_Initial643  (
						.clk(clk),
						.rst(rst),
						.d(done_read),
						.q(ena_read_x)
					  );
					  
FIFO64	FIFO_PID_Initial64 (
	.clock ( clk ),
	.data ( y ),
	.rdreq ( ena_read_y ),
	.wrreq ( ena_write_y ),
	.empty ( empty_sig_y ),
	.full ( full_sig_y ),
	.q ( y_reg ),
	.usedw ( usedw_y )
	);	


	
FIFO64	FIFO_PID_Initial64_1 (
	.clock ( clk ),
	.data ( x ),
	.rdreq ( ena_read_x ),
	.wrreq ( ena_write_x ),
	.empty ( empty_sig_x ),
	.full ( full_sig_x ),
	.q ( x_reg ),
	.usedw ( usedw_x )
	);
	


endmodule
