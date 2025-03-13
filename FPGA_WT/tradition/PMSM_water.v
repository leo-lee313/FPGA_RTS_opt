`include "../parameter/global_parameter.v"

module PMSM_water(
			 clk_sim,
			 rst_control,
			 sta_control,
			 rst_user,
			 sta_user,
			 before_sta_control,
			 output_num, 
	       Tm,
			 Va,
			 Vb,
			 Vc,
			 
			 
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
			 done_sig_finish_Iab,
			 done_read_x_outpi,
			 done_readTm_before,
			 done_read_x127,
			 done_sig_PMSM          		 
			);
			 		
parameter Ld = 64'h3F53A92A30553261;
parameter Lq = 64'h3F53A92A30553261;
parameter Flux = 64'h4003A9FBE76C8B44;
parameter P = 32'h42F00000;
parameter P_double = 64'h405E000000000000;
//const1=1.5
parameter const1 = 64'h3FF8000000000000;
//const2=0.001
parameter const2 = 64'h3F50624DD2F1A9FC;
parameter wm_starter = 64'h4002C49BA5E353F8;
//parameter Tm = 64'h4072C00000000000;//300

input clk_sim;
input rst_control;
input rst_user;
input sta_user;
input sta_control;
input before_sta_control;//before sta_control 2clk
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`EXTENDED_SINGLE - 1:0] Tm;
input [7:0] output_num;

output [`SINGLE - 1:0] wm;
output [`SINGLE - 1:0] theta;
output [`SINGLE - 1:0] Te;
output [`SINGLE - 1:0] Ia;
output [`SINGLE - 1:0] Ib;
output wire [`EXTENDED_SINGLE - 1:0] Id_temp;
output wire [`EXTENDED_SINGLE - 1:0] Iq_temp;
output wire [`EXTENDED_SINGLE - 1:0] wm_temp; 
output wire done_sig_PMSM; 
output wire done_sig_finish_wm; 
output wire done_sig_finish_wm_double;
output wire done_sig_finish_Idtemp;
output wire done_read_x_outpi;
output wire done_readTm_before,done_sig_finish_Iab;
output done_read_x127;

