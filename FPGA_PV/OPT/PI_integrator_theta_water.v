`include "../parameter/global_parameter.v"

module PI_integrator_theta_water(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read_x,
			 
			 x,
			 y,
			 done_sig
		   );

parameter A = 32'h3f800000;
parameter B = 32'h3f800000;
parameter const_2pi = 32'h40C90FDB;
parameter const_0 = 32'h00000000;

input clk;
input rst;
input rst_user;
input sta;
input done_read_x;//before sta 15 clk

input [`SINGLE - 1:0] x;

wire [`SINGLE - 1:0] inner_result1;
output [`SINGLE - 1:0] y;
output  done_sig;
wire done_sig_1;
wire [`SINGLE - 1:0] inner_result2;
wire [`SINGLE - 1:0] inner_result3;
wire [`SINGLE - 1:0] y1,y_1,y_2,y_3;
wire [`SINGLE - 1:0] x_reg,x_reg_delay;
wire [`SINGLE - 1:0] y_reg;
wire ena_write_y,ena_read_y,full_sig_y,empty_sig_y;
wire [3:0] usedw_y;

wire ena_write_x,full_sig_x,empty_sig_x;
wire [3:0] usedw_x;
wire done_write_y,done_read_x,ena_read_x;

reg [`SINGLE - 1:0] y_theta;
//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;

//A = delta_t/2*Ki + Kp
//B = delta_t/2*Ki - Kp
DELAY_1CLK  #(19) Delay_done_sig(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig_1)
										  );
DELAY_1CLK  #(4) Delay_done_sig1(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_write_y)
										  );
										  
DELAY_NCLK  #(32,21)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
					                 );										  

Multiplier_nodsp	Multiplier_inner_result1(
										 .aclr(rst),
										 .clk_en(`ena_math),
										 .clock(clk),
										 .dataa(A),
										 .datab(x),
										 .result(inner_result1)
										);//C11
																				
Multiplier_nodsp	Multiplier_inner_result2(
										 .aclr(rst),
										 .clk_en(`ena_math),
										 .clock(clk),
										 .dataa(B),
										 .datab(x_reg_delay),
										 .result(inner_result2)
										);//C12
	
Adder_nodsp	Adder_inner_result3(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(y_reg),
										  .result(inner_result3)
										 );//J7

Adder_nodsp	Adder_inner_result4(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result2),
										  .result(y1)
										 );		//J8								  										 

Adder_nodsp	Substract_inner_result9a(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(y1),
												.datab(const_2pi),
												.result(y_1)
											  );				//J9								  
												  
Adder_nodsp	Substract_inner_result9b(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(y1),
												.datab(const_0),
												.result(y_2)
											  );//J10

Adder_nodsp	Substract_inner_result9c(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`add),
												.clock(clk),
												.dataa(y1),
												.datab(const_2pi),
												.result(y_3)
											  );//J11
											  
always@ (posedge clk or posedge rst_user) begin
   if (rst_user==1'b1)
	   y_theta <=32'h0;
	else if((y_3[31]==1'b1)||((y_3[31]==1'b0)&&(y_2[31]==1'b1)))
	   y_theta <= y_3;			
	else if((y_3[31]==1'b0)&&(y_2[31]==1'b0)&&(y_1[31]==1'b0))
		y_theta <= y_1;
	else if((y_3[31]==1'b0)&&(y_2[31]==1'b0)&&(y_1[31]==1'b1))
		y_theta <= y_2;
end

assign y = y_theta;

DELAY_1CLK  #(8) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(done_sig_1),
										  .q(done_sig)
										 );
										 
generate_ena #(`N_PV ) generate_ena_PI_integrator  (
						.clk(clk),
						.rst(rst),
						.d(sta),
						.q(ena_write_x)
					  );	
					  
generate_ena #(`N_PV ) generate_ena_PI_integrator1  (
						.clk(clk),
						.rst(rst),
						.d(done_sig),
						.q(ena_write_y)
					  );
					  
generate_ena #(`N_PV ) generate_ena_PI_integrator2  (
						.clk(clk),
						.rst(rst),
						.d(done_write_y),
						.q(ena_read_y)
					  );
generate_ena #(`N_PV ) generate_ena_PI_integrator3  (
						.clk(clk),
						.rst(rst),
						.d(done_read_x),
						.q(ena_read_x)
					  );
FIFO	FIFO_PI_integrator (
	.clock ( clk ),
	.data ( y ),
	.rdreq ( ena_read_y ),
	.wrreq ( ena_write_y ),
	.empty ( empty_sig_y ),
	.full ( full_sig_y ),
	.q ( y_reg ),
	.usedw ( usedw_y )
	);	
	
	
FIFO	FIFO_PI_integrator1 (
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
	
