module Iph_cal(
					clk,
					rst,
					sta,
					S,
					Np_Isref_divide_Sref,
					T,
					Tref,
					Np_Isref_J,
					
					Iph,
					done_sig
				  );

parameter ena_math = 1'b1;
parameter sub = 1'b0;
parameter add = 1'b1;

parameter SINGLE = 32;

input clk;
input rst;
input sta;

input [SINGLE - 1:0] S;
input [SINGLE - 1:0] T;
input [SINGLE - 1:0] Np_Isref_divide_Sref;
input [SINGLE - 1:0] Tref;
input [SINGLE - 1:0] Np_Isref_J;

wire [SINGLE - 1:0] Iph_inner_result1;
wire [SINGLE - 1:0] Iph_inner_result2;
wire [SINGLE - 1:0] Iph_inner_result3;
output [SINGLE - 1:0] Iph;

output done_sig;

DELAY_1CLK #(19) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );
					
Multiplier_nodsp Mutiplier_Iph_inner_result1(
														   .aclr(rst),
														   .clk_en(ena_math),
														   .clock(clk),
														   .dataa(S),
														   .datab(Np_Isref_divide_Sref),
														   .result(Iph_inner_result1)
														  );

Adder_nodsp	Adder_Iph_inner_result2(
												.aclr(rst),
												.add_sub(sub),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(T),
												.datab(Tref),
												.result(Iph_inner_result2)
											  );
												
Multiplier_nodsp Mutiplier_Iph_inner_result3(
														   .aclr(rst),
														   .clk_en(ena_math),
														   .clock(clk),
														   .dataa(Iph_inner_result2),
														   .datab(Np_Isref_J),
														   .result(Iph_inner_result3)
														  );
												
Adder_nodsp	Adder_Iph_inner_result4(
												.aclr(rst),
												.add_sub(add),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(Iph_inner_result1),
												.datab(Iph_inner_result3),
												.result(Iph)
											  );
											  
endmodule
