`include "../parameter/Global_parameter.v"

module Control_interface_input(
										 clk,
										 rst,
										 sta,
										 exchange_data_sig,
										 V_METERVI,

										 V_s,
										 done_sig
										);
								
input clk;
input rst;
input sta;
input exchange_data_sig;
input [`SINGLE - 1:0] V_METERVI;

wire [`ADDR_WIDTH_INPUT_V - 1:0] addr_input_v_r;
wire pulse_input_v_r;
wire ena_input_v_r;
wire step_input_v_r;
wire ena_cal_input_v_r;

wire [`SINGLE - 1:0] V;
wire [`ADDR_WIDTH_INPUT_V - 1:0] addr_input_v_r_d;
wire ena_cal_input_v_r_d;

output [`SINGLE - 1:0] V_s[`N_INPUT_V - 1:0];
reg [`SINGLE - 1:0] V_s[`N_INPUT_V - 1:0];
output done_sig;

wire [`ADDR_WIDTH_INPUT_V - 1:0] addr_input_v_w;
wire pulse_input_v_w;
wire ena_input_v_w;
wire step_input_v_w;
wire ena_cal_input_v_w;

wire exchange_data_sig_d;
DELAY_1CLK #(2) Delay_EXCHANGE_DATA_SIG_D(
													   .clk(clk),
													   .rst(rst),
													   .d(exchange_data_sig),
													   .q(exchange_data_sig_d)
													  );

ADDR #(`ADDR_WIDTH_INPUT_V , `N_INPUT_V , `TIMES_INPUT_V , `INI_ADDR_INPUT_V ) ADDR_INPUT_V_r(
																														    .clk(clk),
																														    .rst(rst),
																														    .sta(sta),
																														    .addr(addr_input_v_r),
																														    .pulse(pulse_input_v_r),
																														    .ena_mem(ena_input_v_r),
																														    .step(step_input_v_r),
																														    .ena_cal(ena_cal_input_v_r)
																														   );
																														 
ADDR #(`ADDR_WIDTH_INPUT_V , `N_INPUT_V , `TIMES_INPUT_V , `INI_ADDR_INPUT_V ) ADDR_INPUT_V_w(
																														    .clk(clk),
																														    .rst(rst),
																														    .sta(exchange_data_sig_d),
																														    .addr(addr_input_v_w),
																														    .pulse(pulse_input_v_w),
																														    .ena_mem(ena_input_v_w),
																														    .step(step_input_v_w),
																														    .ena_cal(ena_cal_input_v_w)
																														   );
wire ena_input_v_rw = ena_input_v_r || ena_cal_input_v_w;
												
Input_V	Input_V(
					  .aclr(rst),
					  .clock(clk),
					  .data(V_METERVI),
					  .enable(ena_input_v_rw),
					  .rdaddress(addr_input_v_r),
					  .rden(ena_cal_input_v_r),
					  .wraddress(addr_input_v_w),
					  .wren(ena_cal_input_v_w),
					  .q(V)
					 );
					 
DELAY_NCLK #( 8 , 2 ) Delay_ADDR_INPUT_V_D(
														 .clk(clk),
														 .rst(rst),
														 .d(addr_input_v_r),
														 .q(addr_input_v_r_d)
														);
											 
DELAY_1CLK #(2) Delay_ENA_CAL_INPUT_V_D(
													  .clk(clk),
													  .rst(rst),
													  .d(ena_cal_input_v_r),
													  .q(ena_cal_input_v_r_d)
													 );
													 
DELAY_1CLK #(2) Delay_PULSE_INPUT_V_D(
													.clk(clk),
													.rst(rst),
													.d(pulse_input_v_r),
													.q(done_sig)
												  );	
											 
always@ (posedge clk) begin
	if(ena_cal_input_v_r_d) begin
		V_s[addr_input_v_r_d] <= V;
	end
end

endmodule
