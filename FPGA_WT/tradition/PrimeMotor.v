`include "../parameter/global_parameter.v"

module PrimeMotor(
			 clk_sim,
			 sta_user,
			 rst_user,
			 rst_control,
			 sta_control,
			 control_valuation_sig,
          sim_time,			 
			 Va,
			 Vb,
			 Vc,		 
			 Ia_pm_rec,
			 Ib_pm_rec,
          Ic_pm_rec,
			
			 m1,
			 m2,
			 m3,
			 m4,
			 m5,
			 m6,
			 Ia,
			 Ib,
			 //Ic,
			 done_sig_outputm1m2,
			 done_sig
			);
//constwbase is 20.42035225
parameter constwbase = 64'h40346B9C347E8CCE;
//constRow is 1.08
parameter constRow = 32'h3F8A3D71;
//constAr is 95.94
parameter constAr = 32'h42BFE148;
//constR is 5.53
parameter constR = 32'h40B0F5C3;
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
		
input clk_sim;
input rst_control;
input sta_control;
input rst_user;
input sta_user;
input control_valuation_sig;
input [`WIDTH_TIME - 1:0] sim_time;

input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] Ia_pm_rec;
input [`SINGLE - 1:0] Ib_pm_rec;
input [`SINGLE - 1:0] Ic_pm_rec;


output [`SINGLE - 1:0] Ia;
output [`SINGLE - 1:0] Ib;
//output [`SINGLE - 1:0] Ic;
output m1;
output m2;
output m3;
output m4;
output m5;
output m6;
output done_sig;
output wire done_sig_outputm1m2;


