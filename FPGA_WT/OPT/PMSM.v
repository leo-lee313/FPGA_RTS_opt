`include "../parameter/global_parameter.v"

module PMSM(
			 clk_sim,
			 rst_control,
			 sta_control,
			 rst_user,
			 sta_user,
			 control_valuation_sig,	
	       Tm,
			 Va,
			 Vb,
			 Vc,
			 wm_starter, 
			 
			 wm,
			 wm_temp,
			 theta,
			 Te,
			 Ia,
			 Ib,			
			 Id_temp,
			 Iq_temp,
			 done_sig_finish_wm_double,
          done_sig_finish_wm,
			 done_sig_finish_Idtemp,
			 done_sig_PMSM          		 
			);


parameter Ld = 64'h3F46872B020C49BA;
parameter Lq = 64'h3F46872B020C49BA;
parameter Flux = 64'h3FE116872B020C4A;
parameter P = 32'h41700000;
parameter P_double = 64'h402E000000000000;
//const1=1.5
parameter const1 = 64'h3FF8000000000000;
//const2=0.001
parameter const2 = 64'h3F50624DD2F1A9FC;
//parameter Tm = 64'h4072C00000000000;//300

input clk_sim;
input rst_control;
input rst_user;
input sta_user;
input sta_control;
input control_valuation_sig;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] Tm;
input [`EXTENDED_SINGLE - 1:0] wm_starter;