wire [`EXTENDED_SINGLE - 1:0] Va_double;
wire [`EXTENDED_SINGLE - 1:0] Vb_double;
wire [`EXTENDED_SINGLE - 1:0] Vc_double;
wire [`EXTENDED_SINGLE - 1:0] Va_double_delay;
wire [`EXTENDED_SINGLE - 1:0] Vb_double_delay;
wire [`EXTENDED_SINGLE - 1:0] Vc_double_delay;
wire [`EXTENDED_SINGLE - 1:0] Te_double;
wire [`EXTENDED_SINGLE - 1:0] Iambda_d;
wire [`EXTENDED_SINGLE - 1:0] Iambda_q,Iambda_q_temp;
wire [`EXTENDED_SINGLE - 1:0] Iambda_q_stor;
wire [`EXTENDED_SINGLE - 1:0] Iambda_d_stor;
wire [`EXTENDED_SINGLE - 1:0] Ia_1;
wire [`EXTENDED_SINGLE - 1:0] Ib_1;
wire [`EXTENDED_SINGLE - 1:0] Ic_1;
wire [`EXTENDED_SINGLE - 1:0] wm_temp1;
wire [`EXTENDED_SINGLE - 1:0] wm_temp2;
wire [`EXTENDED_SINGLE - 1:0] we_stor;
wire [`EXTENDED_SINGLE - 1:0] sum2;
wire [`EXTENDED_SINGLE - 1:0] Vd;
wire [`EXTENDED_SINGLE - 1:0] Vq;
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
wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay;
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay;
wire [`EXTENDED_SINGLE - 1:0] Id_temp_delay,Iq_temp_delay;

wire [`SINGLE - 1:0] we;
wire [`SINGLE - 1:0] theta_stor;
wire [`SINGLE - 1:0] sin_theta;
wire [`SINGLE - 1:0] cos_theta,cos_theta_temp;


wire done_sig_Multiplier_inner_result171;
wire done_sig_abc2dq070;
wire done_sig_add77;
wire done_sig_multiplier102;
wire done_sig_multiplier126;
wire done_sig_cos36;
wire done_sig_sin37;
wire done_sig_delay109;
wire done_sig_delay138;
wire donesig_dq02abc121;
wire done_sig_sindouble39;
wire done_sig_PID97;
wire done_ena_read63;
wire done_read_before62;
wire done_read_x160;
wire done_sig_PID157;
wire done_sig_sub_inst164;
wire done_sig_PID190;
wire done_ena_write2;
wire done_read_x123;
wire done_read_x156;											 																		  
										 
System_FIFO_32   FIFO(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(before_sta_control),
								.before_enawrite(done_sig_PMSM),
								.cin( theta ),
								.cout( theta_stor )
							  );
		
Sin_control_system_water   sin1(
							.clk(clk_sim),
							.rst(rst_control),
							.sta(sta_control),
							.theta(theta_stor),
							 		
							.sin(sin_theta),
							.done_sig(done_sig_sin37)
								);//37
															
Cos_control_system_water  cos1(
							.clk(clk_sim),
							.rst(rst_control),
							.sta(sta_control),
							.theta(theta_stor),
							 			
							.cos(cos_theta_temp),
							.done_sig(done_sig_cos36)
								);	//36
								
DELAY_NCLK  #(32,1)  DELAY_NCLK0(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(cos_theta_temp),
						               .q(cos_theta)
					                 );
										  
SINGLE2EXTENDED_SINGLE	single2float_aaa1 (
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(Va),
													        .result(Va_double)
													        );		
					
SINGLE2EXTENDED_SINGLE	single2float_aaa2 (
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(Vb),
													        .result(Vb_double)
													        );
															  
SINGLE2EXTENDED_SINGLE	single2float_aaa3 (
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(Vc),
													        .result(Vc_double)
													        );
															  
DELAY_1CLK  #(2) Delay_sta0(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(sta_control),
						               .q(done_ena_write2)
					                  );
											
				  

System_FIFO_64   FIFO_Va_double(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_sig_sin37),
								.before_enawrite(done_ena_write2),
								.cin( Va_double ),
								.cout( Va_double_delay )
							  );
							  
System_FIFO_64   FIFO_Vb_double(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_sig_sin37),
								.before_enawrite(done_ena_write2),
								.cin( Vb_double ),
								.cout( Vb_double_delay )
							  );
							  
System_FIFO_64   FIFO_Vc_double(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_sig_sin37),
								.before_enawrite(done_ena_write2),
								.cin( Vc_double ),
								.cout( Vc_double_delay )
							  );							  										  															  

										  
convert_single_to_double_control_system  single2float_aaa4(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_sin37),
															  .x(sin_theta),
															  .y(sin_theta_double),
															  .done_sig(done_sig_sindouble39)
															  );

SINGLE2EXTENDED_SINGLE	single2float_aaa5 (
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(cos_theta),
													        .result(cos_theta_double)
													        );															  										  

								
abc2dq064_water	abc2dq0(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_sindouble39),
					.Va(Va_double_delay),
					.Vb(Vb_double_delay),
					.Vc(Vc_double_delay),
					.sin_theta(sin_theta_double),
					.cos_theta(cos_theta_double),
					
					.Vd(Vd),
					.Vq(Vq),
					.done_sig(done_sig_abc2dq070)
				  ); //31			  
parameter Vdd = 64'h4046800000000000;//45
parameter Vqq = 64'hC018000000000000;//-6
parameter we_stor1 = 64'hC02E000000000000;//-15
parameter Iambda_q_stor1 = 64'h3FF8000000000000;//1.5
parameter Iambda_d_stor1 = 64'h4004000000000000;//2.5	



DELAY_1CLK  #(24) Delay_sta_user_0(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_sindouble39),
						               .q(done_ena_read63)
					                  );
											
				  

System_FIFO_64   FIFO_we(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read63),
								.before_enawrite(done_sig_Multiplier_inner_result171),
								.cin( we_temp ),
								.cout( we_stor )
							  );	
System_FIFO_64   FIFO_Iambda_q(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read63),
								.before_enawrite(done_sig_delay109),
								.cin( Iambda_q ),
								.cout( Iambda_q_stor )
							  );
	
System_FIFO_64   FIFO_Iambda_d(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read63),
								.before_enawrite(done_sig_delay109),
								.cin( Iambda_d ),
								.cout( Iambda_d_stor )
							  );
							  
multiplier_64_dsp     multiplier_control_system0(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(we_stor),
									  .datab(Iambda_q_stor),
									  .result(d_product1)
									 );
									 
multiplier_64_dsp     multiplier_control_system1(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(we_stor),
									  .datab(Iambda_d_stor),
									  .result(q_product1)
									 );
									 
										  
adder_control_system64 Adder_inner_result0(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_abc2dq070),
									 .add_sub(`add),
									 .x(Vd),
									 .y(d_product1),
									 .xy(inner_result1),
									 .done_sig(done_sig_add77)
								   );	//7
									
