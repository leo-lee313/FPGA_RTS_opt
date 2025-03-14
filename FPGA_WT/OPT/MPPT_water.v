`include "../parameter/global_parameter.v"

module MPPT_water(			 		 		 
			 sta_user,
			 sta_control,
			 rst_control,
			 clk_sim,
			 wm, 
          			 
			 Pref,
			 done_finish_Pref	 
			);
		
input sta_user;
input sta_control;
input rst_control;
input clk_sim;
input [`SINGLE - 1:0] wm;
output [`SINGLE - 1:0] Pref;
output wire done_finish_Pref;
//const1 is 1.278000e5
parameter const1 = 32'h47F99C00;
//const2 is 1.5e6
parameter const2 = 32'h49B71B00;

wire [`SINGLE - 1:0] inner_product1;
wire [`SINGLE - 1:0] inner_product2;
wire [`SINGLE - 1:0] inner_product3;

DELAY_1CLK #(16) Delay_DONE_SIG111(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(sta_control),
										  .q(done_finish_Pref)
										 );

Multiplier_nodsp_dsp	multiplier_control_system0(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(wm),
									  .datab(wm),
									  .result(inner_product1)
									 );
									 
Multiplier_nodsp_dsp	multiplier_control_system1(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(const1),
									  .datab(wm),
									  .result(inner_product2)
									 );
									 
Multiplier_nodsp_dsp	multiplier_control_system2(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(inner_product1),
									  .datab(inner_product2),
									  .result(inner_product3)
									 );
										 									  
Divide_nodsp	Divider(
							  .aclr(rst_control),
							  .clk_en(`ena_math),
							  .clock(clk_sim),
							  .dataa(inner_product3),
							  .datab(const2),
							  .result(Pref)								 
							 );
							 
									  										 
/*																						  
Float_compare_nodsp	FloatComparator_32_2(
											  .clock(clk_sim),
											  .dataa(Pref),
											  .datab(constone),
											  .agb(agb_sig1),
											  .alb(alb_sig1)
											 );

					  
always @ ( posedge clk_sim or posedge rst_control ) begin	
   if(rst_control)begin
		beta_flag1 <= 1'b0;
		
		end
   else if( agb_sig1==1'b1 )begin
		beta_flag1 <= 1'b1;		
		end
	else begin
		beta_flag1 <= 1'b0;		
		end
end

assign beta_flag = beta_flag1;

DELAY_1CLK #(2) Delay_DONE_SIG2(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_finish_Pref),
										  .q(done_sig_MPPT)
										 );
*/
endmodule
