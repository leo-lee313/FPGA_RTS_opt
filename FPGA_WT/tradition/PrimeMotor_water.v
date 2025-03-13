`include "../parameter/global_parameter.v"

module PrimeMotor_water(
			 clk_sim,
			 sta_user,
			 FLAGFH,
			 rst_user,
			 rst_control,
			 sta_control,
          sim_time,
          output_num,			 
			 Va,
			 Vb,
			 Vc,		 
			 Ia_pm_rec,
			 Ib_pm_rec,
          Ic_pm_rec,
			 before_sta_control,
			 
			 Ia,
			 Ib,
			 
			 m1_single,
			 m3_single,
			 m5_single,
			 
			 sta_before_m_3clk,
			 done_sig_finish_Iab,
			 done_sig
			);
//constwbase is 20.42035225
parameter constwbase = 64'h40346B9C347E8CCE;
//constRow is 1.225
parameter constRow = 32'h3F9CCCCD;
//constAr is 3631.681161,and equals to (3.1415927*R*R)
parameter constAr = 32'h4562FAE6;
//constR is 34
parameter constR = 32'h42080000;
//const1 is 0.08
parameter const1 = 32'h3DA3D70A;
//const2 is 0.035
parameter const2 = 32'h3D0F5C29;

parameter consttwo = 64'h4000000000000000;
parameter constone = 32'h3F800000; 
//parameter Tm1_temp_stor = 32'h41200000;
//const3 is 0.5
parameter const3 = 32'h3F000000;
//const4 is 0.5176
parameter const4 = 32'h3F04816F;
//const5 is 5
parameter const5 = 32'h40A00000;
//const6 is 0.4
parameter const6 = 32'h3ECCCCCD;
//const7 is -21
parameter const7 = 32'hC1A80000;
//const8 is 0.0068
parameter const8 = 32'h3BDED289;
//const9 is -1
parameter const9 = 32'hBF800000;
//const116 is 116
parameter const116 = 32'h42E80000;
//parameter beta	= 32'h00000000;	

input clk_sim,FLAGFH;
input rst_control;
input sta_control;
input rst_user;
input sta_user;
input before_sta_control;
input [`WIDTH_TIME - 1:0] sim_time;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] Ia_pm_rec;
input [`SINGLE - 1:0] Ib_pm_rec;
input [`SINGLE - 1:0] Ic_pm_rec;
input [7:0] output_num;

output [`SINGLE - 1:0] Ia;
output [`SINGLE - 1:0] Ib;
output [`SINGLE - 1:0] m1_single,m3_single,m5_single;
output done_sig;
output sta_before_m_3clk;
output done_sig_finish_Iab;

wire [`SINGLE - 1:0] wm;
wire [`SINGLE - 1:0] VWind;
wire [`SINGLE - 1:0] VWind1;
wire [`SINGLE - 1:0] inv_VWind;
wire [`SINGLE - 1:0] lamda;
wire [`SINGLE - 1:0] lamda1;
wire [`SINGLE - 1:0] inner_product1;
wire [`SINGLE - 1:0] Tm1_temp;
wire [`SINGLE - 1:0] Tm_temp;
wire [`SINGLE - 1:0] inner_sum1;
wire [`SINGLE - 1:0] inner_result4;
wire [`SINGLE - 1:0] inner_result5;
wire [`SINGLE - 1:0] inner_result6;
wire [`SINGLE - 1:0] inner_result7;
wire [`SINGLE - 1:0] inner_result8;
wire [`SINGLE - 1:0] inner_result9;
wire [`SINGLE - 1:0] inner_result10;
wire [`SINGLE - 1:0] inner_result11;
wire [`SINGLE - 1:0] inner_product222;
wire [`SINGLE - 1:0] inner_product333;
wire [`SINGLE - 1:0] inner_product444;
wire [`SINGLE - 1:0] inner_product5;
wire [`SINGLE - 1:0] inner_product6;
wire [`SINGLE - 1:0] inner_product7;
wire [`SINGLE - 1:0] inner_product9;
wire [`SINGLE - 1:0] inner_product10;
wire [`SINGLE - 1:0] Pm;
wire [`SINGLE - 1:0] Pm_temp;
wire [`SINGLE - 1:0] inv_wm;
wire [`SINGLE - 1:0] theta;
wire [`SINGLE - 1:0] theta_Cal;
wire [`SINGLE - 1:0] Te;
wire [`SINGLE - 1:0] Pref;
wire [`SINGLE - 1:0] P_PM_Cal;
wire [`SINGLE - 1:0] P_PM;
wire [`SINGLE - 1:0] inv_wm_delay;
wire [`SINGLE - 1:0] inner_product6_delay;
wire [`SINGLE - 1:0] inner_product7_delay;
wire [`SINGLE - 1:0]	inner_result4_delay;
wire [`SINGLE - 1:0]	inner_product9_delay;
wire [`EXTENDED_SINGLE - 1:0]  Id_double;
wire [`EXTENDED_SINGLE - 1:0]  Iq_double;
wire [`EXTENDED_SINGLE - 1:0]  Id_double_Cal;
wire [`EXTENDED_SINGLE - 1:0]  Iq_double_Cal;
wire [`EXTENDED_SINGLE - 1:0] wm_temp;

