`include "../parameter/global_parameter.v"

module PI_integrator64_water(
			 clk,
			 rst,
			 rst_user,
			 sta,
			 done_read_x,
			 control_valuation_sig,
			 x,			 
			 y,
			 done_sig
		   );
			
parameter A = 64'h3FFFFFFEF39085F5;
parameter B = 64'h3FF0000000000000;
parameter upper_limit = 64'h3FF0000000000000;
parameter down_limit = 64'h3FF0000000000000;

input clk;
input rst;
input rst_user;
input sta;
input done_read_x;//before sta 10 clk
input control_valuation_sig;
input [`EXTENDED_SINGLE - 1:0] x;
output [`EXTENDED_SINGLE - 1:0] y;
output done_sig;
wire done_sig_1;



wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] y1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;
wire [`EXTENDED_SINGLE - 1:0] x_reg;
wire [`EXTENDED_SINGLE - 1:0] y_reg;

wire [`EXTENDED_SINGLE - 1:0] x_reg_delay;

wire ena_write_y,ena_read_y,full_sig_y,empty_sig_y;
wire [5:0] usedw_y;

wire ena_write_x,full_sig_x,empty_sig_x;
wire [5:0] usedw_x;
wire done_write_y,done_read_x;

//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;
//transfer function=Kp+Ki/s;&& Ki=1/积分时间常数
//A = (delta_t/2)*Ki + Kp
//B = (delta_t/2)*Ki - Kp
DELAY_1CLK  #(19) Delay_DONE_SIG1(
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
										  
DELAY_NCLK  #(64,16)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(x_reg),
						               .q(x_reg_delay)
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
	
										  
ADD_SUB_64	Adder_inner_result3(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(y_reg),
										  .result(inner_result3)
										 );
ADD_SUB_64	Adder_inner_result4(
										  .aclr(rst),
										  .add_sub(`add),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result2),
										  .result(y1)
										 );														


limit_control_system64_water #(upper_limit , down_limit) limit_output_2(
									 .clk(clk),
									 .rst(rst),
									 .sta(done_sig_1),
									 .x(y1),
									 .y(y),
									 .done_sig(done_sig)
									 ); 
										 
generate_ena #(`N_WindTurbine ) generate_ena_PI_integrator  (
						.clk(clk),
						.rst(rst),
						.d(sta),
						.q(ena_write_x)
					  );	
					  
generate_ena #(`N_WindTurbine ) generate_ena_PI_integrator1  (
						.clk(clk),
						.rst(rst),
						.d(done_sig),
						.q(ena_write_y)
					  );
					  
generate_ena #(`N_WindTurbine ) generate_ena_PI_integrator2  (
						.clk(clk),
						.rst(rst),
						.d(done_write_y),
						.q(ena_read_y)
					  );
generate_ena #(`N_WindTurbine ) generate_ena_PI_integrator3  (
						.clk(clk),
						.rst(rst),
						.d(done_read_x),
						.q(ena_read_x)
					  );
FIFO64	FIFO_PI_integrator (
	.clock ( clk ),
	.data ( y ),
	.rdreq ( ena_read_y ),
	.wrreq ( ena_write_y ),
	.empty ( empty_sig_y ),
	.full ( full_sig_y ),
	.q ( y_reg ),
	.usedw ( usedw_y )
	);	


	
FIFO64	FIFO_PI_integrator1 (
	.clock ( clk ),
	.data ( x ),
	.rdreq ( ena_read_x ),
	.wrreq ( ena_write_x ),
	.empty ( empty_sig_x ),
	.full ( full_sig_x ),
	.q ( x_reg ),
	.usedw ( usedw_x )
	);										 

/*	
System_partition_64 Storage_x(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(x),
									.cout(x_reg)
								  );
														 
System_partition_64 Storage_y(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(y),
									.cout(y_reg)
								  );
*/	
endmodule
	
