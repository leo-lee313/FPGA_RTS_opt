`include "../parameter/global_parameter.v"

module ADD_SUB_64_MODULE(

			 sta,
			 rst_control,
			 add_sub,
			 clk,
			 dataa,			 			 			 
			 datab,
			 
			 result,
			 done_sig
		   );
			
input clk;
input rst_control;
input add_sub;
input sta;
input [`EXTENDED_SINGLE - 1:0] dataa;
input [`EXTENDED_SINGLE - 1:0] datab;
output [`EXTENDED_SINGLE - 1:0] result;
output done_sig;
DELAY_1CLK  #(7) Deladatab_DONE_SIG1(
										  	.clk(clk),
											.rst(rst_control),
											.d(sta),
											.q(done_sig)
										  );

ADD_SUB_64	ADD_SUB1(
	       .aclr(rst_control),
			 .add_sub(add_sub),
			 .clk_en(`ena_math),
			 .clock(clk),
			 .dataa(dataa),
			 .datab(datab),
			 .result(result)
										 );

endmodule										 
										  
										  