`include "../parameter/global_parameter.v"

module RectifierControl_water(
			 clk,
			 rst,
			 sta,
		    FLAGFH,	 
          sta_user,
          rst_user,
	       done_read_x_PIddd1,		 
          Pref,
          P_PM,         
          Id,
          Iq,
          theta,
          			 
			 
			 m1_single,
			 m3_single,
			 m5_single,
          sta_before_m_3clk
			);
			
input clk;
input rst;
input rst_user;
input sta,FLAGFH;
input sta_user;
input wire done_read_x_PIddd1;
input [`SINGLE - 1:0] Pref;
input [`SINGLE - 1:0] P_PM;
input [`SINGLE - 1:0] theta;
input wire [`EXTENDED_SINGLE - 1:0] Id;
input wire [`EXTENDED_SINGLE - 1:0] Iq;

output [`SINGLE - 1:0] m1_single,m3_single,m5_single;
output sta_before_m_3clk;

wire done_sig;
wire m1_Cal,m2_Cal,m3_Cal;
wire m4_Cal,m5_Cal,m6_Cal;
wire [`SINGLE - 1:0] vqref;
wire [`SINGLE - 1:0] iqref_single;
wire [`SINGLE - 1:0] sin;
wire [`SINGLE - 1:0] cos;
wire [`SINGLE - 1:0] cos1;
wire [`SINGLE - 1:0] theta;
wire [`SINGLE - 1:0] ma;
wire [`SINGLE - 1:0] mb;
wire [`SINGLE - 1:0] mc;
wire [`SINGLE - 1:0] triangle_out;
wire [`SINGLE - 1:0] vdref;			  						 						 						  
wire [`EXTENDED_SINGLE - 1:0] iqref;
wire [`EXTENDED_SINGLE - 1:0] vdref_temp;
wire [`EXTENDED_SINGLE - 1:0] diq;
wire [`EXTENDED_SINGLE - 1:0] vqref1_temp;
wire [`EXTENDED_SINGLE - 1:0] Pref_temp;
wire [`EXTENDED_SINGLE - 1:0] P_temp;
wire [`EXTENDED_SINGLE - 1:0] Id1_temp;
wire [`EXTENDED_SINGLE - 1:0] Iq1_temp;
wire [`EXTENDED_SINGLE - 1:0] dPddd3;
wire [`EXTENDED_SINGLE - 1:0] diqqq3;
wire donesig_Adder9;
wire donesig_Adder_inner_result46;
wire done_read_x_PI31;
wire done_sig_threshold76;
wire done_sig_threshold39;
wire done_sig_threshold14;
wire done_sig_PWM103;
wire done_sig_comparator_ma;
wire done_sig_comparator_mb;
wire sig_start_pwm91;
wire done_sig_double2single79;
wire done_sig_compVc;