wire [`EXTENDED_SINGLE - 1:0] Va_double;
wire [`EXTENDED_SINGLE - 1:0] Vb_double;
wire [`EXTENDED_SINGLE - 1:0] Vc_double;
wire [`EXTENDED_SINGLE - 1:0] Te_double;
wire [`EXTENDED_SINGLE - 1:0] Tm_double;

output [`SINGLE - 1:0] wm;
output wire [`EXTENDED_SINGLE - 1:0] wm_temp;
output [`SINGLE - 1:0] theta;
output [`SINGLE - 1:0] Te;
output [`SINGLE - 1:0] Ia;
output [`SINGLE - 1:0] Ib;

output wire [`EXTENDED_SINGLE - 1:0] Id_temp;
output wire [`EXTENDED_SINGLE - 1:0] Iq_temp; 
output done_sig_PMSM; 
output wire done_sig_finish_wm; 
output wire done_sig_finish_wm_double;
output wire done_sig_finish_Idtemp;

wire [`EXTENDED_SINGLE - 1:0] wm_temp1;
wire [`EXTENDED_SINGLE - 1:0] wm_temp2;
wire [`EXTENDED_SINGLE - 1:0] Iambda_d;
wire [`EXTENDED_SINGLE - 1:0] Iambda_q;
wire [`EXTENDED_SINGLE - 1:0] Iambda_q_stor;
wire [`EXTENDED_SINGLE - 1:0] Iambda_d_stor;
//wire [`EXTENDED_SINGLE - 1:0] Ia_double;
//wire [`EXTENDED_SINGLE - 1:0] Ib_double;
//wire [`EXTENDED_SINGLE - 1:0] Ic_double;
wire [`EXTENDED_SINGLE - 1:0] Ia_1;
wire [`EXTENDED_SINGLE - 1:0] Ib_1;
wire [`EXTENDED_SINGLE - 1:0] Ic_1;
wire [`EXTENDED_SINGLE - 1:0] inner_result1_temp;
wire [`EXTENDED_SINGLE - 1:0] inner_result2_temp;

wire [`SINGLE - 1:0] we;
wire [`SINGLE - 1:0] theta_stor;
wire [`EXTENDED_SINGLE - 1:0] we_stor;
wire [`EXTENDED_SINGLE - 1:0] sum2;
wire [`EXTENDED_SINGLE - 1:0] Vd;
wire [`EXTENDED_SINGLE - 1:0] Vq;
wire [`SINGLE - 1:0] sin_theta;
wire [`SINGLE - 1:0] cos_theta;
wire [`EXTENDED_SINGLE - 1:0] d_product1;
wire [`EXTENDED_SINGLE - 1:0] q_product1;
wire [`EXTENDED_SINGLE - 1:0] d_product2;
wire [`EXTENDED_SINGLE - 1:0] q_product2;
wire [`EXTENDED_SINGLE - 1:0] d_product3;
wire [`EXTENDED_SINGLE - 1:0] sum1;
wire [`EXTENDED_SINGLE - 1:0] product1;
wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] we_temp;
wire [`EXTENDED_SINGLE - 1:0] theta_temp;
wire [`EXTENDED_SINGLE - 1:0] sin_theta_double;
wire [`EXTENDED_SINGLE - 1:0] cos_theta_double;
wire done_sig_PID170;
wire done_sig_Multiplier_inner_result11;
wire donesig_double2single_10d;
wire control_valuation_sig;
wire done_sig_abc2dq0;
wire done_sig_sub0;
wire done_sig_add0;
wire done_sig_multiplier1;
wire done_sig_multiplier2;
wire done_sig_multiplier3;
wire done_sig_multiplier4;
wire done_sig_multiplier5;
wire done_sig_multiplier6;
wire done_sig_multiplier7;
wire done_sig_multiplier8;
wire done_sig_cos;
wire done_sig_sin;
wire done_sig_delay1;
wire done_sig_delay2;
wire done_sig_delay3;
wire done_sig_delay4;
wire done_sig_delay5;
wire donesig_dq02abc;
wire done_sig_multiplier21;
wire done_sig_multiplier22;
wire done_sig_multiplier23;
wire done_sig_single2float_aaa1;
wire done_sig_single2float_aaa2;
wire done_sig_single2float_aaa3;
wire done_sig_single2float_aaa4;
wire done_sig_single2float_aaa5;
wire done_sig_PID10;
wire donesig_double2single_1;
wire done_sig_single2float_10;
wire done_sig_PID110;
wire donesig_double2single_110;
wire donesig_double2single_10a;
wire donesig_double2single_10b;
wire donesig_double2single_10c;
wire done_sig_single2float_aaa6;


Sin_control_system   sin1(
							.clk(clk_sim),
							.rst(rst_control),
							.sta(sta_control),
							.theta(theta_stor),
							 		
							.sin(sin_theta),
							.done_sig(done_sig_sin)
								);//37
															
Cos_control_system  cos1(
							.clk(clk_sim),
							.rst(rst_control),
							.sta(sta_control),
							.theta(theta_stor),
							 			
							.cos(cos_theta),
							.done_sig(done_sig_cos)
								);	//37

/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////		
					
convert_single_to_double_control_system  single2float_aaa1(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(sta_control),
															  .x(Va),
															  .y(Va_double),
															  .done_sig(done_sig_single2float_aaa1)
															  );
convert_single_to_double_control_system  single2float_aaa2(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(sta_control),
															  .x(Vb),
															  .y(Vb_double),
															  .done_sig(done_sig_single2float_aaa2)
															  );
convert_single_to_double_control_system  single2float_aaa3(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(sta_control),
															  .x(Vc),
															  .y(Vc_double),
															  .done_sig(done_sig_single2float_aaa3)
															  );
convert_single_to_double_control_system  single2float_aaa6(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(sta_control),
															  .x(Tm),
															  .y(Tm_double),
															  .done_sig(done_sig_single2float_aaa6)
															  );															  
convert_single_to_double_control_system  single2float_aaa4(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_sin),
															  .x(sin_theta),
															  .y(sin_theta_double),
															  .done_sig(done_sig_single2float_aaa4)
															  );
															  
convert_single_to_double_control_system  single2float_aaa5(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_cos),
															  .x(cos_theta),
															  .y(cos_theta_double),
															  .done_sig(done_sig_single2float_aaa5)
															  );//3	

															  

								
abc2dq064	abc2dq0(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_single2float_aaa4),
					.Va(Va_double),
					.Vb(Vb_double),
					.Vc(Vc_double),
					.sin_theta(sin_theta_double),
					.cos_theta(cos_theta_double),
					
					.Vd(Vd),
					.Vq(Vq),
					.done_sig(done_sig_abc2dq0)
				  ); //36			  
parameter Vdd = 64'h4046800000000000;//45
parameter Vqq = 64'hC018000000000000;//-6
parameter we_stor1 = 64'hC02E000000000000;//-15
parameter Iambda_q_stor1 = 64'h3FF8000000000000;//1.5
parameter Iambda_d_stor1 = 64'h4004000000000000;//2.5									  
multiplier_control_system64_dsp  multiplier_control_system0(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(sta_control),
					.x(we_stor),
					.y(Iambda_q_stor),
					
					.xy(d_product1),
					.done_sig(done_sig_multiplier1)
										  );
										  
multiplier_control_system64_dsp  multiplier_control_system1(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(sta_control),
					.x(we_stor),
					.y(Iambda_d_stor),
					
					.xy(q_product1),
					.done_sig(done_sig_multiplier2)
										  );
										  
adder_control_system64 Adder_inner_result0(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_abc2dq0),
									 .add_sub(`add),
									 .x(Vd),
									 .y(d_product1),
									 .xy(inner_result1),
									 .done_sig(done_sig_add0)
								   );	//7									  
										  
