`include "../parameter/Global_parameter.v"

module PV(
			 clk,
			 rst,
			 sta,
			 sta_ad,
			 S,
			 T,
			 Vd,
			 
			 Iph,
			 Id,
			 sta_read_fifo,
			 done_sig_Iph,
			 done_sig_Id,
			 done_sig
			);

parameter Np_Isref_divide_Sref = 32'h3cf6fd22;
parameter Np_Isref_J = 32'h3ca08af0;
parameter Tref = 32'h43950000;

parameter Ns_n_ff3 = 32'h3dbec56d;
	
input clk;
input rst;
input sta;
input sta_ad;

input [`SINGLE - 1:0] S;
input [`SINGLE - 1:0] T;
input [`SINGLE - 1:0] Vd;

output [`SINGLE - 1:0] Iph;
output [`SINGLE - 1:0] Id;
output done_sig;
output done_sig_Id;
output done_sig_Iph;
output sta_read_fifo;

wire [`SINGLE - 1:0] Id_inner_result4;
wire [`SINGLE - 1:0] Ids;
wire done_sig_Ids;
wire done_sig_Id_exp;
wire done_sig_PV;

Iph_cal Iph_cal(
					 .clk(clk),
					 .rst(rst),
					 .sta(sta_ad),
					 .S(S),
					 .Np_Isref_divide_Sref(Np_Isref_divide_Sref),
					 .T(T),
					 .Tref(Tref),
					 .Np_Isref_J(Np_Isref_J),
					
					 .Iph(Iph),
					 .done_sig(done_sig_Iph)
				   );

Ids_cal Ids_cal(
					 .clk(clk),
					 .rst(rst),
					 .sta(sta),
					 .T(T),

					 .Ids(Ids),
					 .done_sig(done_sig_Ids)
					);
					
Id_exp Id_exp(
				  .clk(clk),
				  .rst(rst),
				  .sta(sta),
				  .T(T),
				  .Ns_n_ff3(Ns_n_ff3),
				  .Vd(Vd),

				  .Id_inner_result4(Id_inner_result4),
				  .done_sig(done_sig_Id_exp)
				 );

multiplier_control_system multiplier_Id(
													 .clk(clk),
													 .rst(rst),
													 .sta(done_sig_Id_exp),
													 .x(Ids),
													 .y(Id_inner_result4),
													 .xy(Id),
													 .done_sig(done_sig_Id)
													);
													
DELAY_1CLK #(3) DELAY_sta_read_fifo(
						.clk(clk),
						.rst(rst),
						.d(done_sig_Id_exp),
						.q(sta_read_fifo)
					  );
					  
mux_pulse mux_pulse_PV(
							  .clk(clk),
							  .rst(rst),
						 	  .sig1(done_sig_Iph),
							  .sig2(done_sig_Id),
							  .done_sig(done_sig_PV)
							 );
assign done_sig = done_sig_PV;
endmodule