wire [`EXTENDED_SINGLE - 1:0] Tm_starter_pre_a;

wire [`EXTENDED_SINGLE - 1:0] Tm1_temp_double;
wire [`EXTENDED_SINGLE - 1:0] Tm1_temp_stor;
wire [`EXTENDED_SINGLE - 1:0] Tm;

wire done_sig_Tm_temp_312;
wire done_enaread_product6_298;
wire done_enaread_product7_291;
wire done_sig_div32_271;
wire done_enaread_lamda_delay232;	
wire done_sig_add_inst14_241;												  
wire done_sig_diva_175;
wire done_sig_multiplier9_20;
wire done_sig_multiplier10_184;	
wire done_sig_add16_300;
wire done_sig_delay288;
wire done_sig_multiplier293;
wire done_sig_multiplier305;
wire done_sig_ChooserS204;
wire done_sig_double2singlea229;
wire done_sig_lamda1;
wire done_sig_ComparePm307;
wire done_sig_PMSM193;
wire donesig_P_PM;
wire done_sig_finish_wm_double166;
wire done_sig_finish_wm169;
wire done_sig_finish_Idtemp97;
wire done_read_x_outpi163;
wire done_finish_Pref185;
wire done_sig_sub173;		

wire done_ena_read_Idq217;
wire done_ena_read_theta225;
wire done_read_x_PIddd179;
wire done_ena_read_P178;
wire done_readTm_before128;