wire [`SINGLE - 1:0] wm;
wire [`SINGLE - 1:0] Tm;
wire [`SINGLE - 1:0] VWind;
wire [`SINGLE - 1:0] inv_VWind;
wire [`EXTENDED_SINGLE - 1:0] wm_temp;
wire [`EXTENDED_SINGLE - 1:0] inner_result1;
wire [`EXTENDED_SINGLE - 1:0] inner_result2_temp;
wire [`EXTENDED_SINGLE - 1:0] inner_result2;
wire [`EXTENDED_SINGLE - 1:0] inner_result3;
wire [`EXTENDED_SINGLE - 1:0] beta_temp;
wire [`EXTENDED_SINGLE - 1:0] beta_temp1;
wire [`SINGLE - 1:0] lamda;
wire [`SINGLE - 1:0] lamda1;
wire [`SINGLE - 1:0] inner_product1;
wire [`SINGLE - 1:0] beta;
wire [`SINGLE - 1:0] Tm1_temp;
wire [`SINGLE - 1:0] Tm_temp;
wire [`SINGLE - 1:0] inner_sum1;
wire [`SINGLE - 1:0] inner_sum2;
wire [`SINGLE - 1:0] inner_result4;
wire [`SINGLE - 1:0] inner_product2;
wire [`SINGLE - 1:0] inner_product3;
wire [`SINGLE - 1:0] inner_product4;
wire [`SINGLE - 1:0] inner_sum3;
wire [`SINGLE - 1:0] inner_result5;
wire [`SINGLE - 1:0] inner_result6;
wire [`SINGLE - 1:0] inner_result7;
wire [`SINGLE - 1:0] inner_result8;
wire [`SINGLE - 1:0] inner_result9;
wire [`SINGLE - 1:0] inner_result10;
wire [`SINGLE - 1:0] inner_result11;
wire [`SINGLE - 1:0] Tm1_temp_stor;
wire [`SINGLE - 1:0] inner_product222;
wire [`SINGLE - 1:0] inner_product333;
wire [`SINGLE - 1:0] inner_product444;
wire [`SINGLE - 1:0] inner_product5;
wire [`SINGLE - 1:0] inner_product6;
wire [`SINGLE - 1:0] inner_product7;
wire [`SINGLE - 1:0] inner_product8;
wire [`SINGLE - 1:0] inner_product9;
wire [`SINGLE - 1:0] inner_product10;
wire [`SINGLE - 1:0] Pm;
wire [`SINGLE - 1:0] Pm_temp;
wire [`SINGLE - 1:0] inv_wm;
wire [`SINGLE - 1:0] theta;
wire [`SINGLE - 1:0] Te;
wire [`EXTENDED_SINGLE - 1:0]  Id_double;
wire [`EXTENDED_SINGLE - 1:0]  Iq_double;
wire [`SINGLE - 1:0] Pref;
wire [`SINGLE - 1:0] P_PM;
wire [`EXTENDED_SINGLE - 1:0] wm_starter;

wire beta_flag;
wire done_sig_MPPT;
wire done_sig_multiplier5;
wire done_sig_multiplier6;
wire done_sig_multiplier7;
wire done_sig_multiplier8;
wire done_sig_multiplier9;
wire done_sig_multiplier10;	
wire done_sig_multiplier11;
wire done_sig_multiplier12;
wire done_sig_add15;
wire done_sig_add16;
wire done_sig_delay118;
wire done_sig_multiplier13;
wire done_sig_multiplier15;
wire done_sig_multiplier14;
wire done_sig_PID1;
wire done_sig_PID2;
wire done_sig_ChooserS;
wire done_sig_threshold;
wire done_sig_threshold2;
wire done_sig_double2singlea2;
wire done_sig_multiplier0;
wire done_sig_delay114;
wire done_sig_multiplier2;
wire done_sig_div32_2;
wire done_sig_multiplier3;
wire done_sig_multiplier4;
wire done_sig_div32_3;
wire done_sig_lamda1;
wire done_sig_ComparePm1;
wire 	done_sig_PMSM;
wire done_sig_RectifierControl;
wire donesig_P_PM;
wire done_sig_finish_wm_double;
wire done_sig_finish_wm;
wire done_sig_finish_Idtemp;

Dingshi #(32'hC4FA0000,32'd1667) Dingshi1(			 		 
			 .clk(clk_sim),
          .sim_time(sim_time), 			 
          .Tm_temp(Tm1_temp_stor),			 
			 .Tm(Tm)			
			);

Dingshi64 #(64'h40346B851EB851EC,32'd1667) Dingshi21(
          .clk(clk_sim),			 		 
			 .sim_time(sim_time),  
          .Tm_temp(64'h0000000000000000),			 
			 .Tm(wm_starter)			
			);
			
WindGEN #(32'd666667,32'd1333333,32'h411B3333,32'h41280000,32'h41280000) WindGEN1(			 		 		 
			 .clk(clk_sim),
          .sim_time(sim_time),           			 
			 .VWind(VWind)			
			);
P_cal P_cal1(
				  .clk(clk_sim),
				  .rst_user(rst_user),
				  .rst(rst_control),
				  .sta(sta_control),
				  .control_valuation_sig(control_valuation_sig),
				  .Va(Va),
				  .Vb(Vb),
				  .Vc(Vc),
				  .Ia(Ia_pm_rec),
				  .Ib(Ib_pm_rec),
				  .Ic(Ic_pm_rec),
				  .P(P_PM),
				  
				  .done_sig(donesig_P_PM)
				 );	
				 
		
PMSM  PMSM1(
			 .clk_sim(clk_sim),
			 .rst_control(rst_control),
			 .sta_control(sta_control),
			 .rst_user(rst_user),
			 .sta_user(sta_user),
			 .control_valuation_sig(control_valuation_sig), 	
	       .Tm(Tm),
			 .Va(Va),
			 .Vb(Vb),
			 .Vc(Vc),
			 .wm_starter(wm_starter),
			 
			 .wm(wm),
			 .wm_temp(wm_temp),
			 .theta(theta),
			 .Te(Te),
			 .Ia(Ia),
			 .Ib(Ib),
			 //.Ic(Ic),
			 .Id_temp(Id_double),
			 .Iq_temp(Iq_double),
			 .done_sig_finish_wm_double(done_sig_finish_wm_double),
          .done_sig_finish_wm(done_sig_finish_wm),
			 .done_sig_finish_Idtemp(done_sig_finish_Idtemp),
          .done_sig_PMSM(done_sig_PMSM)			 
			);


 	
MPPT MPPT1(			 		 		 
			 .sta_user(sta_user),
			 .sta_control(done_sig_finish_wm),
			 .rst_control(rst_control),
			 .clk_sim( clk_sim ),
			 .wm(wm), 
          			 
			 .Pref(Pref),
	       .beta_flag(beta_flag),
	       .done_sig_MPPT(done_sig_MPPT)		 
			);			
						
////////////////////below for pitch blade angle and its control----start/////////////////////

wire done_sig_sub1;		

		
ADD_SUB_64_MODULE	SUB1(
          .sta(done_sig_finish_wm_double),
	       .rst_control(rst_control),
			 .add_sub(`sub),
			 .clk(clk_sim),
			 .dataa(wm_temp),
			 .datab(constwbase),
			 .result(inner_result1),
			 .done_sig(done_sig_sub1)
										 );
      
