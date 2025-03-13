`include "../parameter/Global_parameter.v"

module Control_System(
							 clk,
							 sta,
							 sta_ad,
							 sta_user,
							 rst,
							 rst_user,
							 output_num,
							 control_valuation_sig,							 
							 sim_time,
							 
							 Vd,
					       Ia,
					       Ib,
					       Ic,
					       Va,
					       Vb,
					       Vc,
					       Vdc,
							 Ia_SFM_Inv,
							 Ic_SFM_Inv,
							 
							 exchange_data_sig,						 
							 exchange_Source_sig,
							 source_output
							);
						
parameter const_inv_20 = 32'h3d8f5c29;
parameter const_Vdc_ref = 32'h43af0000;
parameter const_Q_ref = 32'h00000000;
parameter const_inv_Vdc_ref = 32'h3b3b3ee7;

//parameter times_ad = 32'h44FA0000;

input clk;
input sta;
input sta_ad;
input sta_user;
input rst;
input rst_user;
input control_valuation_sig;
input exchange_Source_sig;
input [`WIDTH_TIME - 1:0] sim_time;
input [7:0] output_num;
input [`SINGLE - 1:0] Vd;
input [`SINGLE - 1:0] Va;
input [`SINGLE - 1:0] Vb;
input [`SINGLE - 1:0] Vc;
input [`SINGLE - 1:0] Ia;
input [`SINGLE - 1:0] Ib;
input [`SINGLE - 1:0] Ic;
input [`SINGLE - 1:0] Vdc;
input [`SINGLE - 1:0] Ia_SFM_Inv;
input [`SINGLE - 1:0] Ic_SFM_Inv;
				  
output [`EXTENDED_SINGLE - 1:0] source_output;
output exchange_data_sig;

wire sta_interface;
wire [`SINGLE - 1:0] Va_pu;
wire [`SINGLE - 1:0] Vb_pu;
wire [`SINGLE - 1:0] Vc_pu;
wire done_sig_Va_pu;
wire done_sig_Vb_pu;
wire done_sig_Vc_pu;
wire done_sig_Iph;
wire done_sig_Id;	
//////////////////////////////////

wire [`SINGLE - 1:0] frequence;
wire [`SINGLE - 1:0] theta;
wire [`SINGLE - 1:0] sin,sin_delay;
wire [`SINGLE - 1:0] cos,cos_delay;
wire done_sig_PLL;

////////////////////////////////////////////////

wire [`SINGLE - 1:0] Vd_abc2dq0;
wire [`SINGLE - 1:0] Vq_abc2dq0;
wire done_sig_abc2dq0_V;

////////////////////////////////////////////////

wire [`SINGLE - 1:0] Id_abc2dq0,Id_abc2dq0_delay;
wire [`SINGLE - 1:0] Iq_abc2dq0,Iq_abc2dq0_delay;
wire done_sig_abc2dq0_I;

/////////////////////////////////////////////////

wire [`SINGLE - 1:0] P;
wire [`SINGLE - 1:0] Q;
wire done_sig_PQ_cal;

/////////////////////////////////////////////////

wire [`SINGLE - 1:0] Id_ref;
wire [`SINGLE - 1:0] Iq_ref,Vdc_reg_delay;
wire done_sig_outer_loop;

////////////////////////////////////////////////

wire [`SINGLE - 1:0] Vd_ref;
wire [`SINGLE - 1:0] Vq_ref;
wire done_sig_inner_loop;

//////////////////////////////////////////////////

wire [`SINGLE - 1:0] Va_ref;
wire [`SINGLE - 1:0] Vb_ref;
wire [`SINGLE - 1:0] Vc_ref;
wire done_sig_dq02abc;

//////////////////////////////////////////////////

wire [`SINGLE - 1:0] Va_compare;
wire done_sig_Va_compare;
wire [`SINGLE - 1:0] Vb_compare;
wire done_sig_Vb_compare;
wire [`SINGLE - 1:0] Vc_compare;
wire done_sig_Vc_compare;
wire pwm_1,pwm_2,pwm_3;
wire pwm_4,pwm_5,pwm_6;
//////////////////////////////////////////////////

