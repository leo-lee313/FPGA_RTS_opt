`include "../parameter/global_parameter.v"

module InverterControl(
			 clk,
			 rst,
			 sta,        
          sta_user,
          rst_user,
          control_valuation_sig,		 
          Vdc,
         
          V3a,
          V3b,
          V3c,
          I3a,
          I3b,
          I3c,			 
			 
			 g1,
			 g2,
			 g3,
			 g4,
			 g5,
			 g6,
			 done_sig
			);
input clk;
input rst;
input rst_user;
input sta;
input sta_user;
input control_valuation_sig;

input [`SINGLE - 1:0] Vdc;

input [`SINGLE - 1:0] V3a;
input [`SINGLE - 1:0] V3b;
input [`SINGLE - 1:0] V3c;
input [`SINGLE - 1:0] I3a;
input [`SINGLE - 1:0] I3b;
input [`SINGLE - 1:0] I3c;
/*
parameter P3 = 32'h3CF5C28F;//0.03
parameter Q3 = 32'h3C75C28F;//0.015
parameter V3a = 32'h3E9EB852;//0.31
parameter V3b = 32'h3E9EB852;//0.31
parameter V3c = 32'h3E9EB852;//0.31
parameter I3a = 32'h3D84039B;//0.06446
parameter I3b = 32'h3D84039B;//0.06446
parameter I3c = 32'h3D84039B;//0.06446
*/
output g1;
output g2;
output g3;
output g4;
output g5;
output g6;
output done_sig;

wire [`SINGLE - 1:0] Va;
wire [`SINGLE - 1:0] Vb;
wire [`SINGLE - 1:0] Vc;
wire [`SINGLE - 1:0] Ia;
wire [`SINGLE - 1:0] Ib;
wire [`SINGLE - 1:0] Ic;
wire [`SINGLE - 1:0] Id;
wire [`SINGLE - 1:0] Iq;
//wire [`SINGLE - 1:0] Vdc1;
wire [`SINGLE - 1:0] Q3;
wire [`SINGLE - 1:0] Q;
wire [`SINGLE - 1:0] sin;
wire [`SINGLE - 1:0] cos;
wire [`SINGLE - 1:0] frequence;
wire [`SINGLE - 1:0] theta;			  						 						 						  
wire [`SINGLE - 1:0] ma;
wire [`SINGLE - 1:0] mb;
wire [`SINGLE - 1:0] mc;
wire [`SINGLE - 1:0] triangle_out;
wire [`SINGLE - 1:0] idref_single;
wire [`SINGLE - 1:0] iqref_single;
wire [`SINGLE - 1:0] vdref;
wire [`SINGLE - 1:0] vqref;

wire [`EXTENDED_SINGLE - 1:0] Vdc1_temp;
wire [`EXTENDED_SINGLE - 1:0] Q_temp;
wire [`EXTENDED_SINGLE - 1:0] Id_temp;
wire [`EXTENDED_SINGLE - 1:0] Iq_temp;	
wire [`EXTENDED_SINGLE - 1:0] iqref1;
wire [`EXTENDED_SINGLE - 1:0] idref1;
wire [`EXTENDED_SINGLE - 1:0] iqref;
wire [`EXTENDED_SINGLE - 1:0] idref;
wire [`EXTENDED_SINGLE - 1:0] vdref_temp;
wire [`EXTENDED_SINGLE - 1:0] vqref_temp;
wire [`EXTENDED_SINGLE - 1:0] vdref1;
wire [`EXTENDED_SINGLE - 1:0] vqref1;

wire done_sig_threshold13;
wire done_sig_threshold14;
wire done_sig_multiplierVa;
wire done_sig_multiplierVb;
wire done_sig_multiplierVc;
wire done_sig_multiplierIa;
wire done_sig_multiplierIb;
wire done_sig_multiplierIc;
//wire done_sig_multiplierVdc;
wire done_sig_multiplierQ;
wire done_sig_PLL;
wire done_sig_abc2dq0;
wire done_sig_dq02abc;
wire done_sig_control_loop1;
wire done_sig_PWM;
wire done_sig_comparator_ma;
wire done_sig_comparator_mb;
wire sig_start_pwm;
wire done_sig_multiplierSingle2Float;
wire done_sig_control_loopp;
wire done_sig_threshold113;
wire done_sig_threshold114;
wire done_sig_multiplierdouble2single1124;
wire donesig_Q3;


parameter const_inv_Vbase = 32'h3C23D70A;//0.01
parameter const_inv_Ibase = 32'h3C7E2C10;//0.01551343504
parameter const_inv_Sbase = 32'h380BCF65;//1/30000
parameter const_Vdcref = 64'h407F400000000000;//500V
parameter const_Qref = 64'h0000000000000000;
parameter const_onethousand = 32'h447A0000;