PI_limit64 #(64'h3FE0000000000000,64'h3EEF75104D551D69,64'h403B000000000000,64'h4000000000000000)PI1(
					 .clk(clk_sim),
			       .rst(rst_control),
			       .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(done_sig_sub1),
					 .x(inner_result1),
						  
					 .y(inner_result2),
					 .done_sig(done_sig_threshold)
					);	//30						
/*							
PI64 #(64'h3FE000346DC5D639,64'hBFDFFF972474538F) PI1(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_sub1),
			 .control_valuation_sig(control_valuation_sig),
			 .x(inner_result1),
			 .y(inner_result2_temp),
			 .done_sig(done_sig_PID1)
		   );										 
										 
threshold64 threshold1(
					  .clk(clk_sim),
					  .rst(rst_control),
					  .sta(done_sig_PID1),
					  .x(inner_result2_temp),
					  .y(inner_result2),				  
					  .done_sig(done_sig_threshold)
					 );
*/							 
										 
ChooserSwitch64  ChooserSwitch64_1(			 		 		 
			 .rst_user(rst_user),
			 .clk(clk_sim),
			 .beta_flag(beta_flag),
			 .sta(done_sig_threshold),
			 .rst(rst_control),
			 .datain1(consttwo),
			 .datain2(inner_result2),
			 			            			 
			 .dataout(inner_result3),
	       .done_sig_ChooserS(done_sig_ChooserS)		 
			);
			
PID_initial_threshold64 #(64'h3EEF74F160D94856,64'h3EEF74F160D94856,64'h3FEFFFC116241D85,64'h3FF0000000000000,64'h403B000000000000,64'h4000000000000000)PID2(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_ChooserS),
			 .control_valuation_sig(control_valuation_sig),
			 .x(inner_result3),
			
			 .y(beta_temp1),				  
			 .done_sig(done_sig_threshold2)
		   );//23
/*			
PID_Initial64 #(64'h3EFA36B7F858913A,64'h3EFA36B7F858913A,64'h3FEFFF97251940CE,64'h3FF0000000000000) PID2(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_ChooserS),
			 .control_valuation_sig(control_valuation_sig),
			 .x(inner_result3),
			 .y(beta_temp),
			 .done_sig(done_sig_PID2)
		   );	
threshold64 threshold2(
					  .clk(clk_sim),
					  .rst(rst_control),
					  .sta(done_sig_PID2),
					  .x(beta_temp),
					  .y(beta_temp1),				  
					  .done_sig(done_sig_threshold2)
					 );
*/
convert_double_to_single_control_system   double2single_a2(
                                               .clk(clk_sim),
															  .rst(rst_control),
															  .sta(done_sig_threshold2),
															  .x(beta_temp1),
															  .y(beta),
															  .done_sig(done_sig_double2singlea2)
															  );										 
////////////////////below for pitch blade angle and its control----end/////////////////////

RectifierControl RectifierControl1(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .sta(done_sig_MPPT),
			 .sta_Idtemp(done_sig_finish_Idtemp),
          .sta_theta(done_sig_PMSM),			 
          .sta_user(sta_user),
          .rst_user(rst_user),
          .control_valuation_sig(control_valuation_sig),	     
          .Pref(Pref),
          .P_PM(P_PM),         
          .Id(Id_double),
          .Iq(Iq_double),
          .theta(theta),
          .wm(wm),			 
			 
			 .m1(m1),
			 .m2(m2),
			 .m3(m3),
			 .m4(m4),
			 .m5(m5),
			 .m6(m6),
			 .done_sig(done_sig_RectifierControl)
			);