wire [`SINGLE - 1:0] triangle_out;
wire done_sig_PWM;
wire done_sig_comparator_Va;
wire done_sig_comparator_Vb;
wire done_sig_comparator_Vc;

/////////////////////////////;//////////////////////

wire [`SINGLE - 1:0] Iph;
wire [`SINGLE - 1:0] Id;
wire [`SINGLE - 1:0] Uab_SFM_Inv,Ubc_SFM_Inv;
wire [`SINGLE - 1:0] Idc_SFM;
wire done_sig_PV;

//AD
wire [`SINGLE - 1:0] ad_result;
wire done_ad_convert;
//wire [`SINGLE - 1:0] S;

//AD
/*
AD_preprocess_control_system AD_preprocess_control_system(
																			 .clk(clk),
																			 .rst(rst),
																			 .sta(sta_ad),
																			 .times(times_ad),
																			 .ad_mean(ad_mean),
																			 .ad_result(ad_result),
																			 .done_sig(done_ad_convert)
																			);
*/																			

reg [`SINGLE - 1:0] Vd_reg,Va_reg,Vb_reg,Vc_reg;
reg [`SINGLE - 1:0] Vdc_reg,Ia_reg,Ib_reg,Ic_reg,Ia_SFM_Inv_reg,Ic_SFM_Inv_reg;
wire input_ena,exchange_data_sig_delay;

parameter const_timestep_Vdc = 32'd1;
parameter const_Vdc = 32'h43AF0000;

always @ ( posedge clk or posedge rst) begin
	if(rst) begin
		Vd_reg <= 32'h0;
		Va_reg <= 32'h0;
		Vb_reg <= 32'h0;
		Vc_reg <= 32'h0;
		Ia_reg <= 32'h0;
		Ib_reg <= 32'h0;
		Ic_reg <= 32'h0;
		Vdc_reg <= 32'h0;
		Ia_SFM_Inv_reg <= 32'h0;
		Ic_SFM_Inv_reg <= 32'h0;
	end
//	else if((input_ena)&&(sim_time <= const_timestep_Vdc)) begin
//		Vd_reg <= Vd;
//		Va_reg <= Va;
//		Vb_reg <= Vb;
//		Vc_reg <= Vc;
//		Ia_reg <= Ia;
//		Ib_reg <= Ib;
//		Ic_reg <= Ic;
//		Vdc_reg <= const_Vdc;
//		Ia_SFM_Inv_reg <= Ia_SFM_Inv;
//		Ic_SFM_Inv_reg <= Ic_SFM_Inv;		
//	end
//   else if((input_ena)&&(sim_time > const_timestep_Vdc)) begin
   else if(input_ena) begin
		Vd_reg <= Vd;
		Va_reg <= Va;
		Vb_reg <= Vb;
		Vc_reg <= Vc;
		Ia_reg <= Ia;
		Ib_reg <= Ib;
		Ic_reg <= Ic;
		Vdc_reg <= Vdc;
		Ia_SFM_Inv_reg <= Ia_SFM_Inv;
		Ic_SFM_Inv_reg <= Ic_SFM_Inv;	
	end
end

DELAY_1CLK #(2) Delay_EXCHANGE_DATA_SIG12(
													   .clk(clk),
													   .rst(rst),
													   .d(sta),
													   .q(exchange_data_sig)
													  );

DELAY_1CLK #(2) Delay_EXCHANGE_DATA_SIG13(
													   .clk(clk),
													   .rst(rst),
													   .d(exchange_data_sig),
													   .q(exchange_data_sig_delay)
													  );

ADDR #( 8 , `N_PV , 1 , 0 ) INPUT_ENABLE(
				.clk(clk),
				.rst(rst),
				.sta(exchange_data_sig_delay),
				.ena_cal(input_ena)
				);
													  													  													  
/*******************PV****************************/													  
																			
DELAY_1CLK #(11) DELAY_FIX2FLOAT(
										  .clk(clk),
										  .rst(rst),
										  .d(sta_ad),
										  .q(done_ad_convert)
										 );	
										 															  
DELAY_1CLK #(6) Delay_EXCHANGE_DATA_SIG130(
													   .clk(clk),
													   .rst(rst),
													   .d(sta),
													   .q(sta_interface)
													  );

multiplier_control_system multiplier_Va_pu(
														 .clk(clk),
														 .rst(rst),
														 .sta(sta_interface),
														 .x(Va_reg),
														 .y(const_inv_20),
														 .xy(Va_pu),
														 .done_sig(done_sig_Va_pu)
														);//C1

