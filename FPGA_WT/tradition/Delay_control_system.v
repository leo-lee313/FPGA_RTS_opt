`include "../parameter/global_parameter.v"

module Delay_control_system(
										clk,
										rst,
										rst_user,
										sta,
										x,
										
										y,
										done_sig
									  );
			  
input clk;
input rst;
input rst_user;
input sta;

input [`SINGLE - 1:0] x;

output [`SINGLE - 1:0] y;
reg [`SINGLE - 1:0] y;

output done_sig;

reg [11:0] ini_addr;

wire [11:0] addr;
wire pulse;
wire ena;
wire step;
wire ena_cal;

DELAY_1CLK  #(5) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );

reg sta_t;									 
ADDR_MATRIX #( 12 , 1 , 1'b1) ADDR_Delay(
													 .clk(clk),
													 .rst(rst),
													 .sta(sta_t),
													 .ini_addr(ini_addr),
													 .addr(addr),
													 .pulse(pulse),
													 .ena_mem(ena),
													 .step(step),
													 .ena_cal(ena_cal)
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
		if(ini_addr == `Delay_depth - 1) begin
			ini_addr <= 1'b0;
		end
		else begin
			ini_addr <= addr + 1'b1;
		end
	end
end

wire [`SINGLE - 1:0] y_t;

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
								
always @(posedge clk or posedge rst_user) begin
	if(rst_user) begin
		y <= 1'b0;
	end
	else begin
		y <= y_t;
	end
end

endmodule