wire sta_read_Vwind1;
wire sta_Tm_starter_pre_r;
wire [`ADDR_WIDTH_N_WindTurbine - 1:0] addr_Tm_starter_pre_r;
wire pulse_Tm_starter_pre_r;
wire ena_Tm_starter_pre_r;
wire step_Tm_starter_pre_r;
wire ena_cal_Tm_starter_pre_r;
wire sig_output;



			
DELAY_1CLK  #(1) Delay_12A(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_read_x_outpi163),
						               .q(sta_read_Vwind1)
					                  );
	

WindGEN_water  #(32'd250000) WindGEN_water(			 		 		 
			 .clk(clk_sim),
			 .rst(rst_control),
			 .sta(sta_control),
          .sim_time(sim_time),
          			 
			 .VWind(VWind)			
			);
						
WindGEN_water  #(32'd250000) WindGEN_water1(			 		 		 
			 .clk(clk_sim),
			 .rst(rst_control),
			 .sta(sta_read_Vwind1),
          .sim_time(sim_time),
          			 
			 .VWind(VWind1)			
			);

		
/////////////////////////////////////////////////////////////////////////////////

											
ADDR #( `ADDR_WIDTH_N_WindTurbine , `N_WindTurbine , `TIMES_N_WindTurbine , `INI_ADDR_N_WindTurbine ) ADDR_Tm_starter_pre(
																																								.clk(clk_sim),
																																								.rst(rst_control),
																																								.sta(sta_Tm_starter_pre_r),
																																								.addr(addr_Tm_starter_pre_r),
																																								.pulse(pulse_Tm_starter_pre_r),
																																								.ena_mem(ena_Tm_starter_pre_r),
																																								.step(step_Tm_starter_pre_r),
																																								.ena_cal(ena_cal_Tm_starter_pre_r)
																																								 );
																																								 
Tm_starter_pre 	Tm_starter_pre(
													 .aclr(rst_control),
													 .clock(clk_sim),
													 .clken(ena_Tm_starter_pre_r),
													 .address(addr_Tm_starter_pre_r),
													 .rden(ena_cal_Tm_starter_pre_r),
													 .q(Tm_starter_pre_a)
													);
	
		
Dingshi64_water #(32'd2) Dingshi_Tm_starter(
          .clk(clk_sim),			 		 
			 .sim_time(sim_time),
			 .Tm_temp_start(Tm_starter_pre_a), 
          .Tm_temp(Tm1_temp_stor),		 
			 .Tm(Tm)		
			);
			
P_cal_water P_cal1(
              .clk(clk_sim),
				  .rst_user(rst_user),
				  .rst(rst_control),
				  .sta(sta_control),				  
				  .Va(Va),
				  .Vb(Vb),
				  .Vc(Vc),
				  .Ia(Ia_pm_rec),
				  .Ib(Ib_pm_rec),
				  .Ic(Ic_pm_rec),
				  .P(P_PM_Cal),
				  
				  
				  .done_sig(donesig_P_PM)
				 );
/////////////////////////////////////////////Tm_start//////////////////////////////////////////				 

											
System_FIFO_64   FIFO_Tm1_temp(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_readTm_before128),
								.before_enawrite(done_sig),
								.cin( Tm1_temp_double ),
								.cout( Tm1_temp_stor )
							  );
							  
/*		
Dingshi64 #(64'hC09F400000000000,32'd1667) Dingshi1(			 		 
			 .clk(clk_sim),
          .sim_time(sim_time), 			 
          .Tm_temp(Tm1_temp_stor),			 
			 .Tm(Tm)			
			);			
*/			
////////////////////////////////////////////Tm_end///////////////////////////////////////////////
			
PMSM_water  PMSM1(
			 .clk_sim(clk_sim),
			 .rst_control(rst_control),
			 .sta_control(sta_control),
			 .rst_user(rst_user),
			 .sta_user(sta_user),
			 .before_sta_control(before_sta_control),
		    .output_num(output_num),	 
	       .Tm(Tm),
			 .Va(Va),
			 .Vb(Vb),
			 .Vc(Vc),
			 
			 
			 .wm(wm),
			 .wm_temp(wm_temp),
			 .theta(theta_Cal),
			 .Te(Te),
			 .Ia(Ia),
			 .Ib(Ib),
			 
			 .Id_temp(Id_double_Cal),
			 .Iq_temp(Iq_double_Cal),
			 .done_sig_finish_wm_double(done_sig_finish_wm_double166),
          .done_sig_finish_wm(done_sig_finish_wm169),
			 .done_sig_finish_Idtemp(done_sig_finish_Idtemp97),
			 .done_sig_finish_Iab(done_sig_finish_Iab),
			 .done_read_x_outpi(done_read_x_outpi163),
			 .done_readTm_before(done_readTm_before128),
			 .done_read_x127(sta_Tm_starter_pre_r),
          .done_sig_PMSM(done_sig_PMSM193)			 
			);//SFM

 	
MPPT_water MPPT1(			 		 		 
			 .sta_user(sta_user),
			 .sta_control(done_sig_finish_wm169),
			 .rst_control(rst_control),
			 .clk_sim( clk_sim ),
			 .wm(wm), 
          			 
			 .Pref(Pref),
			 .done_finish_Pref(done_finish_Pref185)		 
			);	//SFM		
						
////////////////////below for pitch blade angle and its control----start/////////////////////

DELAY_1CLK  #(7) Delay_finish_wm_double(
										  	.clk(clk_sim),
											.rst(rst_control),
											.d(done_sig_finish_wm_double166),
											.q(done_sig_sub173)
										  );
										  
DELAY_1CLK  #(4) Delay_read_theta(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_ena_read_theta225),
						               .q(done_sig_double2singlea229)
					                  );

														  
////////////////////below for pitch blade angle and its control----end/////////////////////

DELAY_1CLK  #(14) Delay_12a(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_finish_wm169),
						               .q(done_ena_read_P178)
					                  );
System_FIFO_32   FIFO_P_PM(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read_P178),
								.before_enawrite(donesig_P_PM),
								.cin( P_PM_Cal ),
								.cout( P_PM )
							  );
							  
DELAY_1CLK  #(32) Delay_12b(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_finish_Pref185),
						               .q(done_ena_read_Idq217)
					                  );
System_FIFO_64   FIFO_Id_double(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read_Idq217),
								.before_enawrite(done_sig_finish_Idtemp97),
								.cin( Id_double_Cal ),
								.cout( Id_double )
							  );
System_FIFO_64   FIFO_Iq_double(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read_Idq217),
								.before_enawrite(done_sig_finish_Idtemp97),
								.cin( Iq_double_Cal ),
								.cout( Iq_double )
							  );
							  
DELAY_1CLK  #(8) Delay_12c(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_ena_read_Idq217),
						               .q(done_ena_read_theta225)
					                  );
System_FIFO_32   FIFO_theta(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_ena_read_theta225),
								.before_enawrite(done_sig_PMSM193),
								.cin( theta_Cal ),
								.cout( theta )
							  );							  
DELAY_1CLK  #(6) Delay_12f(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_sub173),
						               .q(done_read_x_PIddd179)
					                  );							  

											
RectifierControl_water RectifierControl1(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .sta(done_finish_Pref185),
		    .FLAGFH(FLAGFH),	 
          .sta_user(sta_user),
          .rst_user(rst_user),
          .done_read_x_PIddd1(done_read_x_PIddd179),			 
          .Pref(Pref),
          .P_PM(P_PM),         
          .Id(Id_double),
          .Iq(Iq_double),
          .theta(theta),
          			 
			 
			 .m1_single(m1_single),
			 .m3_single(m3_single),
			 .m5_single(m5_single),
			 .sta_before_m_3clk(sta_before_m_3clk)
			);//SFM
	
////////////////////below for wind turbine//////////////////////
///////below for lamda//////

Divide_nodsp	div32_1(
							  .aclr(rst_control),
							  .clk_en(`ena_math),
							  .clock(clk_sim),
							  .dataa(constone),
							  .datab(VWind1),
							  .result(inv_VWind)								 
							 );