multiplier_control_system multiplier_Vb_pu(
														 .clk(clk),
														 .rst(rst),
														 .sta(sta_interface),
														 .x(Vb_reg),
														 .y(const_inv_20),
														 .xy(Vb_pu),
														 .done_sig(done_sig_Vb_pu)
														);//C2
														
multiplier_control_system multiplier_Vc_pu(
														 .clk(clk),
														 .rst(rst),
														 .sta(sta_interface),
														 .x(Vc_reg),
														 .y(const_inv_20),
														 .xy(Vc_pu),
														 .done_sig(done_sig_Vc_pu)
														);//C3

wire sta_PLL;
assign sta_PLL = done_sig_Va_pu;
/*
PLL_verify PLL(
					.clk(clk),
					.sta(sta_PLL),
					.rst(rst),
					.rst_user(rst_user),
					.control_valuation_sig(control_valuation_sig),
					.Va(Va_pu),
					.Vb(Vb_pu),
					.Vc(Vc_pu),
					.sin(sin),
					.cos(cos),
					
					.frequence(frequence),
					.theta(theta),			
					.done_sig(done_sig_PLL)
				  );
*/
PLL_control_system_water PLL(
			                .clk(clk),
			                .sta(sta_PLL),
			                .rst(rst),
			                .rst_user(rst_user),
			                .Va(Va_pu),
			                .Vb(Vb_pu),
			                .Vc(Vc_pu),
			                .cos(cos),
			                .sin(sin),
			                
			                .theta(theta),
			                .done_sig(done_sig_PLL)
			                );				  
				  				  
abc2dq0_water abc2dq0_V(
					   .clk(clk),
					   .rst(rst),
					   .Va(Va_reg),
					   .Vb(Vb_reg),
					   .Vc(Vc_reg),
						.sin_theta(sin),
					   .cos_theta(cos),

					   .Vd(Vd_abc2dq0),
					   .Vq(Vq_abc2dq0)
				     );


abc2dq0_water abc2dq0_I(
					   .clk(clk),
					   .rst(rst),
					   .Va(Ia_reg),
					   .Vb(Ib_reg),
					   .Vc(Ic_reg),
					   .sin_theta(sin),
					   .cos_theta(cos),
						
					   .Vd(Id_abc2dq0),
					   .Vq(Iq_abc2dq0)
				     );

wire sta_PQ_cal;
DELAY_1CLK #(140) Delay_sta_PQ_cal(
										 .clk(clk),
										 .rst(rst),
										 .d(sta),
										 .q(sta_PQ_cal)
										 );
										 
PQ_cal_water PQ_cal(
				  .clk(clk),
				  .rst(rst),
				  .sta(sta_PQ_cal),
				  .Vd(Vd_abc2dq0),
				  .Vq(Vq_abc2dq0),
				  .Id(Id_abc2dq0),
				  .Iq(Iq_abc2dq0),
				  .P(P),
				  .Q(Q),
				  .done_sig(done_sig_PQ_cal)
				 );

DELAY_NCLK  #(32,151)  DELAY_NCLKVdc_reg(
						               .clk(clk),
											.rst(rst),
						               .d(Vdc_reg),
						               .q(Vdc_reg_delay)
					                 );					 
wire done_read_x_outloop;
DELAY_1CLK #(9) Delay_done_read_x_outloop(
										 .clk(clk),
										 .rst(rst),
										 .d(sta_PQ_cal),
										 .q(done_read_x_outloop)
										 );
				 				 				 
control_loop_water #(32'h3F0000A8 , 32'hBEFFFEB0  , 32'h3C23D923 , 32'hBC23D4F1) control_outer_loop(
																															 .clk(clk),
																															 .rst(rst),
																															 .rst_user(rst_user),
																															 .done_read_x(done_read_x_outloop),
																															 .sta(done_sig_PQ_cal),
																															 .input_1(Vdc_reg_delay),
																															 .input_2(const_Vdc_ref),
																															 .input_3(Q),
																															 .input_4(const_Q_ref),
																															 
																															 .output_1(Id_ref),
																															 .output_2(Iq_ref),
																															 .done_sig(done_sig_outer_loop)
																															);	
																															
																															
DELAY_NCLK  #(32,45)  DELAY_NCLKId_abc2dq0(
						               .clk(clk),
											.rst(rst),
						               .d(Id_abc2dq0),
						               .q(Id_abc2dq0_delay)
					                 );
										  
