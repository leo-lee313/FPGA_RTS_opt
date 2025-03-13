module Ids_cal(
					clk,
					rst,
					sta,
					T,

					Ids,
					done_sig
				  );

parameter SINGLE = 32;
parameter INTEGER = 10;
parameter ADDR_Ids = 7;
parameter ena_math = 1'b1;
parameter sub = 1'b0;
parameter add = 1'b1;

input clk;
input rst;
input sta;

input [SINGLE - 1:0] T;
wire [INTEGER - 1:0] address;
wire [ADDR_Ids - 1:0] address_1;
wire [ADDR_Ids - 1:0] address_2;

wire [SINGLE - 1:0] Ids_1;
wire [SINGLE - 1:0] Ids_2;
wire [SINGLE - 1:0] Ids_delta;

wire [SINGLE - 1:0] address_float;
wire [SINGLE - 1:0] delta_T;
wire [SINGLE - 1:0] Ids_inner_result1;
output [SINGLE - 1:0] Ids;

output done_sig;

DELAY_1CLK #(31) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );

FLOAT2INTEGER_PV	FLOAT2INTEGER_PV(
											  .aclr(rst),
											  .clk_en(ena_math),
											  .clock(clk),
											  .dataa(T),
											  .result(address)
											 );

assign address_1 = address - 9'd273;
assign address_2 = address - 9'd272;

Ids_mem	Ids_mem1(
						.aclr(rst),
						.address(address_1),
						.clken(ena_math),
						.clock(clk),
						.q(Ids_1)
					  );
						
Ids_mem	Ids_mem2(
						.aclr(rst),
						.address(address_2),
						.clken(ena_math),
						.clock(clk),
						.q(Ids_2)
					  );

Adder_nodsp	Adder_Ids_inner_result1(
												.aclr(rst),
												.add_sub(sub),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(Ids_2),
												.datab(Ids_1),
												.result(Ids_delta)
											  );
 
INTEGER2FLOAT_PV	INTEGER2FLOAT_PV(
												.aclr(rst),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(address),
												.result(address_float)
											  );

Adder_nodsp	Adder_Ids_inner_result2(
												.aclr(rst),
												.add_sub(sub),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(T),
												.datab(address_float),
												.result(delta_T)
											  );
											  
Multiplier_nodsp Mutiplier_Ids_inner_result3(
														   .aclr(rst),
														   .clk_en(ena_math),
														   .clock(clk),
														   .dataa(Ids_delta),
														   .datab(delta_T),
														   .result(Ids_inner_result1)
														  );
														  
Adder_nodsp	Adder_Ids_inner_result4(
												.aclr(rst),
												.add_sub(add),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(Ids_1),
												.datab(Ids_inner_result1),
												.result(Ids)
											  );
endmodule