ADD_SUB_64	sub_inst1(
										  .aclr(rst_control),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk_sim),
										  .dataa(Vq),
						              .datab(q_product1),
						              .result(inner_result2)
										 );										 	
	
///////////////////////////////////
											
DELAY_1CLK  #(23) Delay_sta_user_aaa0(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_sindouble39),
						               .q(done_read_before62)
					                  );			
///////////////////////////////////////////////////////////////////////////////////
                         
PID_Initial64_water_v3 #(64'h3f6eb816c81b6960,64'h3f6eb816c81b6960,64'h3fefff809a0cd560,64'h405edd3c0c8b28be) PID10(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_add77),
			 .done_read(done_read_before62),
			 .x(inner_result1),
			
			 .y(Id_temp),
			 .done_sig(done_sig_finish_Idtemp)
		   );	//20	
															  
	                      
PID_Initial64_water_v3 #(64'h3f6eb816c81b6960,64'h3f6eb816c81b6960,64'h3fefff809a0cd560,64'h405edd3c0c8b28be) PID110(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_add77),
			 .done_read(done_read_before62),
			 .x(inner_result2),
			
			 .y(Iq_temp),
			 .done_sig(done_sig_PID97)
		   );			
/////////////////////////////////////////////////////////////////////////////////////
wire done_ena_read95;
DELAY_1CLK  #(18) Delay_stafff(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_add77),
						               .q(done_ena_read95)
					                  );
															  
System_FIFO_64   FIFO_sin_theta(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read95),
								.before_enawrite(done_sig_sindouble39),
								.cin( sin_theta_double ),
								.cout( sin_theta_delay )
							  );
							  
System_FIFO_64   FIFO_cos_theta(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read95),
								.before_enawrite(done_sig_sindouble39),
								.cin( cos_theta_double ),
								.cout( cos_theta_delay )
							  );
							  
dq02abc64_water dq02abc111(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_finish_Idtemp),
					.Vd(Id_temp),
					.Vq(Iq_temp),
					.sin_theta(sin_theta_delay),
					.cos_theta(cos_theta_delay),
					
					.Va(Ia_1),
					.Vb(Ib_1),
					.Vc(Ic_1),
					.done_sig(donesig_dq02abc121)
				  );

						  
EXTENDED_SINGLE2SINGLE	double2single_10a(
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(Ia_1),
													        .result(Ia)
													        );
															  															  
convert_double_to_single_control_system   double2single_10b(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(donesig_dq02abc121),
															  .x(Ib_1),
															  .y(Ib),
															  .done_sig(done_sig_finish_Iab)
															  );															 															  
															  
DELAY_1CLK  #(7) Delay_sta_user_hhh0(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(donesig_dq02abc121),
						               .q(done_readTm_before)
					                  );	
											
//////////////////////////		
multiplier_control_system64  multiplier_control_system2(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_finish_Idtemp),
					.x(Id_temp),
					.y(Ld),
					
					.xy(d_product2),
					.done_sig(done_sig_multiplier102)
										  );
										  
