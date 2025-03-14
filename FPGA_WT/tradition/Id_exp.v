module Id_exp(
					clk,
					rst,
					sta,
					T,
					Ns_n_ff3,
					Vd,

					Id_inner_result4,
					done_sig
				  );
				  
parameter ena_math = 1'b1;
parameter sub = 1'b0;
parameter add = 1'b1;

parameter SINGLE = 32;

parameter const_1 = 32'h3f800000;
				  
input clk;
input rst;
input sta;

input [SINGLE - 1:0] T;
input [SINGLE - 1:0] Ns_n_ff3;
input [SINGLE - 1:0] Vd;

wire [SINGLE - 1:0] Id_inner_result1;
wire [SINGLE - 1:0] Id_inner_result2;
wire [SINGLE - 1:0] Id_inner_result3;
output [SINGLE - 1:0] Id_inner_result4;

output done_sig;

DELAY_1CLK #(30) Delay_DONE_SIG(
										  .clk(clk),
										  .rst(rst),
										  .d(sta),
										  .q(done_sig)
										 );

Multiplier_nodsp Mutiplier_Id_inner_result1(
														   .aclr(rst),
														   .clk_en(ena_math),
														   .clock(clk),
														   .dataa(T),
														   .datab(Ns_n_ff3),
														   .result(Id_inner_result1)
														  );

Divide_nodsp	Divide_nodsp(
									 .aclr(rst),
									 .clk_en(ena_math),
									 .clock(clk),
									 .dataa(Vd),
									 .datab(Id_inner_result1),
									 .result(Id_inner_result2)
									);

Exp_nodsp	Exp_nodsp(
							 .aclr(rst),
							 .clk_en(ena_math),
							 .clock(clk),
							 .data(Id_inner_result2),
							 .result(Id_inner_result3)
							);

Adder_nodsp	Adder_Id_inner_result4(
												.aclr(rst),
												.add_sub(sub),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(Id_inner_result3),
												.datab(const_1),
												.result(Id_inner_result4)
											  );
				  
endmodule