/*							 
divider_control_system  div32_1(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(sta_control),
										.x( constone ),
										.y( VWind ),
										.xy( inv_VWind ),
										.done_sig(done_sig_delay114)
									  );
*/	

wire done_finish_174;
wire done_finish_lamda179;	
								 
multiplier_control_system  multiplier_control_system1111(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_finish_wm169),
					.x(wm),
					.y(constR),
					
					.xy(inner_product1),
					.done_sig(done_finish_174)
					);
multiplier_control_system  multiplier_control_system1(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_finish_174),
					.x(inv_VWind),
					.y(inner_product1),
					
					.xy(lamda),
					.done_sig(done_finish_lamda179)
										  );
										  
///////below for lamda1//////

DELAY_1CLK  #(10) Delay_12p(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_double2singlea229),
						               .q(done_enaread_lamda_delay232)
					                  );
System_FIFO_32   FIFO_lamda_delay1(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_enaread_lamda_delay232),
								.before_enawrite(done_finish_lamda179),
								.cin( lamda ),
								.cout( inner_sum1 )
							  );										 
										  
Divide_nodsp	div32_2(
							  .aclr(rst_control),
							  .clk_en(`ena_math),
							  .clock(clk_sim),
							  .dataa(constone),
							  .datab(inner_sum1),
							  .result(inner_result4)								 
							 );										  	
										  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////									  
								  
					  
Divide_nodsp	div32_3(
							  .aclr(rst_control),
							  .clk_en(`ena_math),
							  .clock(clk_sim),
							  .dataa(const2),
							  .datab(constone),
							  .result(inner_result5)								 
							 );		
										  								  
DELAY_NCLK  #(32,5)  DELAY_NCLKqwe(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(inner_result4),
						               .q(inner_result4_delay)
					                 );
										  
Adder_nodsp	sub13(
						.aclr(rst_control),
						.add_sub(`sub),
						.clk_en(`ena_math),
						.clock(clk_sim),
						.dataa(inner_result4_delay),
						.datab(inner_result5),
						.result(inner_result6)								 
					  );
					  
