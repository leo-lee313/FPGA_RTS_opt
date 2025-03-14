`include "../parameter/global_parameter.v"

module Delay_control_system_water(
										clk,
										rst,
										rst_user,
										sta,
										x,
										
										y
										//done_sig
									  );
			  
input clk;
input rst;
input rst_user;
input sta;

input [`SINGLE - 1:0] x;

output [`SINGLE - 1:0] y;
reg [`SINGLE - 1:0] y;

//output done_sig;
wire [3:0] usedw_x;
wire empty_sig_x,full_sig_x;
reg [11:0] ini_addr;
wire [`SINGLE - 1:0] y_delay;
wire [11:0] addr;
wire pulse;
wire ena;
wire step;
wire ena_cal;
wire ena_cal1,ena_before_write,ena_cal2;
wire ena_donesig,before_donesig,ena_write,ena_read,before_donesig1;
/*
DELAY_1CLK  #(4) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );
*/
DELAY_1CLK  #(3) Delay_DONE_SIG1(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(before_donesig)
										 );										 
										 
generate_ena #(`N_WindTurbine ) generate_ena1  (
						.clk(clk),
						.rst(rst),
						.d(before_donesig),
						.q(ena_donesig)
					  );										 

DELAY_1CLK  #(2) Delay_DONE_SIG2(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(before_donesig1)
										 );										 
										 
generate_ena #(`N_WindTurbine ) generate_ena2  (
						.clk(clk),
						.rst(rst),
						.d(before_donesig1),
						.q(ena_read)
					  );


					  
reg sta_t;									 
ADDR_MATRIX #( 12,1'b1) ADDR_Delay(
													 .clk(clk),
													 .rst(rst),
													 .sta(sta_t),
													 .ini_addr(ini_addr),
													 .ADDR(`N_WindTurbine),
													 .addr(addr),
													 .pulse(pulse),
													 .ena_mem(ena),
													 .step(step),
													 .ena_cal(ena_cal)
													);

DELAY_1CLK  #(1) Delay_DONE_SIG3(
										  .clk(clk),
										  .rst(rst),
										  .d(ena_cal),
										  .q(ena_cal1)
										 );
										 
DELAY_1CLK  #(67) Delay_DONE_SIG4(
										  .clk(clk),
										  .rst(rst),
										  .d(ena_donesig),
										  .q(ena_write)
										 );

DELAY_1CLK  #(66) Delay_DONE_SIG5(
										  .clk(clk),
										  .rst(rst),
										  .d(ena_donesig),
										  .q(ena_before_write)
										 );

DELAY_1CLK  #(67) Delay_DONE_SIG6(
										  .clk(clk),
										  .rst(rst),
										  .d(ena_cal),
										  .q(ena_cal2)
										 );
										 
reg [11:0] Delay_counter;
always @(posedge clk or posedge rst_user) begin
	if(rst_user) begin
		Delay_counter <= 1'b0;
	end
	else if(sta) begin
		if(Delay_counter == `Delay_para) begin
			Delay_counter <= 1'b1;
		end
		else begin
			Delay_counter <= Delay_counter + 1'b1;
		end
	end
end

always @(posedge clk or posedge rst_user) begin
	if(rst_user) begin
		sta_t <= 1'b0;
	end
	else if(sta) begin
		if(Delay_counter == `Delay_para - 1) begin
			sta_t <= 1'b1;
		end
	end
	else begin
		sta_t <= 1'b0;
	end
end

always @(posedge clk or posedge rst_user) begin
	if(rst_user) begin
		ini_addr <= 1'b0;
	end
	else if(pulse) begin
		if(ini_addr == `Delay_depth_water) begin
			ini_addr <= 1'b0;
		end
		else begin
			ini_addr <= addr + `N_WindTurbine;
		end
	end
end

wire [`SINGLE - 1:0] y_t,y_t1,y_t_delay;
reg [`SINGLE - 1:0] y_input;
Delay_FIFO	Delay_FIFO(
								.aclr(rst_user),
								.clock(clk),
								.data(x),
								.enable(ena),
								.rdaddress(addr),
								.rden(ena_cal),
								.wraddress(addr),
								.wren(ena_cal),
								.q(y_t)
								);

DELAY_NCLK  #(32,66)  DELAY_NCLK1(
						               .clk(clk),
											.rst(rst),
						               .d(y_t),
						               .q(y_t_delay)
					                 );
										  
DELAY_NCLK  #(32,65)  DELAY_NCLK122(
						               .clk(clk),
											.rst(rst),
						               .d(y),
						               .q(y_delay)
					                 );

								
FIFO	FIFO1 (
	.clock ( clk ),
	.data ( y_input ),
	.rdreq ( ena_read ),
	.wrreq ( ena_write ),
	.empty ( empty_sig_x ),
	.full ( full_sig_x ),
	.q ( y_t1 ),
	.usedw ( usedw_x )
	);

	 	

always @(posedge clk or posedge rst_user) begin
   if(rst_user) begin
		y_input <= 1'b0;
	end
	else if(ena_cal2&&ena_before_write) begin
		y_input <= y_t_delay;
	end
	else if((ena_cal2!=1)&&(ena_before_write==1)) begin
		y_input <= y_delay;
	end
	
end



	
always @(posedge clk or posedge rst_user) begin
   if(rst_user) begin
		y <= 1'b0;
	end
	else if(ena_cal1&&ena_donesig) begin
		y <= y_t;
	end
	else if((ena_cal1!=1)&&(ena_donesig==1)) begin
		y <= y_t1;
	end
	
end
					  
					  								

endmodule