multiplier_64_dsp     multiplier_control_system3(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(Iq_temp),
									  .datab(Lq),
									  .result(Iambda_q_temp)
									 );																	
adder_control_system64  add1(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier102),
									 .add_sub(`add),
									 .x(d_product2),
									 .y(Flux),
									 .xy(Iambda_d),
									 .done_sig(done_sig_delay109)
								   );
DELAY_NCLK  #(64,7)  DELAY_NCLK4(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(Iambda_q_temp),
						               .q(Iambda_q)
					                 );	
								

										 
////////////////////////////
DELAY_NCLK  #(64,12)  DELAY_NCLK14(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(Iq_temp),
						               .q(Iq_temp_delay)
					                 );	

DELAY_NCLK  #(64,12)  DELAY_NCLK15(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(Id_temp),
						               .q(Id_temp_delay)
					                 );
	 										 										  
multiplier_64_dsp	multiplier_control_system4(
														 .aclr(rst_control),
														 .clk_en(`ena_math),
														 .clock(clk_sim),
														 .dataa(Iambda_d),
														 .datab(Iq_temp_delay),
														 .result(d_product3)
														);
/*														
multiplier_control_system64  multiplier_control_system5(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay2),
					.x(Iambda_q),
					.y(Id_temp_delay),
					
					.xy(q_product2),
					.done_sig(done_sig_multiplier6)

										  );
*/										  
multiplier_64_dsp	multiplier_control_system5(
														 .aclr(rst_control),
														 .clk_en(`ena_math),
														 .clock(clk_sim),
														 .dataa(Iambda_q),
														 .datab(Id_temp_delay),
														 .result(q_product2)
														);
										  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*										  
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
*/	
ADD_SUB_64	sub_inst2(
										  .aclr(rst_control),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk_sim),
										  .dataa(d_product3),
						              .datab(q_product2),
						              .result(sum1)
										 );
										 
//////////////	
multiplier_64_dsp	multiplier_control_system51(
														 .aclr(rst_control),
														 .clk_en(`ena_math),
														 .clock(clk_sim),
														 .dataa(sum1),
														 .datab(const1),
														 .result(product1)
														);
DELAY_1CLK #(17) Delay_DONE_SIG3(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_delay109),
										  .q(done_sig_multiplier126)
										 );
										 
									 
DELAY_1CLK #(14) Delay_DONE_SIG123(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_delay109),
										  .q(done_read_x123)
										 );										 
										 
										 
/*		
multiplier_control_system64  multiplier_control_system6(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay3),
					.x(sum1),
					.y(const1),
					
					.xy(product1),
					.done_sig(done_sig_multiplier126)	
					);
*/
multiplier_64_dsp	multiplier_control_system7(
														 .aclr(rst_control),
														 .clk_en(`ena_math),
														 .clock(clk_sim),
														 .dataa(product1),
														 .datab(P_double),
														 .result(Te_double)
														);
/*
multiplier_control_system64  multiplier_control_system7(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier126),
					.x(product1),
					.y(P_double),
					
					.xy(Te_double),
					.done_sig(done_sig_multiplier8)	
					);
*/																				  
EXTENDED_SINGLE2SINGLE	double2single_10d(
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(Te_double),
													        .result(Te)
													        );					
					
ADD_SUB_64	sub_inst22(
										  .aclr(rst_control),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk_sim),
										  .dataa(Te_double),
						              .datab(Tm),
						              .result(sum2)
										 );									
																										
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////											 
DELAY_1CLK #(1) Delay_DONE_SIGaaa3(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_multiplier126),
										  .q(done_read_x127)
										 );
										 
DELAY_1CLK #(11) Delay_DONE_SIG3qq(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_read_x127),
										  .q(done_sig_delay138)
										 );
										 
DELAY_1CLK #(3) Delay_DONE_SIGbbb3(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_PID157),
										  .q(done_read_x160)
										 );

		


DELAY_1CLK #(29) Delay_done_read_x156(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_read_x127),
										  .q(done_read_x156)
										 );



		
PI64_water_v2  #(64'h3dc8bd2fdda89129,64'h3dc8bd2fdda89129)  PI170(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_delay138),
			 .done_read_x(done_read_x123),
			 .x(sum2),
			 			 			 
			 .y(wm_temp1),
			 .done_sig(done_sig_PID157)
		   );			
	
adder_control_system64 sub_inst2112(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_PID157),
									 .add_sub(`add),
									 .x(wm_starter),
									 .y(wm_temp1),
									 .xy(wm_temp2),
									 .done_sig(done_sig_sub_inst164)
								   );
									
