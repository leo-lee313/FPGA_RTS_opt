`include "../parameter/global_parameter.v"

module InverterControl_water(
			 clk,
			 rst,
			 sta_done_read_x,
			 sta,  
          FLAGFH,			 
          sta_user,
          rst_user,	 
          Vdc,
         
          V3a,
          V3b,
          V3c,
          I3a,
          I3b,
          I3c,
			 
          g1_single,
			 g3_single,
			 g5_single,
			 
			 done_sig
			);
input clk;
input rst;
input rst_user,FLAGFH;
input sta,sta_done_read_x;
input sta_user;
input [`SINGLE - 1:0] Vdc;

input [`SINGLE - 1:0] V3a;
input [`SINGLE - 1:0] V3b;
input [`SINGLE - 1:0] V3c;
input [`SINGLE - 1:0] I3a;
input [`SINGLE - 1:0] I3b;
input [`SINGLE - 1:0] I3c;

output [`SINGLE - 1:0] g1_single,g3_single,g5_single;
output done_sig;

wire g1_Cal,g2_Cal,g3_Cal,g4_Cal,g5_Cal,g6_Cal;
reg  [`SINGLE - 1:0] g1_reg,g3_reg,g5_reg;
wire [`SINGLE - 1:0] Vdc_delay;
wire [`SINGLE - 1:0] Va;
wire [`SINGLE - 1:0] Vb;
wire [`SINGLE - 1:0] Vc;
wire [`SINGLE - 1:0] Ia;
wire [`SINGLE - 1:0] Ib;
wire [`SINGLE - 1:0] Ic;
wire [`SINGLE - 1:0] Ia_delay;
wire [`SINGLE - 1:0] Ib_delay;
wire [`SINGLE - 1:0] Ic_delay;
wire [`SINGLE - 1:0] Id;
wire [`SINGLE - 1:0] Iq;
wire [`SINGLE - 1:0] Q3;
wire [`SINGLE - 1:0] Q;
wire [`SINGLE - 1:0] sin;
wire [`SINGLE - 1:0] cos;
wire [`SINGLE - 1:0] sin_delay;
wire [`SINGLE - 1:0] cos_delay;
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

wire [`EXTENDED_SINGLE - 1:0] iqref;
wire [`EXTENDED_SINGLE - 1:0] idref;
wire [`EXTENDED_SINGLE - 1:0] iqref_delay;
wire [`EXTENDED_SINGLE - 1:0] idref_delay;
wire [`EXTENDED_SINGLE - 1:0] vdref1;
wire [`EXTENDED_SINGLE - 1:0] vqref1;

wire done_sig_threshold13;
wire done_sig_threshold14;
wire done_sig_comp_Vc;


wire done_sig_PLL;
wire done_sig_PWM;
wire done_sig_comparator_ma;
wire done_sig_comparator_mb;
wire sig_start_pwm;

wire done_sig_threshold113;
wire done_sig_threshold114;
wire done_sig1;