reg [`SINGLE - 1:0] m1_reg,m3_reg,m5_reg;

parameter const_inv_Sbase = 32'h3532F4FC;//1/1500000
parameter const_Ten = 32'h41200000;
parameter idref = 64'h0000000000000000;
//const1 is 5.6338e-4
parameter const1 = 64'h3F4275F9566D9FEC;


assign sta_before_m_3clk = done_sig_PWM103;




/*									 
convert_single_to_double_control_system  single2float1(
                                               .clk(clk),
															  .rst(rst),
															  .sta(sta),
															  .x(Pref),
															  .y(Pref_temp),
															  .done_sig(done_sig_multiplierIq1_temp)
															  );
*/															  
SINGLE2EXTENDED_SINGLE	SINGLE2EXTENDED_SINGLE1 (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Pref),
													        .result(Pref_temp)
													        );
															  
/*	
convert_single_to_double_control_system  single2float2(
                                               .clk(clk),
															  .rst(rst),
															  .sta(sta),
															  .x(P),
															  .y(P_temp),
															  .done_sig(done_sig_multiplierIq1_temp1)
															  );	
*/
SINGLE2EXTENDED_SINGLE	single2float2 (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(P_PM),
													        .result(P_temp)
													        );
	
////////////////////////////////////////////////////////////////////
ADD_SUB_64	Adder_inner_resultddd3(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(P_temp),
						              .datab(Pref_temp),
						              .result(dPddd3)
										 );
										 
DELAY_1CLK  #(9) Delay_sta_user_d(
						               .clk(clk),
						               .rst(rst),
						               .d(sta),
						               .q(donesig_Adder9)
					                  );

                     
PI_limit64_water_v2 #(64'h3ff0000000000000,64'h3f0797cc39ffd60f,64'h3FF8000000000000,64'hBFF8000000000000)PIddd1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_Adder9),
					 .done_read_x(done_read_x_PIddd1),
					 .x(dPddd3),
						  
					 .y(iqref),
					 .done_sig(done_sig_threshold39)
					);//30

				
/*				 
convert_double_to_single_control_system   double2single_a124(
                                               .clk(clk),
															  .rst(rst),
															  //.sta(done_sig_threshold76),
															  .x(iqref),
															  .y(iqref_single)
															  //.done_sig(done_sig_double2single79)
															  );					 
*/	
EXTENDED_SINGLE2SINGLE	double2single_a124 (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(iqref),
													        .result(iqref_single)
													        );	


						  										  
multiplier_64_dsp     multiplier_control_system1(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(Id),
									  .datab(const1),
									  .result(Id1_temp)
									 );
									 
multiplier_64_dsp     multiplier_control_system2(
									  .aclr(rst),
									  .clk_en(`ena_math),
									  .clock(clk),
									  .dataa(Iq),
									  .datab(const1),
									  .result(Iq1_temp)
									 );
										  
/////////////////////////////////////////////////////////////////////////////////										  
ADD_SUB_64_MODULE   Adder_inner_result3(

			 .sta(done_sig_threshold39),
			 .rst_control(rst),
			 .add_sub(`sub),
			 .clk(clk),
			 .dataa(iqref),			 			 			 
			 .datab(Iq1_temp),
			 
			 .result(diq),
			 .done_sig(donesig_Adder_inner_result46)
		   );
			
ADD_SUB_64	Adder_inner_resultqqq3(
										  .aclr(rst),
										  .add_sub(`sub),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(idref),
						              .datab(Id1_temp),
						              .result(diqqq3)
										 );			
										 
DELAY_1CLK  #(22) Delay_12g(
						               .clk(clk),
						               .rst(rst),
						               .d(donesig_Adder9),
						               .q(done_read_x_PI31)
					                  );
							 				
PI_limit64_water_v2 #(64'h4010000000000000,64'h3f2d7dbf487fcb92,64'h41D65A0BC0000000,64'hC1D65A0BC0000000)PI1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_Adder_inner_result46),
					 .done_read_x(done_read_x_PI31),
					 .x(diq),
						  
					 .y(vqref1_temp),
					 .done_sig(done_sig_threshold76)
					);
					
					       
PI_limit64_water_v2 #(64'h4010000000000000,64'h3f2d7dbf487fcb92,64'h41D65A0BC0000000,64'hC1D65A0BC0000000)PIqqq1(
					 .clk(clk),
			       .rst(rst),
			       .rst_user(rst_user),
					 .sta(donesig_Adder_inner_result46),
					 .done_read_x(done_read_x_PI31),
					 .x(diqqq3),
						  
					 .y(vdref_temp),
					 .done_sig(done_sig_threshold14)
					);
				 		 
					
															  
EXTENDED_SINGLE2SINGLE	double2single_a112(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(vdref_temp),
													        .result(vdref)
													        );
															  
convert_double_to_single_control_system   double2single_a2(
                                               .clk(clk),
															  .rst(rst),
															  .sta(done_sig_threshold76),
															  .x(vqref1_temp),
															  .y(vqref),
															  .done_sig(done_sig_double2single79)
															  );

															  
Sin_control_system_water   Sin_1(
							.clk(clk),
							.rst(rst),
							//.sta(sta_theta),
							.theta(theta),
							 		
							.sin(sin)
							//.done_sig(done_sig_sin1)
								);
															
