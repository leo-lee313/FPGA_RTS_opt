`include "../parameter/global_parameter.v"

module Control_interface_output(
										  clk,
										  rst,
										  sta,
										  exchange_data_sig,
										  Sig_o,
										  Source_o,
										  
										  gate_signal_output, 
										  source_output
										 );
										
input clk;
input rst;
input sta;
input exchange_data_sig;

input Sig_o[`N_OUTPUT_SIGNAL - 1:0];
input [`SINGLE - 1:0] Source_o[`N_OUTPUT_SOURCE - 1:0];

wire [`ADDR_WIDTH_OUTPUT_SIGNAL - 1:0] addr_output_signal_p2s;
wire pulse_output_signal_p2s;
wire ena_output_signal_p2s;
wire step_output_signal_p2s;
wire ena_cal_output_signal_p2s;

wire sta_w_signal;
wire [`ADDR_WIDTH_OUTPUT_SIGNAL - 1:0] addr_output_signal_w;
wire pulse_output_signal_w;
wire ena_output_signal_w;
wire step_output_signal_w;
wire ena_cal_output_signal_w;
reg gate_signal;

wire [`ADDR_WIDTH_OUTPUT_SIGNAL - 1:0] addr_output_signal_r;
wire pulse_output_signal_r;
wire ena_output_signal_r;
wire step_output_signal_r;
wire ena_cal_output_signal_r;
output gate_signal_output;

wire [`ADDR_WIDTH_OUTPUT_SOURCE - 1:0] addr_output_source_p2s;
wire pulse_output_source_p2s;
wire ena_output_source_p2s;
wire step_output_source_p2s;
wire ena_cal_output_source_p2s;

wire sta_w_source;
wire [`ADDR_WIDTH_OUTPUT_SOURCE - 1:0] addr_output_source_w;
wire pulse_output_source_w;
wire ena_output_source_w;
wire step_output_source_w;
wire ena_cal_output_source_w;
reg [`SINGLE - 1:0] Source_s;
wire [`EXTENDED_SINGLE - 1:0] Source_s_double;

wire [`ADDR_WIDTH_OUTPUT_SOURCE - 1:0] addr_output_source_r;
wire pulse_output_source_r;
wire ena_output_source_r;
wire step_output_source_r;
wire ena_cal_output_source_r;
output [`EXTENDED_SINGLE - 1:0] source_output;

DELAY_1CLK  #(1) Delay_STA_W_SIGNAL(
											   .clk(clk),
											   .rst(rst),
											   .d(sta),
											   .q(sta_w_signal)
											  );

DELAY_1CLK  #(3) Delay_STA_W_SOURCE(
											   .clk(clk),
											   .rst(rst),
											   .d(sta),
											   .q(sta_w_source)
											  );

ADDR #(`ADDR_WIDTH_OUTPUT_SIGNAL , `N_OUTPUT_SIGNAL , `TIMES_OUTPUT_SIGNAL , `INI_ADDR_OUTPUT_SIGNAL ) ADDR_OUTPUT_SIGNAL_P2S(
																																										 .clk(clk),
																																										 .rst(rst),
																																										 .sta(sta),
																																										 .addr(addr_output_signal_p2s),
																																										 .pulse(pulse_output_signal_p2s),
																																										 .ena_mem(ena_output_signal_p2s),
																																										 .step(step_output_signal_p2s),
																																										 .ena_cal(ena_cal_output_signal_p2s)
																																										);

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		gate_signal <= 1'b0;
	end
	else if(ena_cal_output_signal_p2s) begin
		gate_signal <= Sig_o[addr_output_signal_p2s];
	end
	else begin
		gate_signal <= 1'b0;
	end
end

ADDR #(`ADDR_WIDTH_OUTPUT_SIGNAL , `N_OUTPUT_SIGNAL , `TIMES_OUTPUT_SIGNAL , `INI_ADDR_OUTPUT_SIGNAL ) ADDR_OUTPUT_SIGNAL_W(
																																									 .clk(clk),
																																									 .rst(rst),
																																									 .sta(sta_w_signal),
																																									 .addr(addr_output_signal_w),
																																									 .pulse(pulse_output_signal_w),
																																									 .ena_mem(ena_output_signal_w),
																																									 .step(step_output_signal_w),
																																									 .ena_cal(ena_cal_output_signal_w)
																																									);
																																								
ADDR #(`ADDR_WIDTH_OUTPUT_SIGNAL , `N_OUTPUT_SIGNAL , `TIMES_OUTPUT_SIGNAL , `INI_ADDR_OUTPUT_SIGNAL ) ADDR_OUTPUT_SIGNAL_R(
																																									 .clk(clk),
																																									 .rst(rst),
																																									 .sta(exchange_data_sig),
																																									 .addr(addr_output_signal_r),
																																									 .pulse(pulse_output_signal_r),
																																									 .ena_mem(ena_output_signal_r),
																																									 .step(step_output_signal_r),
																																									 .ena_cal(ena_cal_output_signal_r)
																																									);																																									

wire ena_output_signal;
assign ena_output_signal = ena_cal_output_signal_w || ena_output_signal_r;
	
Output_control_signal	Output_control_signal(
															 .aclr(rst),
															 .clock(clk),
															 .data(gate_signal),
															 .enable(ena_output_signal),
															 .rdaddress(addr_output_signal_r),
															 .rden(ena_cal_output_signal_r),
															 .wraddress(addr_output_signal_w),
															 .wren(ena_cal_output_signal_w),
															 .q(gate_signal_output)
															);
															

															
															
															
															
															
ADDR #(`ADDR_WIDTH_OUTPUT_SOURCE , `N_OUTPUT_SOURCE , `TIMES_OUTPUT_SOURCE , `INI_ADDR_OUTPUT_SOURCE ) ADDR_OUTPUT_SOURCE_P2S(
																																										 .clk(clk),
																																										 .rst(rst),
																																										 .sta(sta),
																																										 .addr(addr_output_source_p2s),
																																										 .pulse(pulse_output_source_p2s),
																																										 .ena_mem(ena_output_source_p2s),
																																										 .step(step_output_source_p2s),
																																										 .ena_cal(ena_cal_output_source_p2s)
																																										);

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		Source_s <= 1'b0;
	end
	else if(ena_cal_output_source_p2s) begin
		Source_s <= Source_o[addr_output_source_p2s];
	end
	else begin
		Source_s <= 1'b0;
	end
end

FLOAT2DOUBLE FLOAT2DOUBLE(
								  .aclr(rst),
								  .clk_en(`ena_math),
								  .clock(clk),
								  .dataa(Source_s),
								  .result(Source_s_double)
								 );