parameter const_inv_Vbase = 32'h3C23D70A;//0.01
parameter const_inv_Ibase = 32'h39F62548;//0.000469485534
parameter const_inv_Sbase = 32'h3532F4FC;//1/1500000
parameter const_Vdcref = 64'h4097700000000000;//1500V
parameter const_Qref = 64'h0000000000000000;
parameter const_onethousand = 32'h447A0000;
wire [`SINGLE - 1:0] P3;		
wire donesig_P3;
////////////////////////for observing Activepower///////////////////////		 
P_cal_filterless_water   P_cal1(
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
//////////////////////////////////////////////////////////////////////////
Multiplier_nodsp	 multiplier_control_system0(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(V3a),
									  .datab(const_inv_Vbase),
									  .result(Va)
									 );
									 
Multiplier_nodsp	 multiplier_control_system1(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(V3b),
									  .datab(const_inv_Vbase),
									  .result(Vb)
									 );
									 
Multiplier_nodsp	 multiplier_control_system2(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(V3c),
									  .datab(const_inv_Vbase),
									  .result(Vc)
									 );
Multiplier_nodsp	 multiplier_control_system3(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(I3a),
									  .datab(const_inv_Ibase),
									  .result(Ia)
									 );									 
Multiplier_nodsp	 multiplier_control_system4(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(I3b),
									  .datab(const_inv_Ibase),
									  .result(Ib)
									 );
Multiplier_nodsp	 multiplier_control_system5(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(I3c),
									  .datab(const_inv_Ibase),
									  .result(Ic)
									 );
DELAY_1CLK #(5) Delay_done_sig(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(done_sig1)
										 );										  
///////////////////////////////////////////////////////////////////										  
Q_cal_water Q_cal1(
				  .clk(clk),
				  .rst(rst),				 
				  .Va(V3a),
				  .Vb(V3b),
				  .Vc(V3c),
				  .Ia(I3a),
				  .Ib(I3b),
				  .Ic(I3c),
				  
				  .Q(Q3)				 				  
				 );										  

Multiplier_nodsp	 multiplier_control_system7(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(Q3),
									  .datab(const_inv_Sbase),
									  .result(Q)
									 );
									 
////////////////////////////////////////////////////////////////////

assign Vdc_delay = Vdc;
										  
SINGLE2EXTENDED_SINGLE	single2float_1(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vdc_delay),
													        .result(Vdc1_temp)
													        );
/*															  
convert_single_to_double_control_system  single2float_1(
                                               .clk(clk),
															  .rst(rst),
															  .sta(sta),
															  .x(Vdc),
															  .y(Vdc1_temp),
															  .done_sig(done_sig_multiplierSingle2Float)
															  );
*/
SINGLE2EXTENDED_SINGLE	single2float2(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Q),
													        .result(Q_temp)
													        );
/*															  
wire done_sig_multiplierSingle2Float1;			  
convert_single_to_double_control_system  single2float2(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_multiplierQ),
															  .x(Q),
															  .y(Q_temp),
															  .done_sig(done_sig_multiplierSingle2Float1)
															  );
															 
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////
wire [`EXTENDED_SINGLE - 1:0] dPddd3;
wire [`EXTENDED_SINGLE - 1:0] diqqq3;
wire donesig_Adder_inner_resultddd3;
wire donesig_Adder_inner_resultqqq3;

ADD_SUB_64	Adder_inner_resultddd3(
	       .aclr(rst),
			 .add_sub(`sub),
			 .clk_en(`ena_math),
			 .clock(clk),
			 .dataa(Vdc1_temp),
			 .datab(const_Vdcref),
			 .result(dPddd3)
										 );
/*										 
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
*/
ADD_SUB_64	Adder_inner_resultqqq3(
	       .aclr(rst),
			 .add_sub(`sub),
			 .clk_en(`ena_math),
			 .clock(clk),
			 .dataa(Q_temp),
			 .datab(const_Qref),
			 .result(diqqq3)
										 );
/*										 
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
*/
DELAY_1CLK #(10) Delay_123(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(donesig_Adder_inner_resultddd3)
										 );
PI_limit64_water_v2 #(64'h3fb999999999999a,64'h3eae32f0ee144532,64'h3FF8000000000000,64'hBFF8000000000000)PIddd1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_Adder_inner_resultddd3),
					 .done_read_x(sta_done_read_x),
					 .x(dPddd3),
						  
					 .y(idref),
					 .done_sig(done_sig_threshold14)
					);
					
DELAY_1CLK #(5) Delay_145(
										 .clk(clk),
										 .rst(rst),
										 .d(done_sig_threshold14),
										 .q(donesig_Adder_inner_resultqqq3)
										 );
wire done_readx_PIqqq1;										 
DELAY_1CLK #(20) Delay_156(
										 .clk(clk),
										 .rst(rst),
										 .d(donesig_Adder_inner_resultddd3),
										 .q(done_readx_PIqqq1)
										 );										 
PI_limit64_water_v2 #(64'h3fa999999999999a,64'h3ee2dfd694ccab3f,64'h3FF8000000000000,64'hBFF8000000000000)PIqqq1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_Adder_inner_resultqqq3),
					 .done_read_x(done_readx_PIqqq1),
					 .x(diqqq3),
						  
					 .y(iqref),
					 .done_sig(done_sig_threshold13)
					);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
EXTENDED_SINGLE2SINGLE	double2single_a112(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(idref),
													        .result(idref_single)
													        );
/*															  
convert_double_to_single_control_system   double2single_a112(
                                               .clk(clk),
															  .rst(rst),
															  //.sta(done_sig_threshold114),
															  .x(idref),
															  .y(idref_single)
															  //.done_sig(done_sig_multiplierdouble2single1124)
															  );	
*/
EXTENDED_SINGLE2SINGLE	double2single_a124(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(iqref),
													        .result(iqref_single)
													        );
/*															  
convert_double_to_single_control_system   double2single_a124(
                                               .clk(clk),
															  .rst(rst),
															 // .sta(done_sig_threshold114),
															  .x(iqref),
															  .y(iqref_single)
															 // .done_sig(done_sig_multiplierdouble2single1124)
															  );
*/															  
///////////////////////////////////////////////////////////////////////
wire done_read_Ia;
										  
PLL_control_system_water  PLL(
			      .clk(clk),
					.sta(done_sig1),
					.rst(rst),
					.rst_user(rst_user),
					.Va(Va),
					.Vb(Vb),
					.Vc(Vc),
					.cos(cos),
					.sin(sin),					
					
					.theta(theta),			
					.done_sig(done_sig_PLL),
					.done_read_Ia(done_read_Ia)
			                );
								 
System_FIFO_32 System_FIFO_01(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_Ia),
								.before_enawrite(done_sig1),
								.cin( Ia ),
								.cout( Ia_delay )
							  );	
							  
System_FIFO_32 System_FIFO_02(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_Ia),
								.before_enawrite(done_sig1),
								.cin( Ib ),
								.cout( Ib_delay )
							  );
							  
System_FIFO_32 System_FIFO_03(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_Ia),
								.before_enawrite(done_sig1),
								.cin( Ic ),
								.cout( Ic_delay )
							  );							  
							  
							  
abc2dq0_water  abc2dq01(
					.clk(clk),
					.rst(rst),					
					.Va(Ia_delay),
					.Vb(Ib_delay),
					.Vc(Ic_delay),
					.sin_theta(sin),
					.cos_theta(cos),
					
					.Vd(Id),
					.Vq(Iq)					
				  );

SINGLE2EXTENDED_SINGLE	single2float3(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Id),
													        .result(Id_temp)
													        );
															  

															  
/*				  
wire done_sig_multiplierSingle2Float2;			  
convert_single_to_double_control_system  single2float3(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_abc2dq0),
															  .x(Id),
															  .y(Id_temp),
															  .done_sig(done_sig_multiplierSingle2Float2)
															  );
*/
SINGLE2EXTENDED_SINGLE	single2float4(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Iq),
													        .result(Iq_temp)
													        );
/*															  
wire done_sig_multiplierSingle2Float3;
			  
convert_single_to_double_control_system  single2float4(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_abc2dq0),
															  .x(Iq),
															  .y(Iq_temp),
															  .done_sig(done_sig_multiplierSingle2Float3)
															  );				 
*/				 
//////////////////////////////////////////////////////
wire [`EXTENDED_SINGLE - 1:0] dPddd33;
wire [`EXTENDED_SINGLE - 1:0] diqqq33;
wire done_read_idref;
DELAY_1CLK #(33) Delay_done_sig111(
										 .clk(clk),
										 .rst(rst),
										 .d(done_read_Ia),
										 .q(done_read_idref)
										 );
										 
System_FIFO_64 System_FIFO_012(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_idref),
								.before_enawrite(done_sig_threshold14),
								.cin( idref ),
								.cout( idref_delay )
							  );
							  
System_FIFO_64 System_FIFO_013(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_idref),
								.before_enawrite(done_sig_threshold13),
								.cin( iqref ),
								.cout( iqref_delay )
							  );


ADD_SUB_64	Adder_inner_resultddd33(
	       .aclr(rst),
			 .add_sub(`sub),
			 .clk_en(`ena_math),
			 .clock(clk),
			 .dataa(idref_delay),
			 .datab(Id_temp),
			 .result(dPddd33)
										 );

/*
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
*/
ADD_SUB_64	Adder_inner_resultqqq33(
	       .aclr(rst),
			 .add_sub(`sub),
			 .clk_en(`ena_math),
			 .clock(clk),
			 .dataa(iqref_delay),
			 .datab(Iq_temp),
			 .result(diqqq33)
										 );

/*
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

*/
wire donesig_PII;
wire donereadx_PII;
DELAY_1CLK #(9) Delay_done_sig112(
										 .clk(clk),
										 .rst(rst),
										 .d(done_read_idref),
										 .q(donesig_PII)
										 );
										 
DELAY_1CLK #(25) Delay_done_sig112a(
										 .clk(clk),
										 .rst(rst),
										 .d(done_sig_PLL),
										 .q(donereadx_PII)
										 );
										 
PI_limit64_water_v2 #(64'h4000000000000000,64'h3ee2dfd694ccab3f,64'h41D65A0BC0000000,64'hC1D65A0BC0000000)PIddd11(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_PII),
					 .done_read_x(donereadx_PII),
					 .x(dPddd33),
						  
					 .y(vdref1),
					 .done_sig(done_sig_threshold113)
					);

PI_limit64_water_v2 #(64'h4000000000000000,64'h3ee2dfd694ccab3f,64'h41D65A0BC0000000,64'hC1D65A0BC0000000)PIqqq11(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_PII),
					 .done_read_x(donereadx_PII),
					 .x(diqqq33),
						  
					 .y(vqref1),
					 .done_sig(done_sig_threshold114)
					);




//////////////////////////////////////////////////////

EXTENDED_SINGLE2SINGLE	double2single_a1112(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(vdref1),
													        .result(vdref)
													        );

EXTENDED_SINGLE2SINGLE	double2single_a1124(
                                               .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(vqref1),
													        .result(vqref)
													        );

	
	
//////////////////////////////////////////////////////////////////////
wire done_read_sincos;

DELAY_1CLK #(1) Delay_done_sigabc(
										 .clk(clk),
										 .rst(rst),
										 .d(done_sig_threshold113),
										 .q(done_read_sincos)
										 );
										 
System_FIFO_32 System_FIFO_012a(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_sincos),
								.before_enawrite(done_sig_PLL),
								.cin( sin ),
								.cout( sin_delay )
							  );
							  
System_FIFO_32 System_FIFO_013a(
								.clk(clk),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(done_read_sincos),
								.before_enawrite(done_sig_PLL),
								.cin( cos ),
								.cout( cos_delay )
							  );

dq02abc_water dq02abc1(
					.clk(clk),
					.rst(rst),
					//.sta(done_sig_multiplierdouble2single1124),
					.Vd(vdref),
					.Vq(vqref),
					.sin_theta(sin_delay),
					.cos_theta(cos_delay),
					
					.Va(ma),
					.Vb(mb),
					.Vc(mc)
					//.done_sig(done_sig_dq02abc)
				  );

/*				  
DELAY_1CLK  #(24) Delay_DONE_SIG90(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig_threshold14),
											.q(done_sig_dq02abc)
										  );
										  
*/										  
DELAY_1CLK  #(15) Delay_DONE_SIG91(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig_threshold114),
											.q(sig_start_pwm)
										  );

///////////////////////////////////////////////////////////////////////////////////
/*										  
freq=5000Hz; Amplitude=1V;


*/

PWM #(3'b001,32'd22,32'd1,32'd0,32'h3d3a2e8c,3'b000,3'b001,3'b010,3'b011,3'b100) PWM(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sig_start_pwm),
		  .FLAGFH(FLAGFH),
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
								 .output_1(g1_Cal),
								 .output_2(g2_Cal),
								 .done_sig(done_sig_comparator_ma)
							   );
								
Comparator Comparator_Vb(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM),
								 .input_1(mb),
								 .input_2(triangle_out),
								 .output_1(g3_Cal),
								 .output_2(g4_Cal),
							   .done_sig(done_sig_comparator_mb)
							   );
								
Comparator Comparator_Vc(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM),
								 .input_1(mc),
								 .input_2(triangle_out),
								 .output_1(g5_Cal),
								 .output_2(g6_Cal),
								 .done_sig(done_sig_comp_Vc)
							   );

always@(posedge clk or posedge rst) begin
	if(rst) begin
		g1_reg <= 32'h00000000;
	end
	else if(g1_Cal) begin
		g1_reg <= 32'h3F800000;
	end
	else if(!g1_Cal) begin
		g1_reg <= 32'h00000000;
	end
end
			
always@(posedge clk or posedge rst) begin
	if(rst) begin
		g3_reg <= 32'h00000000;
	end
	else if(g3_Cal) begin
		g3_reg <= 32'h3F800000;
	end
	else if(!g3_Cal) begin
		g3_reg <= 32'h00000000;
	end
end


always@(posedge clk or posedge rst) begin
	if(rst) begin
		g5_reg <= 32'h00000000;
	end
	else if(g5_Cal) begin
		g5_reg <= 32'h3F800000;
	end
	else if(!g5_Cal) begin
		g5_reg <= 32'h00000000;
	end
end

assign g1_single = g1_reg;
assign g3_single = g3_reg;
assign g5_single = g5_reg;
							
DELAY_1CLK #(1) Delay_tty(
										.clk(clk),
										.rst(rst),
										.d(done_sig_comp_Vc),
										.q(done_sig)
											);						
					
					
	
							
endmodule				  