adder_control_system64 sub_inst1(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_abc2dq0),
									 .add_sub(`sub),
									 .x(Vq),
									 .y(q_product1),
									 .xy(inner_result2),
									 .done_sig(done_sig_sub0)
								   );	
	
////////////////////////////////////		
			
///////////////////////////////////////////////////////////////////////////////////

PID_Initial64 #(64'h3F61DD1C25093C62,64'h3F61DD1C25093C62,64'h3FEFF71171E9E897,64'h4010000000000000) PID10(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_add0),
			 .control_valuation_sig(control_valuation_sig),
			 .x(inner_result1),
			
			 .y(Id_temp),
			 .done_sig(done_sig_PID10)
		   );	//21	
/*			
convert_double_to_single_control_system   double2single_1(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_PID10),
															  .x(Id_temp),
															  .y(Id),
															  .done_sig(donesig_double2single_1)
															  );
*/															  
	
PID_Initial64 #(64'h3F61DD1C25093C62,64'h3F61DD1C25093C62,64'h3FEFF71171E9E897,64'h4010000000000000) PID110(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_add0),
			 .control_valuation_sig(control_valuation_sig),
			 .x(inner_result2),
			
			 .y(Iq_temp),
			 .done_sig(done_sig_PID110)
		   );			
assign done_sig_finish_Idtemp = 	done_sig_PID110;
/////////////////////////////////////////////////////////////////////////////////////								  
dq02abc64 dq02abc111(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(donesig_double2single_110),
					.Vd(Id_temp),
					.Vq(Iq_temp),
					.sin_theta(sin_theta_double),
					.cos_theta(cos_theta_double),
					
					.Va(Ia_1),
					.Vb(Ib_1),
					.Vc(Ic_1),
					.done_sig(donesig_dq02abc)
				  );
/*				  
multiplier_control_system64  multiplier_control_system21(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(donesig_dq02abc),
					.x(Ia_1),
					.y(const2),
					
					.xy(Ia_double),
					.done_sig(done_sig_multiplier21)
										  );		
multiplier_control_system64  multiplier_control_system22(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(donesig_dq02abc),
					.x(Ib_1),
					.y(const2),
					
					.xy(Ib_double),
					.done_sig(done_sig_multiplier22)
										  );	
										  
multiplier_control_system64  multiplier_control_system23(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(donesig_dq02abc),
					.x(Ic_1),
					.y(const2),
					
					.xy(Ic_double),
					.done_sig(done_sig_multiplier23)
										  );	

*/	

						  
convert_double_to_single_control_system   double2single_10a(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(donesig_dq02abc),
															  .x(Ia_1),
															  .y(Ia),
															  .done_sig(donesig_double2single_10a)
															  );	
convert_double_to_single_control_system   double2single_10b(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(donesig_dq02abc),
															  .x(Ib_1),
															  .y(Ib),
															  .done_sig(donesig_double2single_10b)
															  );																  
															  
															  														  															 															  															  
//////////////////////////		
multiplier_control_system64_dsp  multiplier_control_system2(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_PID110),
					.x(Id_temp),
					.y(Ld),
					
					.xy(d_product2),
					.done_sig(done_sig_multiplier3)
										  );
										  
multiplier_control_system64_dsp  multiplier_control_system3(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_PID110),
					.x(Iq_temp),
					.y(Lq),
					
					.xy(Iambda_q),
					.done_sig(done_sig_multiplier4)
										  );

									
adder_control_system64  add1(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier3),
									 .add_sub(`add),
									 .x(d_product2),
									 .y(Flux),
									 .xy(Iambda_d),
									 .done_sig(done_sig_delay1)
								   );
									
DELAY_1CLK #(7) Delay_DONE_SIG3(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_multiplier4),
										  .q(done_sig_delay2)
										 );
										 
////////////////////////////

System_partition_64 Storage_a(
									.clk(clk_sim),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(Iambda_q),
									.cout(Iambda_q_stor)
								  );
														 
System_partition_64 Storage_b(
									.clk(clk_sim),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(Iambda_d),
									.cout(Iambda_d_stor)
								  );
								 
////								 
										 
multiplier_control_system64_dsp  multiplier_control_system4(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay1),
					.x(Iambda_d),
					.y(Iq_temp),
					
					.xy(d_product3),
					.done_sig(done_sig_multiplier5)
										  );
										  
multiplier_control_system64_dsp  multiplier_control_system5(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay2),
					.x(Iambda_q),
					.y(Id_temp),
					
					.xy(q_product2),
					.done_sig(done_sig_multiplier6)

										  );