DELAY_NCLK  #(32,45)  DELAY_NCLKIq_abc2dq0(
						               .clk(clk),
											.rst(rst),
						               .d(Iq_abc2dq0),
						               .q(Iq_abc2dq0_delay)
					                 );	

wire done_read_x_inloop;
DELAY_1CLK #(20) Delay_done_read_x_inloop(
										 .clk(clk),
										 .rst(rst),
										 .d(done_sig_PQ_cal),
										 .q(done_read_x_inloop)
										 );
										  
									
control_loop_water #(32'h41200A3D , 32'hC11FF5C3  , 32'h41200A3D , 32'hC11FF5C3)  control_inner_loop(
																															  .clk(clk),
																															  .rst(rst),
																															  .rst_user(rst_user),
																															  .done_read_x(done_read_x_inloop),
																															  .sta(done_sig_outer_loop),
																															  .input_1(Id_ref),
																															  .input_2(Id_abc2dq0_delay),
																															  .input_3(Iq_ref),
																															  .input_4(Iq_abc2dq0_delay),
																															  
																															  .output_1(Vd_ref),
																															  .output_2(Vq_ref),
																															  .done_sig(done_sig_inner_loop)
																															 );
																															 
																															 
DELAY_NCLK  #(32,85)  DELAY_NCLKsin(
						               .clk(clk),
											.rst(rst),
						               .d(sin),
						               .q(sin_delay)
					                 );
										  
DELAY_NCLK  #(32,85)  DELAY_NCLKcos(
						               .clk(clk),
											.rst(rst),
						               .d(cos),
						               .q(cos_delay)
					                 );																																 
																															 																															 
dq02abc_water dq02abc(
					 .clk(clk),
					 .rst(rst),
					 .sta(done_sig_inner_loop),
					 .Vd(Vd_ref),
					 .Vq(Vq_ref),
					 .sin_theta(sin_delay),
					 .cos_theta(cos_delay),
					
					 .Va(Va_ref),
					 .Vb(Vb_ref),
					 .Vc(Vc_ref),
					 .done_sig(done_sig_dq02abc)
				   );
					
multiplier_control_system multiplier_Va_ref(
														  .clk(clk),
														  .rst(rst),
														  .sta(done_sig_dq02abc),
														  .x(Va_ref),
														  .y(const_inv_Vdc_ref),
														  .xy(Va_compare),
														  .done_sig(done_sig_Va_compare)
														 );//C53

multiplier_control_system multiplier_Vb_ref(
														  .clk(clk),
														  .rst(rst),
														  .sta(done_sig_dq02abc),
														  .x(Vb_ref),
														  .y(const_inv_Vdc_ref),
														  .xy(Vb_compare),
														  .done_sig(done_sig_Vb_compare)
														 );//C54
														
multiplier_control_system multiplier_Vc_ref(
														  .clk(clk),
														  .rst(rst),
														  .sta(done_sig_dq02abc),
														  .x(Vc_ref),
														  .y(const_inv_Vdc_ref),
														  .xy(Vc_compare),
														  .done_sig(done_sig_Vc_compare)
														 );//C55
		 
wire sta_Comparator;
assign sta_Comparator = done_sig_Va_compare;

PWM PWM(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sta),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out),
		  .done_sig(done_sig_PWM)
		 );

		 
Comparator Comparator_Va(
								 .clk(clk),
								 .rst(rst),
								 .sta(sta_Comparator),
								 .input_1(Va_compare),
								 .input_2(triangle_out),
								 .output_1(pwm_1),
								 .output_2(pwm_4),
								 .done_sig(done_sig_comparator_Va)
							   );
								
Comparator Comparator_Vb(
								 .clk(clk),
								 .rst(rst),
								 .sta(sta_Comparator),
								 .input_1(Vb_compare),
								 .input_2(triangle_out),
								 .output_1(pwm_3),
								 .output_2(pwm_6),
								 .done_sig(done_sig_comparator_Vb)
							   );
								
Comparator Comparator_Vc(
								 .clk(clk),
								 .rst(rst),
								 .sta(sta_Comparator),
								 .input_1(Vc_compare),
								 .input_2(triangle_out),
								 .output_1(pwm_5),
								 .output_2(pwm_2),
								 .done_sig(done_sig_comparator_Vc)
							   );