multiplier_control_system_dsp  multiplier_control_system0(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(V3a),
					.y(const_inv_Vbase),
					
					.xy(Va),
					.done_sig(done_sig_multiplierVa)
										  );

multiplier_control_system_dsp  multiplier_control_system1(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(V3b),
					.y(const_inv_Vbase),
					
					.xy(Vb),
					.done_sig(done_sig_multiplierVb)
										  );
multiplier_control_system_dsp  multiplier_control_system2(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(V3c),
					.y(const_inv_Vbase),
					
					.xy(Vc),
					.done_sig(done_sig_multiplierVc)
										  );

multiplier_control_system_dsp  multiplier_control_system3(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(I3a),
					.y(const_inv_Ibase),
					
					.xy(Ia),
					.done_sig(done_sig_multiplierIa)
										  );

multiplier_control_system_dsp  multiplier_control_system4(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(I3b),
					.y(const_inv_Ibase),
					
					.xy(Ib),
					.done_sig(done_sig_multiplierIb)
										  );
multiplier_control_system_dsp  multiplier_control_system5(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(I3c),
					.y(const_inv_Ibase),
					
					.xy(Ic),
					.done_sig(done_sig_multiplierIc)
										  );
/*
multiplier_control_system  multiplier_control_system6(
					.clk(clk),
					.rst(rst),
					.sta(sta),
					.x(Vdc),
					.y(const_onethousand),
					
					.xy(Vdc1),
					.done_sig(done_sig_multiplierVdc)
										  );
*/										  
///////////////////////////////////////////////////////////////////										  
Q_cal Q_cal1(
				  .clk(clk),
				  .rst(rst),
				  .sta(sta),
				  .Va(V3a),
				  .Vb(V3b),
				  .Vc(V3c),
				  .Ia(I3a),
				  .Ib(I3b),
				  .Ic(I3c),
				  
				  .Q(Q3),
				  
				  .done_sig(donesig_Q3)
				 );										  

wire [`SINGLE - 1:0] P3;		
wire donesig_P3;
		 
P_cal_filterless   P_cal1(
				  .clk(clk),
				  .rst(rst),
				  .sta(sta),
				  .Va(V3a),
				  .Vb(V3b),
				  .Vc(V3c),
				  .Ia(I3a),
				  .Ib(I3b),
				  .Ic(I3c),
				  .P(P3),
				  
				  .done_sig(donesig_P3)
				 );
				 
multiplier_control_system_dsp  multiplier_control_system7(
					.clk(clk),
					.rst(rst),
					.sta(donesig_Q3),
					.x(Q3),
					.y(const_inv_Sbase),
					
					.xy(Q),
					.done_sig(done_sig_multiplierQ)
										  );
///////////////////////////////////////////////////////////////////////										  
PLL_control_system  PLL(
			      .clk(clk),
					.sta(done_sig_multiplierVc),
					.rst(rst),
					.rst_user(rst_user),
					.control_valuation_sig(control_valuation_sig),
					.Va(Va),
					.Vb(Vb),
					.Vc(Vc),
					.cos(cos),
					.sin(sin),					
					.frequence(frequence),
					.theta(theta),			
					.done_sig(done_sig_PLL)
			                );										  

abc2dq0  abc2dq01(
					.clk(clk),
					.rst(rst),
					.sta(done_sig_PLL),
					.Va(Ia),
					.Vb(Ib),
					.Vc(Ic),
					.sin_theta(sin),
					.cos_theta(cos),
					
					.Vd(Id),
					.Vq(Iq),
					.done_sig(done_sig_abc2dq0)
				  );				  
////////////////////////////////////////////////////////////////////
convert_single_to_double_control_system  single2float_1(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_abc2dq0),
															  .x(Vdc),
															  .y(Vdc1_temp),
															  .done_sig(done_sig_multiplierSingle2Float)
															  );
wire done_sig_multiplierSingle2Float1;
			  
convert_single_to_double_control_system  single2float2(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_abc2dq0),
															  .x(Q),
															  .y(Q_temp),
															  .done_sig(done_sig_multiplierSingle2Float1)
															  );
															 
wire done_sig_multiplierSingle2Float2;
			  
convert_single_to_double_control_system  single2float3(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_abc2dq0),
															  .x(Id),
															  .y(Id_temp),
															  .done_sig(done_sig_multiplierSingle2Float2)
															  );															 	
wire done_sig_multiplierSingle2Float3;
			  
convert_single_to_double_control_system  single2float4(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_abc2dq0),
															  .x(Iq),
															  .y(Iq_temp),
															  .done_sig(done_sig_multiplierSingle2Float3)
															  );
////////////////////////////////////////////////////////////////////////////////////////////////////////
wire [`EXTENDED_SINGLE - 1:0] dPddd3;
wire [`EXTENDED_SINGLE - 1:0] diqqq3;
wire donesig_Adder_inner_resultddd3;
wire donesig_Adder_inner_resultqqq3;
ADD_SUB_64_MODULE   Adder_inner_resultddd3(

			 .sta(done_sig_multiplierSingle2Float),
			 .rst_control(rst),
			 .add_sub(`sub),
			 .clk(clk),
			 .dataa(Vdc1_temp),			 			 			 
			 .datab(const_Vdcref),
			 
			 .result(dPddd3),
			 .done_sig(donesig_Adder_inner_resultddd3)
		   );	