wire donesig_double2single_10t;
wire donesig_double2single_10y;
wire [`SINGLE - 1:0] aaa;
wire [`SINGLE - 1:0] bbb;
convert_double_to_single_control_system   double2single_10t(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_multiplier5),
															  .x(d_product3),
															  .y(aaa),
															  .done_sig(donesig_double2single_10t)
															  );

convert_double_to_single_control_system   double2single_10y(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_multiplier6),
															  .x(q_product2),
															  .y(bbb),
															  .done_sig(donesig_double2single_10y)
															  );


										  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////										  
adder_control_system64 sub_inst2(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier6),
									 .add_sub(`sub),
									 .x(d_product3),
									 .y(q_product2),
									 .xy(sum1),
									 .done_sig(done_sig_delay3)
								   );	
				
//////////////			
multiplier_control_system64_dsp  multiplier_control_system6(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay3),
					.x(sum1),
					.y(const1),
					
					.xy(product1),
					.done_sig(done_sig_multiplier7)	
					);
multiplier_control_system64_dsp  multiplier_control_system7(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier7),
					.x(product1),
					.y(P_double),
					
					.xy(Te_double),////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					.done_sig(done_sig_multiplier8)	
					);
					
convert_double_to_single_control_system   double2single_10d(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_multiplier8),
															  .x(Te_double),
															  .y(Te),
															  .done_sig(donesig_double2single_10d)
															  );					
					
					
adder_control_system64 sub_inst22(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier8),
									 .add_sub(`sub),
									 .x(Te_double),
									 .y(Tm_double),
									 .xy(sum2),
									 .done_sig(done_sig_delay4)
								   );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////									
wire done_sig_PID1701;				
PI64  #(64'h3EB92A737110E454,64'h3EB92A737110E454)  PI170(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_delay4),
			 .control_valuation_sig(control_valuation_sig),
			 .x(sum2),
			 			 			 
			 .y(wm_temp1),
			 .done_sig(done_sig_PID1701)
		   );	
wire done_sig_sub_inst2112;	
adder_control_system64 sub_inst2112(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_PID1701),
									 .add_sub(`add),
									 .x(wm_starter),
									 .y(wm_temp1),
									 .xy(wm_temp2),
									 .done_sig(done_sig_sub_inst2112)
								   );
									
threshold64 #(64'h403E000000000000,64'h3EB0C6F7A0B5ED8D,64'h0000000000000000)  threshold64wm(
					  .clk(clk_sim),
					  .rst(rst_control),
					  .sta(done_sig_sub_inst2112),
					  .x(wm_temp2),
					  .y(wm_temp),				  
					  .done_sig(done_sig_PID170)
					 );	
			
assign done_sig_finish_wm_double = done_sig_PID170;			
			
			
convert_double_to_single_control_system   double2single_71(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_PID170),
															  .x(wm_temp),
															  .y(wm),
															  .done_sig(done_sig_delay5)
															  );
assign done_sig_finish_wm = done_sig_delay5;
				  
multiplier_64_dsp	Multiplier_inner_result11(
														 .aclr(rst_control),
														 .clk_en(1'b1),
														 .clock(clk_sim),
														 .dataa(wm_temp1),
	                                        .datab(P_double),
														 .result(we_temp)
														);	
														

															  
DELAY_1CLK #(5) Delay_DONE_SIG116(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_PID1701),
										  .q(done_sig_Multiplier_inner_result11)
              );
wire done_sig_double2single_720;
convert_double_to_single_control_system   double2single_720(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_Multiplier_inner_result11),
															  .x(we_temp),
															  .y(we),
															  .done_sig(done_sig_double2single_720)
															  );	

wire done_sig_PID1710;

PI64  #(64'h3EB92A737110E454,64'h3EB92A737110E454)  PI1710(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_Multiplier_inner_result11),
			 .control_valuation_sig(control_valuation_sig),
			 .x(we_temp),
			 .y(theta_temp),
			 .done_sig(done_sig_PID1710)
		   );	
			
convert_double_to_single_control_system   double2single_710(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_PID1710),
															  .x(theta_temp),
															  .y(theta),
															  .done_sig(done_sig_PMSM)
															  );	
															  
	
//////////////////////////////////////////////////////////				

System_partition_64 Storage_c(
									.clk(clk_sim),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(theta),
									.cout(theta_stor)
								  );
														 
System_partition_64 Storage_d(
									.clk(clk_sim),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(we_temp),
									.cout(we_stor)
								  );

								  

endmodule