DELAY_1CLK #(3) Delay_DONE_SIGabc(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_read_x160),
										  .q(done_read_x_outpi)
										 );																		
									
limit_control_system64_water #(64'h4202A05F20000000,64'hC202A05F20000000) limit_wm(
									  .clk(clk_sim),
					              .rst(rst_control),
					              .sta(done_sig_sub_inst164),
					              .x(wm_temp2),
					              .y(wm_temp),				  
					              .done_sig(done_sig_finish_wm_double)
									 ); 									
												
convert_double_to_single_control_system   double2single_71(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_finish_wm_double),
															  .x(wm_temp),
															  .y(wm),
															  .done_sig(done_sig_finish_wm)
															  );					
				  
multiplier_64_dsp	Multiplier_inner_result11(
														 .aclr(rst_control),
														 .clk_en(1'b1),
														 .clock(clk_sim),
														 .dataa(wm_temp),
	                                        .datab(P_double),
														 .result(we_temp)
														);	
														

															  
DELAY_1CLK #(5) Delay_DONE_SIG116(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_finish_wm_double),
										  .q(done_sig_Multiplier_inner_result171)
              );
				  			  				  															  
EXTENDED_SINGLE2SINGLE	double2single_720(
	                                            .aclr(rst_control),
													        .clk_en(`ena_math),
													        .clock(clk_sim),
													        .dataa(we_temp),
													        .result(we)
													        );

                  
PI64_water_v2_theta  #(64'h3ed2dfd694ccab3f,64'h3ed2dfd694ccab3f)  PI1710(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_Multiplier_inner_result171),
			 .done_read_x(done_read_x156),
			 .x(we_temp),
			 .y(theta_temp),
			 .done_sig(done_sig_PID190)
		   );	
			
convert_double_to_single_control_system   double2single_710(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_PID190),
															  .x(theta_temp),
															  .y(theta),
															  .done_sig(done_sig_PMSM)
															  );	
															  

															  
/*for observing control variable_wm*/
wire [`SINGLE - 1:0] wm_Observe;
wire [5:0] addr_write_wm;
wire sta_wren_wm,ena_cal_write_wm;
wire ena_write_wm,rden_wm;
wire pulse_write_wm;
wire step_write_wm;

DELAY_1CLK #(2) Delay_DONE_SIG1161(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_finish_wm_double),
										  .q(sta_wren_wm)
              );
				  
DELAY_1CLK #(64) Delay_read_wm(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_sig_finish_wm_double),
										  .q(rden_wm)
              );
				  
ADDR #( 6 , `N_WindTurbine , 1 , 1'b0 ) ADDR1111(
																.clk(clk_sim),
																.rst(rst_control),
																.sta(sta_wren_wm), 
																.addr(addr_write_wm),
																.pulse(pulse_write_wm),
																.ena_mem(ena_write_wm),
																.step(step_write_wm),
																.ena_cal(ena_cal_write_wm)
																);

Observe_Control_Variable	Observe_wm (
	.aclr ( rst_control ),
	.clock ( clk_sim ),
	.data ( wm ),
	.enable ( 1'b1 ),
	.rdaddress ( output_num[5:0] ),
	.rden ( rden_wm ),
	.wraddress ( addr_write_wm ),
	.wren ( ena_cal_write_wm ),
	.q ( wm_Observe )
	);


				

								  

endmodule