ADD_SUB_64_MODULE   Adder_inner_resultqqq3(

			 .sta(done_sig_multiplierSingle2Float),
			 .rst_control(rst),
			 .add_sub(`sub),
			 .clk(clk),
			 .dataa(Q_temp),			 			 			 
			 .datab(const_Qref),
			 
			 .result(diqqq3),
			 .done_sig(donesig_Adder_inner_resultqqq3)
		   );	


PI_limit64 #(64'h3F847AE147AE147B,64'h3E7421F5F40D8376,64'h3FF8000000000000,64'hBFF8000000000000)PIddd1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(donesig_Adder_inner_resultddd3),
					 .x(dPddd3),
						  
					 .y(idref),
					 .done_sig(done_sig_threshold14)
					);

PI_limit64 #(64'h3FB999999999999A,64'h3EDF75104D551D69,64'h3FF8000000000000,64'hBFF8000000000000)PIqqq1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(donesig_Adder_inner_resultqqq3),
					 .x(diqqq3),
						  
					 .y(iqref),
					 .done_sig(done_sig_threshold13)
					);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


														
														
/*								
control_loop1_64 #(64'h3F847AF20EA5B531,64'hBF847AD080B673C5,64'h3FB99A6B50B0F27C,64'hBFB998C7E28240B8)control_loopp(
                    .clk(clk),
						  .rst(rst),
						  .rst_user(rst_user),
                    .control_valuation_sig(control_valuation_sig),						  
						  .sta(done_sig_multiplierSingle2Float),
						  .input_1(Vdc1_temp),
						  .input_2(const_Vdcref),
						  .input_3(Q_temp),
						  .input_4(const_Qref),
						  
						  .output_1(idref1),
						  .output_2(iqref1),
						  .done_sig(done_sig_control_loopp)
                           );
threshold64  #(64'h3FF8000000000000,64'hBFF8000000000000,64'h0000000000000000) threshold14(
					  .clk(clk),
					  .rst(rst),
					  .sta(done_sig_control_loopp),
					  .x(idref1),
					  .y(idref),				  
					  .done_sig(done_sig_threshold14)
					 );
									
									
threshold64 #(64'h3FF8000000000000,64'hBFF8000000000000,64'h0000000000000000) threshold13(
					  .clk(clk),
					  .rst(rst),
					  .sta(done_sig_control_loopp),
					  .x(iqref1),
					  .y(iqref),				  
					  .done_sig(done_sig_threshold13)
					 );
*/					 
convert_double_to_single_control_system   double2single_a112(
                                               .clk(clk),
															  .rst(rst),
															  //.sta(done_sig_threshold114),
															  .x(idref),
															  .y(idref_single)
															  //.done_sig(done_sig_multiplierdouble2single1124)
															  );	

convert_double_to_single_control_system   double2single_a124(
                                               .clk(clk),
															  .rst(rst),
															 // .sta(done_sig_threshold114),
															  .x(iqref),
															  .y(iqref_single)
															 // .done_sig(done_sig_multiplierdouble2single1124)
															  );																  
		
//////////////////////////////////////////////////////
wire [`EXTENDED_SINGLE - 1:0] dPddd33;
wire [`EXTENDED_SINGLE - 1:0] diqqq33;
wire donesig_Adder_inner_resultddd33;
wire donesig_Adder_inner_resultqqq33;
ADD_SUB_64_MODULE   Adder_inner_resultddd33(

			 .sta(done_sig_threshold14),
			 .rst_control(rst),
			 .add_sub(`sub),
			 .clk(clk),
			 .dataa(idref),			 			 			 
			 .datab(Id_temp),
			 
			 .result(dPddd33),
			 .done_sig(donesig_Adder_inner_resultddd33)
		   );	