assign done_sig_outputm1m2 = done_sig_RectifierControl;	
////////////////////below for wind turbine//////////////////////
///////below for lamda//////
	
divider_control_system  div32_1(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(sta_control),
										.x( constone ),
										.y( VWind ),
										.xy( inv_VWind ),
										.done_sig(done_sig_delay114)
									  );	
multiplier_control_system_dsp  multiplier_control_system0(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_finish_wm),
					.x(wm),
					.y(constR),
					
					.xy(inner_product1),
					.done_sig(done_sig_multiplier0)
										  );
wire done_sig_multiplier1;										  
multiplier_control_system_dsp  multiplier_control_system1(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier0),
					.x(inv_VWind),
					.y(inner_product1),
					
					.xy(lamda),
					.done_sig(done_sig_multiplier1)
										  );
///////below for lamda1//////

multiplier_control_system_dsp  multiplier_control_system2(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_double2singlea2),
					.x(beta),
					.y(const1),
					
					.xy(inner_product2),
					.done_sig(done_sig_multiplier2)
										  );
										  
wire done_sig_add_inst11;
										  
adder_control_system add_inst11(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier2),
									 .add_sub(`add),
									 .x(inner_product2),
									 .y(lamda),
									 .xy(inner_sum1),
									 .done_sig(done_sig_add_inst11)
								   );		
										  
divider_control_system  div32_2(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_add_inst11),
										.x( constone ),
										.y( inner_sum1 ),
										.xy( inner_result4 ),
										.done_sig(done_sig_div32_2)
									  );											  									 

										 
multiplier_control_system_dsp  multiplier_control_system3(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_double2singlea2),
					.x(beta),
					.y(beta),
					
					.xy(inner_product3),
					.done_sig(done_sig_multiplier3)
										  );
multiplier_control_system_dsp  multiplier_control_system4(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier3),
					.x(inner_product3),
					.y(beta),
					
					.xy(inner_product4),
					.done_sig(done_sig_multiplier4)
										  );
										  
	
wire 	done_sig_add_inst12;
	
adder_control_system add_inst12(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier4),
									 .add_sub(`add),
									 .x(constone),
									 .y(inner_product4),
									 .xy(inner_sum2),
									 .done_sig(done_sig_add_inst12)
								   );		
										  
divider_control_system  div32_3(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_add_inst12),
										.x( const2 ),
										.y( inner_sum2 ),
										.xy( inner_result5 ),
										.done_sig(done_sig_div32_3)
									  );

										 
wire 	done_sig_sub13;
	
adder_control_system sub13(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_div32_3),
									 .add_sub(`sub),
									 .x(inner_result4),
									 .y(inner_result5),
									 .xy(inner_result6),
									 .done_sig(done_sig_sub13)
								   );		
										  
divider_control_system  div32_20(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_sub13),
										.x( constone ),
										.y( inner_result6 ),
										.xy( lamda1 ),
										.done_sig(done_sig_lamda1)
									  );
								 
//////////////below for Pm///////////////	

							 
multiplier_control_system_dsp  multiplier_control_system5(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(sta_control),
					.x(VWind),
					.y(VWind),
					
					.xy(inner_product222),
					.done_sig(done_sig_multiplier5)
										  );
multiplier_control_system_dsp  multiplier_control_system6(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier5),
					.x(inner_product222),
					.y(VWind),
					
					.xy(inner_product333),
					.done_sig(done_sig_multiplier6)
										  );	

multiplier_control_system_dsp  multiplier_control_system7(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(sta_control),
					.x(const3),
					.y(constRow),
					
					.xy(inner_product444),
					.done_sig(done_sig_multiplier7)
										  );
multiplier_control_system_dsp  multiplier_control_system8(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier7),
					.x(inner_product444),
					.y(constAr),
					
					.xy(inner_product5),
					.done_sig(done_sig_multiplier8)
										  );	

multiplier_control_system_dsp  multiplier_control_system9(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier8),
					.x(inner_product5),
					.y(inner_product333),
					
					.xy(inner_product6),
					.done_sig(done_sig_multiplier9)
										  );

multiplier_control_system_dsp  multiplier_control_system10(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier1),
					.x(lamda),
					.y(const8),
					
					.xy(inner_product7),
					.done_sig(done_sig_multiplier10)
										  );

										  
multiplier_control_system_dsp  multiplier_control_system11(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_double2singlea2),
					.x(beta),
					.y(const6),
					
					.xy(inner_product8),
					.done_sig(done_sig_multiplier11)
										  );
////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
wire done_sig_add_inst14;
	
adder_control_system add_inst14(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier11),
									 .add_sub(`add),
									 .x(inner_product8),
									 .y(const5),
									 .xy(inner_sum3),
									 .done_sig(done_sig_add_inst14)
								   );		