Cos_control_system_water  Cos_1(
							.clk(clk),
							.rst(rst),
							//.sta(sta_theta),
							.theta(theta),
							 			
							.cos(cos1)
                     //.done_sig(done_sig_cos1)
								);	
								
DELAY_NCLK  #(32,1)  DELAY_NCLK15a(
						               .clk(clk),
											.rst(rst),
						               .d(cos1),
						               .q(cos)
					                 );

				
dq02abc_water dq02abc1(
					.clk(clk),
					.rst(rst),
					//.sta(done_sig_double2single79),
					.Vd(vdref),
					.Vq(vqref),
					.sin_theta(sin),
					.cos_theta(cos),
					
					.Va(ma),
					.Vb(mb),
					.Vc(mc)
					//.done_sig(done_sig_dq02abc)
				  );
/*				  
DELAY_1CLK  #(12) Delay_DONE_SIG91(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig_double2single79),
											.q(sig_start_pwm91)
										  );										 
									  
PWM #(3'b001,32'd24,32'd1,32'd0,32'h3D23D70A,3'b000,3'b001,3'b010,3'b011,3'b100) PWM(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sig_start_pwm91),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out),
		  .done_sig(done_sig_PWM103)
		 );
*/	


	 
DELAY_1CLK  #(12) Delay_DONE_SIG91(
										  	.clk(clk),
											.rst(rst),
											.d(done_sig_double2single79),
											.q(sig_start_pwm91)
										  );

										  
///PWM #(3'b001,32'd4,32'd1,32'd0,32'h3E4CCCCD,3'b000,3'b001,3'b010,3'b011,3'b100) PWM(										  
//3'b001,32'd18,32'd1,32'd0,32'h3D638E39,3'b000,3'b001,3'b010,3'b011,3'b100
      									 
PWM #(3'b001,32'd22,32'd1,32'd0,32'h3d3a2e8c,3'b000,3'b001,3'b010,3'b011,3'b100) PWM(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sig_start_pwm91),
		  .FLAGFH(FLAGFH),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out),
		  .done_sig(done_sig_PWM103)
		 );
		 	 
	 
Comparator Comparator_Va(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM103),
								 .input_1(ma),
								 .input_2(triangle_out),
								 .output_1(m1_Cal),
								 .output_2(m2_Cal),
								 .done_sig(done_sig_comparator_ma)
							   );
								
Comparator Comparator_Vb(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM103),
								 .input_1(mb),
								 .input_2(triangle_out),
								 .output_1(m3_Cal),
								 .output_2(m4_Cal),
							   .done_sig(done_sig_comparator_mb)
							   );
								
Comparator Comparator_Vc(
								 .clk(clk),
								 .rst(rst),
								 .sta(done_sig_PWM103),
								 .input_1(mc),
								 .input_2(triangle_out),
								 .output_1(m5_Cal),
								 .output_2(m6_Cal),
								 .done_sig(done_sig_compVc)
							   );
								
always@(posedge clk or posedge rst) begin
	if(rst) begin
		m1_reg <= 32'h00000000;
	end
	else if(m1_Cal) begin
		m1_reg <= 32'h3F800000;
	end
	else if(!m1_Cal) begin
		m1_reg <= 32'h00000000;
	end
end
			
always@(posedge clk or posedge rst) begin
	if(rst) begin
		m3_reg <= 32'h00000000;
	end
	else if(m3_Cal) begin
		m3_reg <= 32'h3F800000;
	end
	else if(!m3_Cal) begin
		m3_reg <= 32'h00000000;
	end
end


always@(posedge clk or posedge rst) begin
	if(rst) begin
		m5_reg <= 32'h00000000;
	end
	else if(m5_Cal) begin
		m5_reg <= 32'h3F800000;
	end
	else if(!m5_Cal) begin
		m5_reg <= 32'h00000000;
	end
end

assign m1_single = m1_reg;
assign m3_single = m3_reg;
assign m5_single = m5_reg;
	

DELAY_1CLK  #(1) Delay_12ggg(
						               .clk(clk),
						               .rst(rst),
						               .d(done_sig_compVc),
						               .q(done_sig)
					                  );	

	
endmodule				  