Divide_nodsp	div32_20(
							  .aclr(rst_control),
							  .clk_en(`ena_math),
							  .clock(clk_sim),
							  .dataa(constone),
							  .datab(inner_result6),
							  .result(lamda1)								 
							 );
							 
DELAY_1CLK #(24) Delay_DONE_S1(
										 .clk(clk_sim),
										 .rst(rst_control),
										 .d(done_sig_add_inst14_241),
										 .q(done_sig_lamda1)
										);
										
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////								 
//////////////below for Pm///////////////
wire [31:0] VWind_delay;	
Multiplier_nodsp_dsp	multiplier_control_system5(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(VWind),
									  .datab(VWind),
									  .result(inner_product222)
									 );
DELAY_NCLK #(32,5) DELAY_NCLK_wind(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(VWind),
						               .q(VWind_delay)
					                 );									 
Multiplier_nodsp_dsp	multiplier_control_system6(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(inner_product222),
									  .datab(VWind_delay),
									  .result(inner_product333)
									 );
									 
Multiplier_nodsp_dsp	multiplier_control_system7(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(const3),
									  .datab(constRow),
									  .result(inner_product444)
									 );
Multiplier_nodsp_dsp	multiplier_control_system8(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(inner_product444),
									  .datab(constAr),
									  .result(inner_product5)
									 );
									 
Multiplier_nodsp_dsp	multiplier_control_system9(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(inner_product5),
									  .datab(inner_product333),
									  .result(inner_product6)
									 );
									 
DELAY_1CLK #(19) Delay_DO111(
										 .clk(clk_sim),
										 .rst(rst_control),
										 .d(sta_control),
										 .q(done_sig_multiplier9_20)
										);									 
	

multiplier_control_system  multiplier_control_system10(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_finish_lamda179),
					.x(lamda),
					.y(const8),
					
					.xy(inner_product7),
					.done_sig(done_sig_multiplier10_184)
										  );

////////////////////////////////////////////////////////////////////////////////////////////////////////////										  									  									 
					  
DELAY_1CLK #(12) Delay_DONE_SIGwq(
										 .clk(clk_sim),
										 .rst(rst_control),
										 .d(done_sig_double2singlea229),
										 .q(done_sig_add_inst14_241)
										);					  										
////////////////////////////////////////////////////////////////////////////////////////////////////////////							
										  									  										  
Divide_nodsp	div32_4(
							  .aclr(rst_control),
							  .clk_en(`ena_math),
							  .clock(clk_sim),
							  .dataa(const116),
							  .datab(lamda1),
							  .result(inner_result7)								 
							 );	
									
Adder_nodsp	sub15(
						.aclr(rst_control),
						.add_sub(`sub),
						.clk_en(`ena_math),
						.clock(clk_sim),
						.dataa(inner_result7),
						.datab(const5),
						.result(inner_result8)								 
					  );									
									
Multiplier_nodsp_dsp	multiplier_control_system12(
									  .aclr(rst_control),
									  .clk_en(`ena_math),
									  .clock(clk_sim),
									  .dataa(inner_result8),
									  .datab(const4),
									  .result(inner_product9)
									 );
									 								  
DELAY_NCLK  #(32,5)  DELAY_NCLKrty(
						               .clk(clk_sim),
											.rst(rst_control),
						               .d(inner_product9),
						               .q(inner_product9_delay)
					                 );
										  

divider_control_system  div32_5(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_lamda1),
										.x( const7 ),
										.y( lamda1 ),
										.xy( inner_result9 ),
										.done_sig(done_sig_div32_271)
									  );										  
exp_control_system  exp32_2(
								  .clk(clk_sim),
					           .rst(rst_control),
								  .sta(done_sig_div32_271),
								  .x( inner_result9 ),
								  .y( inner_result10 ),
								  .done_sig(done_sig_delay288)
								  );										  


multiplier_control_system  multiplier_control_system13(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay288),
					.x(inner_result10),
					.y(inner_product9_delay),
					
					.xy(inner_product10),
					.done_sig(done_sig_multiplier293)
					);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DELAY_1CLK  #(3) Delay_12i(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_delay288),
						               .q(done_enaread_product7_291)
					                  );
									
System_FIFO_32   FIFO_inner_product7_delay(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_enaread_product7_291),
								.before_enawrite(done_sig_multiplier10_184),
								.cin( inner_product7 ),
								.cout( inner_product7_delay )
							  );


					
adder_control_system add_inst16(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier293),
									 .add_sub(`add),
									 .x(inner_product7_delay),
									 .y(inner_product10),
									 .xy(inner_result11),
									 .done_sig(done_sig_add16_300)
								   );					
							 