wire done_sig_div32_4;										  
divider_control_system  div32_4(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_lamda1),
										.x( const116 ),
										.y( lamda1 ),
										.xy( inner_result7 ),
										.done_sig(done_sig_div32_4)
									  );										  										  
	
adder_control_system sub15(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_div32_4),
									 .add_sub(`sub),
									 .x(inner_result7),
									 .y(inner_sum3),
									 .xy(inner_result8),
									 .done_sig(done_sig_add15)
								   );		
									

multiplier_control_system_dsp  multiplier_control_system12(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_add15),
					.x(inner_result8),
					.y(const4),
					
					.xy(inner_product9),
					.done_sig(done_sig_multiplier12)
										  );

wire done_sig_div32_5;
divider_control_system  div32_5(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_lamda1),
										.x( const7 ),
										.y( lamda1 ),
										.xy( inner_result9 ),
										.done_sig(done_sig_div32_5)
									  );										  
exp_control_system  exp32_2(
								  .clk(clk_sim),
					           .rst(rst_control),
								  .sta(done_sig_div32_5),
								  .x( inner_result9 ),
								  .y( inner_result10 ),
								  .done_sig(done_sig_delay118)
								  );										  


multiplier_control_system_dsp  multiplier_control_system13(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_delay118),
					.x(inner_result10),
					.y(inner_product9),
					
					.xy(inner_product10),
					.done_sig(done_sig_multiplier13)
					);
					
adder_control_system add_inst16(
									 .clk(clk_sim),
									 .rst(rst_control),
									 .sta(done_sig_multiplier13),
									 .add_sub(`add),
									 .x(inner_product7),
									 .y(inner_product10),
									 .xy(inner_result11),
									 .done_sig(done_sig_add16)
								   );					
							 
										 
multiplier_control_system_dsp  multiplier_control_system14(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_add16),
					.x(inner_result11),
					.y(inner_product6),
					
					.xy(Pm_temp),
					.done_sig(done_sig_multiplier14)
										  );
ComparePm  ComparePm1(
			 .clk(clk_sim),
			 .rst(rst_control),
			 .rst_user(rst_user),
			 .sta(done_sig_multiplier14),
			 .x(Pm_temp),
			 					 
			 .y(Pm),
			 .done_sig(done_sig_ComparePm1)
		   );
////////////////////below for Tm1_temp_stor/////////////////

wire done_sig_div32_6;
divider_control_system  div32_6(
										.clk( clk_sim ),
										.rst(rst_control),
										.sta(done_sig_PMSM),
										.x( constone ),
										.y( wm ),
										.xy( inv_wm ),
										.done_sig(done_sig_div32_6)
									  );
									 									 
										 
multiplier_control_system_dsp  multiplier_control_system15(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_ComparePm1),
					.x(Pm),
					.y(inv_wm),
					
					.xy(Tm_temp),
					.done_sig(done_sig_multiplier15)
										  );											 
										 
multiplier_control_system_dsp  multiplier_control_system16(
					.clk(clk_sim),
					.rst(rst_control),
					.sta(done_sig_multiplier15),
					.x(Tm_temp),
					.y(const9),
					
					.xy(Tm1_temp),
					.done_sig(done_sig)
										  );											 
System_partition Storage_v1(
									.clk(clk_sim),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(Tm1_temp),
									.cout(Tm1_temp_stor)
								  );
										  										  
										  										 
										 
				
endmodule						
						