ADD_SUB_64_MODULE   Adder_inner_resultqqq33(

			 .sta(done_sig_threshold14),
			 .rst_control(rst),
			 .add_sub(`sub),
			 .clk(clk),
			 .dataa(iqref),			 			 			 
			 .datab(Iq_temp),
			 
			 .result(diqqq33),
			 .done_sig(donesig_Adder_inner_resultqqq33)
		   );	




PI_limit64 #(64'h4000000000000000,64'h3EFF75104D551D69,64'h3FF8000000000000,64'hBFF8000000000000)PIddd11(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(donesig_Adder_inner_resultddd33),
					 .x(dPddd33),
						  
					 .y(vdref1),
					 .done_sig(done_sig_threshold113)
					);

PI_limit64 #(64'h4000000000000000,64'h3EFF75104D551D69,64'h3FF8000000000000,64'hBFF8000000000000)PIqqq11(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .control_valuation_sig(control_valuation_sig),
					 .sta(donesig_Adder_inner_resultqqq33),
					 .x(diqqq33),
						  
					 .y(vqref1),
					 .done_sig(done_sig_threshold114)
					);




//////////////////////////////////////////////////////
/*	  
control_loop1_64 #(64'h4000001A36E2EB1C,64'hBFFFFFCB923A29C7,64'h4000001A36E2EB1C,64'hBFFFFFCB923A29C7)control_loopp1(
                    .clk(clk),
						  .rst(rst),
						  .rst_user(rst_user),
                    .control_valuation_sig(control_valuation_sig),						  
						  .sta(done_sig_threshold14),
						  .input_1(idref),
						  .input_2(Id_temp),
						  .input_3(iqref),
						  .input_4(Iq_temp),
						  
						  .output_1(vdref_temp),
						  .output_2(vqref_temp),
						  .done_sig(done_sig_control_loop1)
                           );
threshold64 #(64'h3FF8000000000000,64'hBFF8000000000000,64'h0000000000000000) threshold113(
					  .clk(clk),
					  .rst(rst),
					  .sta(done_sig_control_loop1),
					  .x(vdref_temp),
					  .y(vdref1),				  
					  .done_sig(done_sig_threshold113)
					 );									
													 
threshold64  #(64'h3FF8000000000000,64'hBFF8000000000000,64'h0000000000000000) threshold114(
					  .clk(clk),
					  .rst(rst),
					  .sta(done_sig_control_loop1),
					  .x(vqref_temp),
					  .y(vqref1),				  
					  .done_sig(done_sig_threshold114)
					 );
*/
wire done_sig_multiplierdouble2single1112;					 
convert_double_to_single_control_system   double2single_a1112(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_threshold114),
															  .x(vdref1),
															  .y(vdref),
															  .done_sig(done_sig_multiplierdouble2single1112)
															  );	
															  
convert_double_to_single_control_system   double2single_a1124(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_threshold114),
															  .x(vqref1),
															  .y(vqref),
															  .done_sig(done_sig_multiplierdouble2single1124)
															  );					 
	
	
	
////////////////////////////////////////////////////////////////////// 
dq02abc dq02abc1(
					.clk(clk),
					.rst(rst),
					.sta(done_sig_multiplierdouble2single1124),
					.Vd(vdref),
					.Vq(vqref),
					.sin_theta(sin),
					.cos_theta(cos),
					
					.Va(ma),
					.Vb(mb),
					.Vc(mc),
					.done_sig(done_sig_dq02abc)
				  );

/*				  
DELAY_1CLK  #(24) Delay_DONE_SIG90(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig_threshold14),
											.q(done_sig_dq02abc)
										  );
										  
*/										  
DELAY_1CLK  #(12) Delay_DONE_SIG91(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig_multiplierdouble2single1124),
											.q(sig_start_pwm)
										  );

///////////////////////////////////////////////////////////////////////////////////
/*										  
freq=2600Hz; Amplitude=1V;


*/
PWM #(3'b001,32'd31,32'd1,32'd0,32'h3D000000,3'b000,3'b001,3'b010,3'b011,3'b100) PWM(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sig_start_pwm),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out),
		  .done_sig(done_sig_PWM)
		 );
		 	 
/////////////////////////////////////////////////////////////////////////////////////
		 
Comparator Comparator_Va(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM),
								 .input_1(ma),
								 .input_2(triangle_out),
								 .output_1(g1),
								 .output_2(g2),
								 .done_sig(done_sig_comparator_ma)
							   );
								
Comparator Comparator_Vb(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM),
								 .input_1(mb),
								 .input_2(triangle_out),
								 .output_1(g3),
								 .output_2(g4),
							   .done_sig(done_sig_comparator_mb)
							   );
								
Comparator Comparator_Vc(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM),
								 .input_1(mc),
								 .input_2(triangle_out),
								 .output_1(g5),
								 .output_2(g6),
								 .done_sig(done_sig)
							   );
							
							
endmodule				  