wire sta_fifo_w,sta_SFM_w,sta_IphId_r;								
DELAY_1CLK #(2) Delay_sta_fifo_w(
													   .clk(clk),
													   .rst(rst),
													   .d(exchange_data_sig_delay),
													   .q(sta_fifo_w)
													  );
								
Source_Ctred_SFM_water  Source_Ctred_SFM_water(
				  .clk(clk),
				  .rst_user(rst_user),
				  .rst(rst),
				  .sta(done_sig_comparator_Va),
			
			     .sta_fifo_w(sta_fifo_w),
				  .Vdc(Vdc_reg),
				  .Ia_SFM_Inv(Ia_SFM_Inv_reg),
				  .Ic_SFM_Inv(Ic_SFM_Inv_reg),
				  					
				  .pwm_1(pwm_1),
				  .pwm_3(pwm_3),
				  .pwm_5(pwm_5),
				  				  
              .Idc_SFM(Idc_SFM),		
              .Uab_SFM_Inv(Uab_SFM_Inv),	
              .Ubc_SFM_Inv(Ubc_SFM_Inv),										 
				  .sta_SFM_w(sta_SFM_w),
				  .sta_IphId_r(sta_IphId_r)
				 );								
																								
wire sta_read_fifo;
					
PV_water PV(
		.clk(clk),
		.rst(rst),
		.sta(sta_interface),
		.sta_ad(done_ad_convert),
		.Vd(Vd_reg),
			 
		.Iph(Iph),
		.Id(Id),
		.sta_read_fifo(sta_read_fifo),
		.done_sig_Iph(done_sig_Iph),
		.done_sig_Id(done_sig_Id),
		.done_sig(done_sig_PV)
	  );
 
 
 
 /*************************PV END******************************/
 
 /*************************EXCHANGE******************************/
wire ena_write_I,ena_read;	
wire [`SINGLE - 1:0] source_output_single,Iph_fifo,Id_fifo;
wire ena_write_pwm,ena_read_pwm;
													 
System_FIFO_32   FIFO_Iph(
								.clk(clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_IphId_r),
								.before_enawrite(done_sig_Iph),
								.cin( Iph ),
								.cout( Iph_fifo )
							  );
							  
System_FIFO_32   FIFO_Id(
								.clk(clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_IphId_r),
								.before_enawrite(done_sig_Id),
								.cin( Id ),
								.cout( Id_fifo )
							  );
							  
generate_ena #(`N_PV ) generate_ena_WTI(
						.clk(clk),
						.rst(rst),
						.d(sta_SFM_w),
						.q(ena_write_I)
					  );
						  
generate_ena #(`N_PV_Eights ) generate_ena_readI(
						.clk(clk),
						.rst(rst),
						.d(exchange_Source_sig),
						.q(ena_read)
					  );
					  
					  
FIFO_Source_Exchange	FIFO_PV_I (
	.data ( {32'h00000000,32'h00000000,32'h00000000,Ubc_SFM_Inv,Uab_SFM_Inv,Idc_SFM,Id_fifo,Iph_fifo} ),
	.rdclk ( clk ),
	.rdreq ( ena_read ),
	.wrclk ( clk ),
	.wrreq ( ena_write_I ),
	.q ( source_output_single )
	);
														  					  
SINGLE2EXTENDED_SINGLE	SINGLE2EXTENDED_SINGLE1100 (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(source_output_single),
													        .result(source_output)
													        );	
	


//generate_ena #(`N_PV ) generate_ena_pwm(
//						.clk(clk),
//						.rst(rst),
//						.d(done_sig_comparator_Va),
//						.q(ena_write_pwm)
//					  );
//					  				  					  				  
//generate_ena #(`N_PV) generate_ena_readpwm(
//						.clk(clk),
//						.rst(rst),
//						.d(exchange_Sig_sig),
//						.q(ena_read_pwm)
//					  );
//					  
//FIFO_Sig_Exchange	FIFO_PV_Sig (
//	.clock ( clk ),
//	.data ( {1'b0,1'b0,pwm_6,pwm_5,pwm_4,pwm_3,pwm_2,pwm_1} ),
//	.rdreq ( ena_read_pwm ),
//	.wrreq ( ena_write_pwm ),
//	.q ( gate_signal_output )
//	);
 
 

endmodule