ADDR #(`ADDR_WIDTH_OUTPUT_SOURCE , `N_OUTPUT_SOURCE , `TIMES_OUTPUT_SOURCE , `INI_ADDR_OUTPUT_SOURCE ) ADDR_OUTPUT_SOURCE_W(
																																									 .clk(clk),
																																									 .rst(rst),
																																									 .sta(sta_w_source),
																																									 .addr(addr_output_source_w),
																																									 .pulse(pulse_output_source_w),
																																									 .ena_mem(ena_output_source_w),
																																									 .step(step_output_source_w),
																																									 .ena_cal(ena_cal_output_source_w)
																																									);
																																								
ADDR #(`ADDR_WIDTH_OUTPUT_SOURCE , `N_OUTPUT_SOURCE , `TIMES_OUTPUT_SOURCE , `INI_ADDR_OUTPUT_SOURCE ) ADDR_OUTPUT_SOURCE_R(
																																									 .clk(clk),
																																									 .rst(rst),
																																									 .sta(exchange_data_sig),
																																									 .addr(addr_output_source_r),
																																									 .pulse(pulse_output_source_r),
																																									 .ena_mem(ena_output_source_r),
																																									 .step(step_output_source_r),
																																									 .ena_cal(ena_cal_output_source_r)
																																									);																																									

wire ena_output_source;
assign ena_output_source = ena_cal_output_source_w || ena_output_source_r;
	
Output_source	Output_source(
								     .aclr(rst),
									  .clock(clk),
									  .data(Source_s_double),
									  .enable(ena_output_source),
									  .rdaddress(addr_output_source_r),
									  .rden(ena_cal_output_source_r),
									  .wraddress(addr_output_source_w),
									  .wren(ena_cal_output_source_w),
									  .q(source_output)
									 );

endmodule