DELAY_1CLK  #(5) Delay_12o(
						               .clk(clk_sim),
						               .rst(rst_control),
						               .d(done_sig_multiplier293),
						               .q(done_enaread_product6_298)
					                  );
									
System_FIFO_32   FIFO_inner_product6_delay(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_enaread_product6_298),
								.before_enawrite(done_sig_multiplier9_20),
								.cin( inner_product6 ),
								.cout( inner_product6_delay )
							  );
							  
multiplier_control_system  multiplier_control_system14(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_add16_300),
					.x(inner_result11),
					.y(inner_product6_delay),
					
					.xy(Pm_temp),
					.done_sig(done_sig_multiplier305)
										  );
ComparePm_water  ComparePm1(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_multiplier305),
			 .x(Pm_temp),
			 					 
			 .y(Pm),
			 .done_sig(done_sig_ComparePm307)
		   );
////////////////////below for Tm1_temp_stor/////////////////

divider_control_system  div32_6(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_finish_wm169),
										.x( constone ),
										.y( wm ),
										.xy( inv_wm ),
										.done_sig(done_sig_diva_175)
									  );
									  
									
System_FIFO_32   FIFO_inv_wm_delay(
								.clk( clk_sim ),
								.rst(rst_control),
								.rst_user(rst_user),
								.before_enaread(done_sig_multiplier305),
								.before_enawrite(done_sig_diva_175),
								.cin( inv_wm ),
								.cout( inv_wm_delay )
							  );									 									 
										 
multiplier_control_system  multiplier_control_system15(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_ComparePm307),
					.x(Pm),
					.y(inv_wm_delay),
					
					.xy(Tm_temp),
					.done_sig(done_sig_Tm_temp_312)
										  );											 
									  
assign Tm1_temp = {~Tm_temp[`SINGLE - 1],Tm_temp[`SINGLE - 2:0]};

convert_single_to_double_control_system  single2float_abc(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_Tm_temp_312),
															  .x(Tm1_temp),
															  .y(Tm1_temp_double),
															  .done_sig(done_sig)
															  );
															  
/*for observing control variable_Tm*/
wire [`SINGLE - 1:0] Tm_Observe,Tm_single;
wire [5:0] addr_write_Tm;
wire sta_wren_Tm,ena_cal_write_Tm,sta_convert,done_sig_double2single_Tm;
wire ena_write_Tm,rden_Tm;
wire pulse_write_Tm;
wire step_write_Tm;

DELAY_1CLK #(3) Delay_sta_wren_Tm_dd(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(done_readTm_before128),
										  .q(sta_convert)
              );
				  
convert_double_to_single_control_system   double2single_Tm(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(sta_convert),
															  .x(Tm),
															  .y(Tm_single),
															  .done_sig(done_sig_double2single_Tm)
															  );
															  
DELAY_1CLK #(2) Delay_sta_wren_Tm(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(sta_convert),
										  .q(sta_wren_Tm)
              );
				  
DELAY_1CLK #(50) Delay_read_Tm(
										  .clk(clk_sim),
										  .rst(rst_control),
										  .d(sta_convert),
										  .q(rden_Tm)
              );
				  
ADDR #( 6 , `N_WindTurbine , 1 , 1'b0 ) ADDR1111(
																.clk(clk_sim),
																.rst(rst_control),
																.sta(sta_wren_Tm), 
																.addr(addr_write_Tm),
																.pulse(pulse_write_Tm),
																.ena_mem(ena_write_Tm),
																.step(step_write_Tm),
																.ena_cal(ena_cal_write_Tm)
																);

Observe_Control_Variable	Observe_Tm (
	.aclr ( rst_control ),
	.clock ( clk_sim ),
	.data ( Tm_single ),
	.enable ( 1'b1 ),
	.rdaddress ( output_num[5:0] ),
	.rden ( rden_Tm ),
	.wraddress ( addr_write_Tm ),
	.wren ( ena_cal_write_Tm ),
	.q ( Tm_Observe )
	);
								  										 

output_signal output_signal(
									 .clk(clk_sim),
									 .rst_user(rst_user),
									 .exchange_data_sig(done_sig_Tm_temp_312),
									 .sig_output(sig_output)
									);								



								
				
endmodule						
						
