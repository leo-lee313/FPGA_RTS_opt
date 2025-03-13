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
///////////////////////////////////////////////////////////////////////////////////////////////////////////C13PV
parameter A_PLL_PI1_lyf = 64'h40668075f6fd21ff;
parameter B_PLL_PI1_lyf = 64'hc0667f8a0902de01;
parameter A_PLL_PI2_lyf = 64'h3ed2dfd694ccab3f;
parameter B_PLL_PI2_lyf = 64'h3ed2dfd694ccab3f;
parameter A_OUT_PI1_lyf = 64'h3fe00012dfd694cd;
parameter B_OUT_PI1_lyf = 64'hbfdfffda4052d667;
parameter A_OUT_PI2_lyf = 64'h3f847b1dad8ff0a4;
parameter B_OUT_PI2_lyf = 64'hbf847aa4e1cc3852;
parameter A_IN_PI1_lyf = 64'h40240126e978d4fe;
parameter B_IN_PI1_lyf = 64'hc023fed916872b02;
parameter A_IN_PI2_lyf = 64'h40240126e978d4fe;
parameter B_IN_PI2_lyf = 64'hc023fed916872b02;

parameter const_0_lyf = 64'h0000000000000000;
parameter const_2pi_lyf = 64'h401921fb54411744;
parameter const_1_lyf = 64'h3ff0000000000000;
parameter const_Vdc_ref_lyf = 64'h4075e00000000000;
parameter Tref_lyf = 64'h4072a00000000000;
parameter const_Q_ref_lyf = 64'h0000000000000000;
parameter const_fu1_lyf = 64'hbff0000000000000;
parameter const_2_lyf = 64'h4000000000000000;
parameter const_inv_20_lyf = 64'h3fb1eb851eb851ec;
parameter const_1_divide_3_lyf = 64'h3fd5555554f9b516;
parameter Np_Isref_divide_Sref_lyf = 64'h3f9edfa43fe5c91d;
parameter Np_Isref_J_lyf = 64'h3f94115df6555c53;
parameter const_sqrt_inv_3_lyf = 64'h3fe279a74576233f;
parameter const_3_divide_2_lyf = 64'h3ff8000000000000;
parameter Ns_n_ff3_lyf = 64'h3fb7d8adab9f559b;
parameter const_1_divide_2_lyf = 64'h3fe0000000000000;
parameter const_inv_Vdc_ref_lyf = 64'h3f6767dcf7d70071;
parameter const_inv_3_lyf = 64'h3fd5555554f9b516;
parameter const_sqrt_3_divide_3_lyf = 64'h3fe279a74576233f;
parameter const_sqrt_3_divide_2_lyf = 64'h3febb67ae875ed0f;


///////////////////////////////////////////////////////////////////////////////////////////////////////////C19PV

reg [11:0] counter;
always @ ( posedge clk or posedge sta) begin
	if(sta) 
	   begin
		   counter <= 12'd0;
		end
	else begin
		   counter <= counter + 12'd1;
   end
end
wire [1000:0] sta_sig;
signalgene signalgene(
													   .clk(clk),
													   .sta(sta),
														.sim_time(sim_time),
													   .counter(counter),
													   .done_sig(sta_sig)
													  );	
													  
reg outsig_1;

outsig outsig(
					.clk(clk),
					.rst_user(rst_user),
					.sim_time(sim_time),
				
					.outsig(outsig_1)
);														  
parameter INTEGER = 10;
parameter ADDR_Ids = 7;
parameter ena_math = 1'b1;
wire [`SINGLE - 1:0] S32_lyf;
wire [`SINGLE - 1:0] T32_lyf;
wire [`SINGLE - 1:0] T32_delay_lyf;
wire [`EXTENDED_SINGLE - 1:0] S_lyf;
SINGLE2EXTENDED_SINGLE	single2float_S_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(S32_lyf),
													        .result(S_lyf)
													        );
wire [`EXTENDED_SINGLE - 1:0] T_lyf;
SINGLE2EXTENDED_SINGLE	single2float_T_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(T32_lyf),
													        .result(T_lyf)
													        );
wire [`EXTENDED_SINGLE - 1:0] T_delay_lyf;
SINGLE2EXTENDED_SINGLE	single2float_T_delay_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(T32_delay_lyf),
													        .result(T_delay_lyf)
													        );
wire ena_cal_S;
wire [4:0] addr_S;
wire [INTEGER - 1:0] address_lyf;
wire [ADDR_Ids - 1:0] address_1_lyf;
wire [ADDR_Ids - 1:0] address_2_lyf;
wire [`SINGLE - 1:0] Ids32_1_lyf;
wire [`SINGLE - 1:0] Ids32_2_lyf;
wire [`SINGLE - 1:0] address_float32_lyf;
wire [`EXTENDED_SINGLE - 1:0] Ids_1_lyf;
SINGLE2EXTENDED_SINGLE	single2float_Ids_1_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ids32_1_lyf),
													        .result(Ids_1_lyf)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ids_2_lyf;
SINGLE2EXTENDED_SINGLE	single2float_Ids_2_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ids32_2_lyf),
													        .result(Ids_2_lyf)
													        );
wire [`EXTENDED_SINGLE - 1:0] address_float_lyf;
SINGLE2EXTENDED_SINGLE	single2float_address_float_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(address_float32_lyf),
													        .result(address_float_lyf)
													        );
ADDR #( 5 , `N_PV , 1 , 0 ) ADDR_S(
					  .clk(clk),
					  .rst(rst),
					  .sta(sta_sig[2]),
					  .addr(addr_S),
					  .ena_cal(ena_cal_S)
					  );

radiation_intensity 	radiation_intensity(
					.aclr(rst),
					.clock(clk),
				   .clken(`ena_math),
					.address(addr_S),
					.rden(ena_cal_S),
					.q(S32_lyf)
					);

absolute_temper 	absolute_temper(
					.aclr(rst),
					.clock(clk),
				   .clken(`ena_math),
					.address(addr_S),
					.rden(ena_cal_S),
					.q(T32_lyf)
					);
					
DELAY_NCLK  #(32,1)  DELAY_NCLK0(
						               .clk(clk),
											.rst(rst),
						               .d(T32_lyf),
						               .q(T32_delay_lyf)
					                 );
										  
FLOAT2INTEGER_PV	FLOAT2INTEGER_PV(
											  .aclr(rst),
											  .clk_en(ena_math),
											  .clock(clk),
											  .dataa(T32_lyf),
											  .result(address_lyf)
											 );

assign address_1_lyf = address_lyf - 9'd273;
assign address_2_lyf = address_lyf - 9'd272;

Ids_mem	Ids_mem1(
						.aclr(rst),
						.address(address_1_lyf),
						.clken(ena_math),
						.clock(clk),
						.q(Ids32_1_lyf)
					  );
						
Ids_mem	Ids_mem2(
						.aclr(rst),
						.address(address_2_lyf),
						.clken(ena_math),
						.clock(clk),
						.q(Ids32_2_lyf)
					  );
					  
INTEGER2FLOAT_PV	INTEGER2FLOAT_PV(
												.aclr(rst),
												.clk_en(ena_math),
												.clock(clk),
												.dataa(address_lyf),
												.result(address_float32_lyf)
											  );
											  
											  
wire [`EXTENDED_SINGLE - 1:0] add_1_result;
wire [`EXTENDED_SINGLE - 1:0] add_2_result;
wire [`EXTENDED_SINGLE - 1:0] add_3_result;
wire [`EXTENDED_SINGLE - 1:0] add_4_result;
wire [`EXTENDED_SINGLE - 1:0] add_5_result;
wire [`EXTENDED_SINGLE - 1:0] add_6_result;
wire [`EXTENDED_SINGLE - 1:0] add_7_result;
wire [`EXTENDED_SINGLE - 1:0] mul_1_result;
wire [`EXTENDED_SINGLE - 1:0] mul_2_result;
wire [`EXTENDED_SINGLE - 1:0] mul_3_result;
wire [`EXTENDED_SINGLE - 1:0] mul_4_result;
wire [`EXTENDED_SINGLE - 1:0] mul_5_result;
wire [`EXTENDED_SINGLE - 1:0] mul_6_result;
wire [`EXTENDED_SINGLE - 1:0] mul_7_result;
wire [`EXTENDED_SINGLE - 1:0] mul_8_result;
wire [`EXTENDED_SINGLE - 1:0] mul_9_result;
wire [`EXTENDED_SINGLE - 1:0] mul_10_result;
wire [`EXTENDED_SINGLE - 1:0] div_1_result;
wire [`EXTENDED_SINGLE - 1:0] sin_1_result;
wire [`EXTENDED_SINGLE - 1:0] sin_1_A_ctrl_fuyong_32;
wire [`EXTENDED_SINGLE - 1:0] sin_1_B_ctrl_fuyong_32;
wire [`EXTENDED_SINGLE - 1:0] sin_1_C_ctrl_fuyong_32;
wire [`SINGLE - 1:0] sin_1_result_32;
reg [`EXTENDED_SINGLE - 1:0] sin_1_theta;
wire [`SINGLE - 1:0] sin_1_theta_32;
wire [`EXTENDED_SINGLE - 1:0] cos_1_result;
wire [`EXTENDED_SINGLE - 1:0] cos_1_A_ctrl_fuyong_32;
wire [`EXTENDED_SINGLE - 1:0] cos_1_B_ctrl_fuyong_32;
wire [`EXTENDED_SINGLE - 1:0] cos_1_C_ctrl_fuyong_32;
wire [`SINGLE - 1:0] cos_1_result_32;
reg [`EXTENDED_SINGLE - 1:0] cos_1_theta;
wire [`SINGLE - 1:0] cos_1_theta_32;
reg [`EXTENDED_SINGLE - 1:0] compare_1_reg;
wire compareone_1_lyf;
wire [`EXTENDED_SINGLE - 1:0] compare_1_lyf;
reg [`EXTENDED_SINGLE - 1:0] compare_2_reg;
wire compareone_2_lyf;
wire [`EXTENDED_SINGLE - 1:0] compare_2_lyf;
reg [`EXTENDED_SINGLE - 1:0] compare_3_reg;
wire compareone_3_lyf;
wire [`EXTENDED_SINGLE - 1:0] compare_3_lyf;
wire [`EXTENDED_SINGLE - 1:0] exp_1_result;

////////////////////////////////////////////////////////////////////////////////////////////////////////////C15
wire [`SINGLE - 1:0] Vb32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Vb32(
						               .clk(clk),
											.rst(rst),
						               .d(Vb),
						               .q(Vb32)
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vb_64;
SINGLE2EXTENDED_SINGLE	single2float_Vb(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vb32),
													        .result(Vb_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Vb_64_117;
System_FIFO_64_1	FIFO_Vb_64_117 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[125]),
											.before_enawrite(sta_sig[10]),
								.cin( Vb_64 ),
								.cout( Vb_64_117 )
					                 );
										  
wire [`SINGLE - 1:0] Vc32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Vc32(
						               .clk(clk),
											.rst(rst),
						               .d(Vc),
						               .q(Vc32)
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vc_64;
SINGLE2EXTENDED_SINGLE	single2float_Vc(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vc32),
													        .result(Vc_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Vc_64_117;
System_FIFO_64_1	FIFO_Vc_64_117 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[125]),
											.before_enawrite(sta_sig[10]),
								.cin( Vc_64 ),
								.cout( Vc_64_117 )
					                 );
										  
wire [`SINGLE - 1:0] Ib32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Ib32(
						               .clk(clk),
											.rst(rst),
						               .d(Ib),
						               .q(Ib32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Ib_64;
SINGLE2EXTENDED_SINGLE	single2float_Ib(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ib32),
													        .result(Ib_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ib_64_68;
System_FIFO_64_1	FIFO_Ib_64_68 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[76]),
											.before_enawrite(sta_sig[10]),
								.cin( Ib_64 ),
								.cout( Ib_64_68 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ib_64_117;
System_FIFO_64_1	FIFO_Ib_64_117 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[125]),
											.before_enawrite(sta_sig[10]),
								.cin( Ib_64 ),
								.cout( Ib_64_117 )
					                 );
										  
wire [`SINGLE - 1:0] Ic32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Ic32(
						               .clk(clk),
											.rst(rst),
						               .d(Ic),
						               .q(Ic32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Ic_64;
SINGLE2EXTENDED_SINGLE	single2float_Ic(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ic32),
													        .result(Ic_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ic_64_68;
System_FIFO_64_1	FIFO_Ic_64_68 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[76]),
											.before_enawrite(sta_sig[10]),
								.cin( Ic_64 ),
								.cout( Ic_64_68 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ic_64_117;
System_FIFO_64_1	FIFO_Ic_64_117 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[125]),
											.before_enawrite(sta_sig[10]),
								.cin( Ic_64 ),
								.cout( Ic_64_117 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vb_64_20;
System_FIFO_64_1	FIFO_Vb_64_20 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[28]),
											.before_enawrite(sta_sig[10]),
								.cin( Vb_64 ),
								.cout( Vb_64_20 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vc_64_20;
System_FIFO_64_1	FIFO_Vc_64_20 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[28]),
											.before_enawrite(sta_sig[10]),
								.cin( Vc_64 ),
								.cout( Vc_64_20 )
					                 );
										  
wire [`SINGLE - 1:0] Vdc32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Vdc32(
						               .clk(clk),
											.rst(rst),
						               .d(Vdc),
						               .q(Vdc32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vdc_64;
SINGLE2EXTENDED_SINGLE	single2float_Vdc(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vdc32),
													        .result(Vdc_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Vdc_64_173;
System_FIFO_64_1	FIFO_Vdc_64_173 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[181]),
											.before_enawrite(sta_sig[10]),
								.cin( Vdc_64 ),
								.cout( Vdc_64_173 )
					                 );
										  
wire [`SINGLE - 1:0] Ia32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Ia32(
						               .clk(clk),
											.rst(rst),
						               .d(Ia),
						               .q(Ia32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Ia_64;
SINGLE2EXTENDED_SINGLE	single2float_Ia(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ia32),
													        .result(Ia_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ia_64_119;
System_FIFO_64_1	FIFO_Ia_64_119 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[127]),
											.before_enawrite(sta_sig[10]),
								.cin( Ia_64 ),
								.cout( Ia_64_119 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vdc_64_277;
System_FIFO_64_1	FIFO_Vdc_64_277 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[285]),
											.before_enawrite(sta_sig[10]),
								.cin( Vdc_64 ),
								.cout( Vdc_64_277 )
					                 );
										  
wire [`SINGLE - 1:0] Ia_SFM_Inv32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Ia_SFM_Inv32(
						               .clk(clk),
											.rst(rst),
						               .d(Ia_SFM_Inv),
						               .q(Ia_SFM_Inv32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Ia_SFM_Inv_64;
SINGLE2EXTENDED_SINGLE	single2float_Ia_SFM_Inv(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ia_SFM_Inv32),
													        .result(Ia_SFM_Inv_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ia_SFM_Inv_64_283;
System_FIFO_64_1	FIFO_Ia_SFM_Inv_64_283 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[291]),
											.before_enawrite(sta_sig[10]),
								.cin( Ia_SFM_Inv_64 ),
								.cout( Ia_SFM_Inv_64_283 )
					                 );
										  
wire [`SINGLE - 1:0] Va32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Va32(
						               .clk(clk),
											.rst(rst),
						               .d(Va),
						               .q(Va32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Va_64;
SINGLE2EXTENDED_SINGLE	single2float_Va(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Va32),
													        .result(Va_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Va_64_2;
DELAY_NCLK  #(64,2)  DELAY_NCLK_Va_64_2(
						               .clk(clk),
											.rst(rst),
						               .d(Va_64),
						               .q(Va_64_2)
					                 );
										  
wire [`SINGLE - 1:0] Ic_SFM_Inv32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Ic_SFM_Inv32(
						               .clk(clk),
											.rst(rst),
						               .d(Ic_SFM_Inv),
						               .q(Ic_SFM_Inv32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Ic_SFM_Inv_64;
SINGLE2EXTENDED_SINGLE	single2float_Ic_SFM_Inv(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ic_SFM_Inv32),
													        .result(Ic_SFM_Inv_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ic_SFM_Inv_64_283;
System_FIFO_64_1	FIFO_Ic_SFM_Inv_64_283 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[291]),
											.before_enawrite(sta_sig[10]),
								.cin( Ic_SFM_Inv_64 ),
								.cout( Ic_SFM_Inv_64_283 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Va_64_119;
System_FIFO_64_1	FIFO_Va_64_119 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[127]),
											.before_enawrite(sta_sig[10]),
								.cin( Va_64 ),
								.cout( Va_64_119 )
					                 );
										  
wire [`SINGLE - 1:0] Vd32;
DELAY_NCLK  #(32,5)  DELAY_NCLK_Vd32(
						               .clk(clk),
											.rst(rst),
						               .d(Vd),
						               .q(Vd32)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vd_64;
SINGLE2EXTENDED_SINGLE	single2float_Vd(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vd32),
													        .result(Vd_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Vd_64_238;
System_FIFO_64_1	FIFO_Vd_64_238 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[246]),
											.before_enawrite(sta_sig[10]),
								.cin( Vd_64 ),
								.cout( Vd_64_238 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vdc_64_297;
System_FIFO_64_1	FIFO_Vdc_64_297 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[305]),
											.before_enawrite(sta_sig[10]),
								.cin( Vdc_64 ),
								.cout( Vdc_64_297 )
					                 );

///////////////////////////////////////////////////////////////////////////////////////////////////////////C16

wire [`EXTENDED_SINGLE - 1:0] y_reg_PLL_PI2;
System_FIFO_64_1	FIFO_y_reg_PLL_PI2 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[78]),
											.before_enawrite(sta_sig[106]),
								.cin( sin_1_theta ),
								.cout( y_reg_PLL_PI2 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] y_reg_PLL_PI1;
System_FIFO_64_1	FIFO_y_reg_PLL_PI1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[56]),
											.before_enawrite(sta_sig[74]),
								.cin( add_3_result ),
								.cout( y_reg_PLL_PI1 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_OUT_PI1;
System_FIFO_64_1	FIFO_y_reg_OUT_PI1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[195]),
											.before_enawrite(sta_sig[213]),
								.cin( add_3_result ),
								.cout( y_reg_OUT_PI1 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_IN_PI2;
System_FIFO_64_1	FIFO_y_reg_IN_PI2 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[225]),
											.before_enawrite(sta_sig[243]),
								.cin( add_3_result ),
								.cout( y_reg_IN_PI2 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_OUT_PI2;
System_FIFO_64_1	FIFO_y_reg_OUT_PI2 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[195]),
											.before_enawrite(sta_sig[213]),
								.cin( add_4_result ),
								.cout( y_reg_OUT_PI2 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_IN_PI1;
System_FIFO_64_1	FIFO_y_reg_IN_PI1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[225]),
											.before_enawrite(sta_sig[243]),
								.cin( add_2_result ),
								.cout( y_reg_IN_PI1 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_7_result_20;
DELAY_NCLK  #(64,20)  DELAY_NCLK_add_7_result_20(
						               .clk(clk),
											.rst(rst),
						               .d(add_7_result),
						               .q(add_7_result_20)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_OUT_PI2;
System_FIFO_64_1	FIFO_x_reg_OUT_PI2 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[197]),
											.before_enawrite(sta_sig[211]),
								.cin( add_7_result_20 ),
								.cout( x_reg_OUT_PI2 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_5_result_20;
DELAY_NCLK  #(64,20)  DELAY_NCLK_add_5_result_20(
						               .clk(clk),
											.rst(rst),
						               .d(add_5_result),
						               .q(add_5_result_20)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_IN_PI1;
System_FIFO_64_1	FIFO_x_reg_IN_PI1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[227]),
											.before_enawrite(sta_sig[241]),
								.cin( add_5_result_20 ),
								.cout( x_reg_IN_PI1 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_6_result_20;
DELAY_NCLK  #(64,20)  DELAY_NCLK_add_6_result_20(
						               .clk(clk),
											.rst(rst),
						               .d(add_6_result),
						               .q(add_6_result_20)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_PLL_PI1;
System_FIFO_64_1	FIFO_x_reg_PLL_PI1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[58]),
											.before_enawrite(sta_sig[72]),
								.cin( add_6_result_20 ),
								.cout( x_reg_PLL_PI1 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] x_reg_IN_PI2;
System_FIFO_64_1	FIFO_x_reg_IN_PI2 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[227]),
											.before_enawrite(sta_sig[241]),
								.cin( add_6_result_20 ),
								.cout( x_reg_IN_PI2 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_reg_PLL;
System_FIFO_64_1	FIFO_sin_reg_PLL (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[28]),
											.before_enawrite(sta_sig[149]),
								.cin( sin_1_result ),
								.cout( sin_reg_PLL )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_3_result_20;
DELAY_NCLK  #(64,20)  DELAY_NCLK_add_3_result_20(
						               .clk(clk),
											.rst(rst),
						               .d(add_3_result),
						               .q(add_3_result_20)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_PLL_PI2;
System_FIFO_64_1	FIFO_x_reg_PLL_PI2 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[80]),
											.before_enawrite(sta_sig[94]),
								.cin( add_3_result_20 ),
								.cout( x_reg_PLL_PI2 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_reg_PLL;
System_FIFO_64_1	FIFO_cos_reg_PLL (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[36]),
											.before_enawrite(sta_sig[148]),
								.cin( cos_1_result ),
								.cout( cos_reg_PLL )
					                 );

wire [`EXTENDED_SINGLE - 1:0] x_reg_OUT_PI1;
System_FIFO_64_1	FIFO_x_reg_OUT_PI1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[197]),
											.before_enawrite(sta_sig[211]),
								.cin( add_6_result_20 ),
								.cout( x_reg_OUT_PI1 )
					                 );

///////////////////////////////////////////////////////////////////////////////////////////////////////////C12

wire [`EXTENDED_SINGLE - 1:0] mul_4_result_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_mul_4_result_1(
						               .clk(clk),
											.rst(rst),
						               .d(mul_4_result),
						               .q(mul_4_result_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_5_result_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_mul_5_result_1(
						               .clk(clk),
											.rst(rst),
						               .d(mul_5_result),
						               .q(mul_5_result_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_3_result_FIFO_50;
System_FIFO_64_1	FIFO_add_3_result_FIFO_50 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[211]),
											.before_enawrite(sta_sig[163]),
								.cin( add_3_result ),
								.cout( add_3_result_FIFO_50 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_7_result_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_mul_7_result_8(
						               .clk(clk),
											.rst(rst),
						               .d(mul_7_result),
						               .q(mul_7_result_8)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_2_result_FIFO_50;
System_FIFO_64_1	FIFO_add_2_result_FIFO_50 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[211]),
											.before_enawrite(sta_sig[163]),
								.cin( add_2_result ),
								.cout( add_2_result_FIFO_50 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_1_result_FIFO_94;
System_FIFO_64_1	FIFO_sin_1_result_FIFO_94 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[241]),
											.before_enawrite(sta_sig[149]),
								.cin( sin_1_result ),
								.cout( sin_1_result_FIFO_94 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_1_result_FIFO_95;
System_FIFO_64_1	FIFO_cos_1_result_FIFO_95 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[241]),
											.before_enawrite(sta_sig[148]),
								.cin( cos_1_result ),
								.cout( cos_1_result_FIFO_95 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_1_result_FIFO_108;
System_FIFO_64_1	FIFO_sin_1_result_FIFO_108 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[255]),
											.before_enawrite(sta_sig[149]),
								.cin( sin_1_result ),
								.cout( sin_1_result_FIFO_108 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_1_result_FIFO_98;
System_FIFO_64_1	FIFO_mul_1_result_FIFO_98 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[146]),
											.before_enawrite(sta_sig[50]),
								.cin( mul_1_result ),
								.cout( mul_1_result_FIFO_98 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_1_result_FIFO_109;
System_FIFO_64_1	FIFO_cos_1_result_FIFO_109 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[255]),
											.before_enawrite(sta_sig[148]),
								.cin( cos_1_result ),
								.cout( cos_1_result_FIFO_109 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_9_result_FIFO_50;
System_FIFO_64_1	FIFO_mul_9_result_FIFO_50 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[146]),
											.before_enawrite(sta_sig[98]),
								.cin( mul_9_result ),
								.cout( mul_9_result_FIFO_50 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] cos_1_result_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_cos_1_result_1(
						               .clk(clk),
											.rst(rst),
						               .d(cos_1_result),
						               .q(cos_1_result_1)
					                 );

wire [`EXTENDED_SINGLE - 1:0] mul_10_result_FIFO_105;
System_FIFO_64_1	FIFO_mul_10_result_FIFO_105 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[147]),
											.before_enawrite(sta_sig[44]),
								.cin( mul_10_result ),
								.cout( mul_10_result_FIFO_105 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_1_result_FIFO_14;
System_FIFO_64_1	FIFO_add_1_result_FIFO_14 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[269]),
											.before_enawrite(sta_sig[257]),
								.cin( add_1_result ),
								.cout( add_1_result_FIFO_14 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] mul_8_result_FIFO_57;
System_FIFO_64_1	FIFO_mul_8_result_FIFO_57 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[147]),
											.before_enawrite(sta_sig[92]),
								.cin( mul_8_result ),
								.cout( mul_8_result_FIFO_57 )
					                 );

										  
///////////////////////////////////////////////////////////////////////////////////////////////////////////C11

wire [`EXTENDED_SINGLE - 1:0] add_1_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd60),//5
															  .value_1(mul_2_result),
															  .time_2(12'd98),//10
															  .value_2(add_6_result),
															  .time_3(12'd157),//16
															  .value_3(mul_8_result),
															  .time_4(12'd199),//26
															  .value_4(mul_8_result),
															  .time_5(12'd229),//34
															  .value_5(mul_3_result),
															  .time_6(12'd251),//40
															  .value_6(mul_1_result),
															  .time_7(12'd287),//50
															  .value_7(Ids_1_lyf),
													        .y(add_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_1_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd60),//5
															  .value_1(y_reg_PLL_PI1),
															  .time_2(12'd98),//10
															  .value_2(const_0_lyf),
															  .time_3(12'd157),//16
															  .value_3(mul_4_result_1),
															  .time_4(12'd199),//26
															  .value_4(y_reg_OUT_PI1),
															  .time_5(12'd229),//34
															  .value_5(y_reg_IN_PI2),
															  .time_6(12'd251),//40
															  .value_6(mul_2_result),
															  .time_7(12'd287),//50
															  .value_7(mul_10_result),
													        .y(add_1_B_ctrl_fuyong)
													        );	
wire add_1_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_7 add_1_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd60),//5
															  .value_1(`add),
															  .time_2(12'd98),//10
															  .value_2(`sub),
															  .time_3(12'd157),//16
															  .value_3(`add),
															  .time_4(12'd199),//26
															  .value_4(`add),
															  .time_5(12'd229),//34
															  .value_5(`add),
															  .time_6(12'd251),//40
															  .value_6(`add),
															  .time_7(12'd287),//50
															  .value_7(`add),
													        .y(add_1_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_2_A_ctrl_fuyong;	
ctrl_time_8 ctrl_time_add_2_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd18),//1
															  .value_1(mul_3_result),
															  .time_2(12'd60),//47
															  .value_2(mul_3_result),
															  .time_3(12'd98),//11
															  .value_3(add_6_result),
															  .time_4(12'd157),//20
															  .value_4(mul_9_result),
															  .time_5(12'd199),//28
															  .value_5(mul_9_result),
															  .time_6(12'd237),//33
															  .value_6(add_7_result),
															  .time_7(12'd265),//41
															  .value_7(mul_3_result),
															  .time_8(12'd287),//51
															  .value_8(exp_1_result),
													        .y(add_2_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_2_B_ctrl_fuyong;	
ctrl_time_8 ctrl_time_add_2_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd18),//1
															  .value_1(mul_2_result),
															  .time_2(12'd60),//47
															  .value_2(mul_4_result),
															  .time_3(12'd98),//11
															  .value_3(const_2pi_lyf),
															  .time_4(12'd157),//20
															  .value_4(mul_10_result),
															  .time_5(12'd199),//28
															  .value_5(y_reg_OUT_PI2),
															  .time_6(12'd237),//33
															  .value_6(mul_4_result),
															  .time_7(12'd265),//41
															  .value_7(mul_4_result),
															  .time_8(12'd287),//51
															  .value_8(const_1_lyf),
													        .y(add_2_B_ctrl_fuyong)
													        );	
wire add_2_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_8 add_2_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd18),//1
															  .value_1(`add),
															  .time_2(12'd60),//47
															  .value_2(`add),
															  .time_3(12'd98),//11
															  .value_3(`add),
															  .time_4(12'd157),//20
															  .value_4(`add),
															  .time_5(12'd199),//28
															  .value_5(`add),
															  .time_6(12'd237),//33
															  .value_6(`add),
															  .time_7(12'd265),//41
															  .value_7(`sub),
															  .time_8(12'd287),//51
															  .value_8(`sub),
													        .y(add_2_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_3_A_ctrl_fuyong;	
ctrl_time_8 ctrl_time_add_3_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd18),//2
															  .value_1(mul_3_result),
															  .time_2(12'd68),//6
															  .value_2(add_1_result),
															  .time_3(12'd129),//12
															  .value_3(Vb_64_117),
															  .time_4(12'd157),//21
															  .value_4(mul_1_result),
															  .time_5(12'd207),//27
															  .value_5(add_1_result),
															  .time_6(12'd237),//35
															  .value_6(add_1_result),
															  .time_7(12'd265),//42
															  .value_7(mul_6_result),
															  .time_8(12'd301),//45
															  .value_8(mul_3_result),
													        .y(add_3_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_3_B_ctrl_fuyong;	
ctrl_time_8 ctrl_time_add_3_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd18),//2
															  .value_1(mul_2_result),
															  .time_2(12'd68),//6
															  .value_2(mul_5_result),
															  .time_3(12'd129),//12
															  .value_3(Vc_64_117),
															  .time_4(12'd157),//21
															  .value_4(mul_5_result_1),
															  .time_5(12'd207),//27
															  .value_5(mul_10_result),
															  .time_6(12'd237),//35
															  .value_6(mul_5_result),
															  .time_7(12'd265),//42
															  .value_7(mul_5_result),
															  .time_8(12'd301),//45
															  .value_8(mul_4_result),
													        .y(add_3_B_ctrl_fuyong)
													        );	
wire add_3_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_8 add_3_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd18),//2
															  .value_1(`sub),
															  .time_2(12'd68),//6
															  .value_2(`add),
															  .time_3(12'd129),//12
															  .value_3(`add),
															  .time_4(12'd157),//21
															  .value_4(`add),
															  .time_5(12'd207),//27
															  .value_5(`add),
															  .time_6(12'd237),//35
															  .value_6(`add),
															  .time_7(12'd265),//42
															  .value_7(`sub),
															  .time_8(12'd301),//45
															  .value_8(`sub),
													        .y(add_3_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_4_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_4_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd26),//3
															  .value_1(mul_5_result),
															  .time_2(12'd80),//18
															  .value_2(Ib_64_68),
															  .time_3(12'd129),//17
															  .value_3(Ib_64_117),
															  .time_4(12'd171),//22
															  .value_4(mul_2_result),
															  .time_5(12'd207),//29
															  .value_5(add_2_result),
															  .time_6(12'd251),//36
															  .value_6(mul_10_result),
															  .time_7(12'd273),//48
															  .value_7(Ids_2_lyf),
													        .y(add_4_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_4_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_4_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd26),//3
															  .value_1(add_2_result),
															  .time_2(12'd80),//18
															  .value_2(Ic_64_68),
															  .time_3(12'd129),//17
															  .value_3(Ic_64_117),
															  .time_4(12'd171),//22
															  .value_4(mul_3_result),
															  .time_5(12'd207),//29
															  .value_5(mul_1_result),
															  .time_6(12'd251),//36
															  .value_6(mul_7_result),
															  .time_7(12'd273),//48
															  .value_7(Ids_1_lyf),
													        .y(add_4_B_ctrl_fuyong)
													        );	
wire add_4_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_7 add_4_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd26),//3
															  .value_1(`sub),
															  .time_2(12'd80),//18
															  .value_2(`sub),
															  .time_3(12'd129),//17
															  .value_3(`add),
															  .time_4(12'd171),//22
															  .value_4(`add),
															  .time_5(12'd207),//29
															  .value_5(`add),
															  .time_6(12'd251),//36
															  .value_6(`sub),
															  .time_7(12'd273),//48
															  .value_7(`sub),
													        .y(add_4_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_5_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_5_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd32),//13
															  .value_1(Vb_64_20),
															  .time_2(12'd82),//7
															  .value_2(mul_6_result),
															  .time_3(12'd137),//14
															  .value_3(mul_10_result),
															  .time_4(12'd171),//23
															  .value_4(mul_4_result),
															  .time_5(12'd215),//30
															  .value_5(add_3_result),
															  .time_6(12'd251),//37
															  .value_6(mul_8_result),
															  .time_7(12'd273),//49
															  .value_7(T_delay_lyf),
													        .y(add_5_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_5_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_5_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd32),//13
															  .value_1(Vc_64_20),
															  .time_2(12'd82),//7
															  .value_2(y_reg_PLL_PI2),
															  .time_3(12'd137),//14
															  .value_3(add_3_result),
															  .time_4(12'd171),//23
															  .value_4(mul_5_result),
															  .time_5(12'd215),//30
															  .value_5(add_3_result_FIFO_50),
															  .time_6(12'd251),//37
															  .value_6(mul_9_result),
															  .time_7(12'd273),//49
															  .value_7(address_float_lyf),
													        .y(add_5_B_ctrl_fuyong)
													        );	
wire add_5_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_7 add_5_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd32),//13
															  .value_1(`sub),
															  .time_2(12'd82),//7
															  .value_2(`add),
															  .time_3(12'd137),//14
															  .value_3(`sub),
															  .time_4(12'd171),//23
															  .value_4(`sub),
															  .time_5(12'd215),//30
															  .value_5(`sub),
															  .time_6(12'd251),//37
															  .value_6(`add),
															  .time_7(12'd273),//49
															  .value_7(`sub),
													        .y(add_5_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_6_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_6_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//4
															  .value_1(mul_9_result),
															  .time_2(12'd90),//8
															  .value_2(add_5_result),
															  .time_3(12'd137),//19
															  .value_3(mul_1_result),
															  .time_4(12'd185),//24
															  .value_4(Vdc_64_173),
															  .time_5(12'd215),//31
															  .value_5(add_4_result),
															  .time_6(12'd251),//38
															  .value_6(mul_7_result),
															  .time_7(12'd281),//43
															  .value_7(compare_1_lyf),
													        .y(add_6_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_6_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_6_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//4
															  .value_1(mul_7_result_8),
															  .time_2(12'd90),//8
															  .value_2(mul_7_result),
															  .time_3(12'd137),//19
															  .value_3(add_4_result),
															  .time_4(12'd185),//24
															  .value_4(const_Vdc_ref_lyf),
															  .time_5(12'd215),//31
															  .value_5(add_2_result_FIFO_50),
															  .time_6(12'd251),//38
															  .value_6(mul_10_result),
															  .time_7(12'd281),//43
															  .value_7(compare_2_lyf),
													        .y(add_6_B_ctrl_fuyong)
													        );	
wire add_6_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_7 add_6_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//4
															  .value_1(`sub),
															  .time_2(12'd90),//8
															  .value_2(`add),
															  .time_3(12'd137),//19
															  .value_3(`sub),
															  .time_4(12'd185),//24
															  .value_4(`sub),
															  .time_5(12'd215),//31
															  .value_5(`sub),
															  .time_6(12'd251),//38
															  .value_6(`add),
															  .time_7(12'd281),//43
															  .value_7(`sub),
													        .y(add_6_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_7_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_7_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//46
															  .value_1(T_lyf),
															  .time_2(12'd98),//9
															  .value_2(add_6_result),
															  .time_3(12'd157),//15
															  .value_3(mul_6_result),
															  .time_4(12'd185),//25
															  .value_4(mul_7_result),
															  .time_5(12'd229),//32
															  .value_5(mul_2_result),
															  .time_6(12'd251),//39
															  .value_6(mul_9_result),
															  .time_7(12'd281),//44
															  .value_7(compare_2_lyf),
													        .y(add_7_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_7_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_add_7_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//46
															  .value_1(Tref_lyf),
															  .time_2(12'd98),//9
															  .value_2(const_2pi_lyf),
															  .time_3(12'd157),//15
															  .value_3(mul_7_result),
															  .time_4(12'd185),//25
															  .value_4(const_Q_ref_lyf),
															  .time_5(12'd229),//32
															  .value_5(y_reg_IN_PI1),
															  .time_6(12'd251),//39
															  .value_6(mul_8_result),
															  .time_7(12'd281),//44
															  .value_7(compare_3_lyf),
													        .y(add_7_B_ctrl_fuyong)
													        );	
wire add_7_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_7 add_7_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//46
															  .value_1(`sub),
															  .time_2(12'd98),//9
															  .value_2(`sub),
															  .time_3(12'd157),//15
															  .value_3(`add),
															  .time_4(12'd185),//25
															  .value_4(`sub),
															  .time_5(12'd229),//32
															  .value_5(`add),
															  .time_6(12'd251),//39
															  .value_6(`sub),
															  .time_7(12'd281),//44
															  .value_7(`sub),
													        .y(add_7_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_1_A_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//17
															  .value_1(mul_10_result),
															  .time_2(12'd131),//21
															  .value_2(Ia_64_119),
															  .time_3(12'd151),//27
															  .value_3(mul_3_result),
															  .time_4(12'd201),//38
															  .value_4(B_OUT_PI2_lyf),
															  .time_5(12'd245),//51
															  .value_5(add_2_result),
															  .time_6(12'd289),//56
															  .value_6(Vdc_64_277),
													        .y(mul_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_1_B_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//17
															  .value_1(const_fu1_lyf),
															  .time_2(12'd131),//21
															  .value_2(const_2_lyf),
															  .time_3(12'd151),//27
															  .value_3(sin_1_result),
															  .time_4(12'd201),//38
															  .value_4(x_reg_OUT_PI2),
															  .time_5(12'd245),//51
															  .value_5(sin_1_result_FIFO_94),
															  .time_6(12'd289),//56
															  .value_6(add_6_result),
													        .y(mul_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_2_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_2_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//2
															  .value_1(Vb_64),
															  .time_2(12'd54),//9
															  .value_2(add_6_result),
															  .time_3(12'd145),//14
															  .value_3(add_5_result),
															  .time_4(12'd165),//29
															  .value_4(add_1_result),
															  .time_5(12'd223),//39
															  .value_5(add_5_result),
															  .time_6(12'd245),//52
															  .value_6(add_3_result),
															  .time_7(12'd289),//57
															  .value_7(Vdc_64_277),
													        .y(mul_2_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_2_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_2_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//2
															  .value_1(const_inv_20_lyf),
															  .time_2(12'd54),//9
															  .value_2(A_PLL_PI1_lyf),
															  .time_3(12'd145),//14
															  .value_3(const_1_divide_3_lyf),
															  .time_4(12'd165),//29
															  .value_4(add_3_result),
															  .time_5(12'd223),//39
															  .value_5(A_IN_PI1_lyf),
															  .time_6(12'd245),//52
															  .value_6(cos_1_result_FIFO_95),
															  .time_7(12'd289),//57
															  .value_7(add_7_result),
													        .y(mul_2_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_3_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_3_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//3
															  .value_1(Vc_64),
															  .time_2(12'd54),//60
															  .value_2(S_lyf),
															  .time_3(12'd145),//22
															  .value_3(add_6_result),
															  .time_4(12'd165),//30
															  .value_4(add_7_result),
															  .time_5(12'd223),//41
															  .value_5(add_6_result),
															  .time_6(12'd259),//47
															  .value_6(add_4_result),
															  .time_7(12'd295),//58
															  .value_7(mul_1_result),
													        .y(mul_3_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_3_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_3_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//3
															  .value_1(const_inv_20_lyf),
															  .time_2(12'd54),//60
															  .value_2(Np_Isref_divide_Sref_lyf),
															  .time_3(12'd145),//22
															  .value_3(const_1_divide_3_lyf),
															  .time_4(12'd165),//30
															  .value_4(add_2_result),
															  .time_5(12'd223),//41
															  .value_5(A_IN_PI2_lyf),
															  .time_6(12'd259),//47
															  .value_6(sin_1_result_FIFO_108),
															  .time_7(12'd295),//58
															  .value_7(Ia_SFM_Inv_64_283),
													        .y(mul_3_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_4_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_4_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd14),//1
															  .value_1(Va_64_2),
															  .time_2(12'd54),//61
															  .value_2(add_7_result),
															  .time_3(12'd150),//20
															  .value_3(mul_1_result_FIFO_98),
															  .time_4(12'd165),//32
															  .value_4(add_7_result),
															  .time_5(12'd231),//40
															  .value_5(B_IN_PI1_lyf),
															  .time_6(12'd259),//48
															  .value_6(add_5_result),
															  .time_7(12'd295),//59
															  .value_7(mul_2_result),
													        .y(mul_4_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_4_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_4_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd14),//1
															  .value_1(const_inv_20_lyf),
															  .time_2(12'd54),//61
															  .value_2(Np_Isref_J_lyf),
															  .time_3(12'd150),//20
															  .value_3(cos_1_result),
															  .time_4(12'd165),//32
															  .value_4(add_3_result),
															  .time_5(12'd231),//40
															  .value_5(x_reg_IN_PI1),
															  .time_6(12'd259),//48
															  .value_6(cos_1_result_FIFO_109),
															  .time_7(12'd295),//59
															  .value_7(Ic_SFM_Inv_64_283),
													        .y(mul_4_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_5_A_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_5_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//4
															  .value_1(mul_4_result),
															  .time_2(12'd62),//10
															  .value_2(B_PLL_PI1_lyf),
															  .time_3(12'd150),//28
															  .value_3(mul_9_result_FIFO_50),
															  .time_4(12'd165),//33
															  .value_4(add_1_result),
															  .time_5(12'd231),//42
															  .value_5(B_IN_PI2_lyf),
															  .time_6(12'd259),//49
															  .value_6(add_6_result),
															  .time_7(12'd295),//64
															  .value_7(add_1_result),
													        .y(mul_5_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_5_B_ctrl_fuyong;	
ctrl_time_7 ctrl_time_mul_5_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//4
															  .value_1(const_2_lyf),
															  .time_2(12'd62),//10
															  .value_2(x_reg_PLL_PI1),
															  .time_3(12'd150),//28
															  .value_3(cos_1_result),
															  .time_4(12'd165),//33
															  .value_4(add_2_result),
															  .time_5(12'd231),//42
															  .value_5(x_reg_IN_PI2),
															  .time_6(12'd259),//49
															  .value_6(sin_1_result_FIFO_108),
															  .time_7(12'd295),//64
															  .value_7(add_2_result),
													        .y(mul_5_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_6_A_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_6_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd26),//7
															  .value_1(add_3_result),
															  .time_2(12'd76),//11
															  .value_2(add_3_result),
															  .time_3(12'd151),//15
															  .value_3(mul_2_result),
															  .time_4(12'd179),//31
															  .value_4(add_4_result),
															  .time_5(12'd244),//63
															  .value_5(T_lyf),
															  .time_6(12'd259),//50
															  .value_6(add_7_result),
													        .y(mul_6_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_6_B_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_6_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd26),//7
															  .value_1(const_sqrt_inv_3_lyf),
															  .time_2(12'd76),//11
															  .value_2(A_PLL_PI2_lyf),
															  .time_3(12'd151),//15
															  .value_3(cos_1_result_1),
															  .time_4(12'd179),//31
															  .value_4(const_3_divide_2_lyf),
															  .time_5(12'd244),//63
															  .value_5(Ns_n_ff3_lyf),
															  .time_6(12'd259),//50
															  .value_6(cos_1_result_FIFO_109),
													        .y(mul_6_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_7_A_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_7_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd32),//8
															  .value_1(mul_6_result),
															  .time_2(12'd84),//12
															  .value_2(B_PLL_PI2_lyf),
															  .time_3(12'd151),//18
															  .value_3(mul_10_result_FIFO_105),
															  .time_4(12'd179),//34
															  .value_4(add_5_result),
															  .time_5(12'd245),//43
															  .value_5(add_2_result),
															  .time_6(12'd273),//53
															  .value_6(add_1_result_FIFO_14),
													        .y(mul_7_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_7_B_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_7_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd32),//8
															  .value_1(sin_reg_PLL),
															  .time_2(12'd84),//12
															  .value_2(x_reg_PLL_PI2),
															  .time_3(12'd151),//18
															  .value_3(sin_1_result),
															  .time_4(12'd179),//34
															  .value_4(const_3_divide_2_lyf),
															  .time_5(12'd245),//43
															  .value_5(const_1_divide_2_lyf),
															  .time_6(12'd273),//53
															  .value_6(const_inv_Vdc_ref_lyf),
													        .y(mul_7_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_8_A_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_8_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd34),//5
															  .value_1(add_4_result),
															  .time_2(12'd88),//24
															  .value_2(add_4_result),
															  .time_3(12'd151),//19
															  .value_3(mul_2_result),
															  .time_4(12'd193),//35
															  .value_4(add_6_result),
															  .time_5(12'd245),//44
															  .value_5(add_3_result),
															  .time_6(12'd273),//54
															  .value_6(add_2_result),
													        .y(mul_8_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_8_B_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_8_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd34),//5
															  .value_1(const_inv_3_lyf),
															  .time_2(12'd88),//24
															  .value_2(const_sqrt_3_divide_3_lyf),
															  .time_3(12'd151),//19
															  .value_3(sin_1_result),
															  .time_4(12'd193),//35
															  .value_4(A_OUT_PI1_lyf),
															  .time_5(12'd245),//44
															  .value_5(const_1_divide_2_lyf),
															  .time_6(12'd273),//54
															  .value_6(const_inv_Vdc_ref_lyf),
													        .y(mul_8_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_9_A_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_9_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//6
															  .value_1(mul_8_result),
															  .time_2(12'd94),//25
															  .value_2(mul_8_result),
															  .time_3(12'd151),//23
															  .value_3(mul_3_result),
															  .time_4(12'd193),//37
															  .value_4(add_7_result),
															  .time_5(12'd245),//45
															  .value_5(add_2_result),
															  .time_6(12'd273),//55
															  .value_6(add_3_result),
													        .y(mul_9_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_9_B_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_9_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//6
															  .value_1(cos_reg_PLL),
															  .time_2(12'd94),//25
															  .value_2(const_fu1_lyf),
															  .time_3(12'd151),//23
															  .value_3(cos_1_result_1),
															  .time_4(12'd193),//37
															  .value_4(A_OUT_PI2_lyf),
															  .time_5(12'd245),//45
															  .value_5(const_sqrt_3_divide_2_lyf),
															  .time_6(12'd273),//55
															  .value_6(const_inv_Vdc_ref_lyf),
													        .y(mul_9_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_10_A_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_10_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//16
															  .value_1(add_5_result),
															  .time_2(12'd131),//13
															  .value_2(Va_64_119),
															  .time_3(12'd151),//26
															  .value_3(mul_8_result_FIFO_57),
															  .time_4(12'd201),//36
															  .value_4(B_OUT_PI1_lyf),
															  .time_5(12'd245),//46
															  .value_5(add_3_result),
															  .time_6(12'd281),//62
															  .value_6(add_4_result),
													        .y(mul_10_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_10_B_ctrl_fuyong;	
ctrl_time_6 ctrl_time_mul_10_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//16
															  .value_1(const_sqrt_3_divide_3_lyf),
															  .time_2(12'd131),//13
															  .value_2(const_2_lyf),
															  .time_3(12'd151),//26
															  .value_3(sin_1_result),
															  .time_4(12'd201),//36
															  .value_4(x_reg_OUT_PI1),
															  .time_5(12'd245),//46
															  .value_5(const_sqrt_3_divide_2_lyf),
															  .time_6(12'd281),//62
															  .value_6(add_5_result),
													        .y(mul_10_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] div_1_A_ctrl_fuyong;	
ctrl_time_2 ctrl_time_div_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd250),//2
															  .value_1(Vd_64_238),
															  .time_2(12'd309),//1
															  .value_2(add_3_result),
													        .y(div_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] div_1_B_ctrl_fuyong;	
ctrl_time_2 ctrl_time_div_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd250),//2
															  .value_1(mul_6_result),
															  .time_2(12'd309),//1
															  .value_2(Vdc_64_297),
													        .y(div_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] sin_1_A_ctrl_fuyong;	
ctrl_time_1 ctrl_time_sin_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd106),//1
															  .value_1(add_1_result),
													        .y(sin_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] sin_1_B_ctrl_fuyong;	
ctrl_time_1 ctrl_time_sin_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd106),//1
															  .value_1(add_7_result),
													        .y(sin_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] sin_1_C_ctrl_fuyong;	
ctrl_time_1 ctrl_time_sin_1_C(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd106),//1
															  .value_1(add_2_result),
													        .y(sin_1_C_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] cos_1_A_ctrl_fuyong;	
ctrl_time_1 ctrl_time_cos_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd106),//1
															  .value_1(add_1_result),
													        .y(cos_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] cos_1_B_ctrl_fuyong;	
ctrl_time_1 ctrl_time_cos_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd106),//1
															  .value_1(add_7_result),
													        .y(cos_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] cos_1_C_ctrl_fuyong;	
ctrl_time_1 ctrl_time_cos_1_C(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd106),//1
															  .value_1(add_2_result),
													        .y(cos_1_C_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] exp_1_A_ctrl_fuyong;	
ctrl_time_1 ctrl_time_exp_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd261),//1
															  .value_1(div_1_result),
													        .y(exp_1_A_ctrl_fuyong)
													        );	

///////////////////////////////////////////////////////////////////////////////////////////////////////////C14

ADD_SUB_64	add_1_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_1_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_1_A_ctrl_fuyong),
										  .datab(add_1_B_ctrl_fuyong),
										  .result(add_1_result)
										 );
ADD_SUB_64	add_2_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_2_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_2_A_ctrl_fuyong),
										  .datab(add_2_B_ctrl_fuyong),
										  .result(add_2_result)
										 );
ADD_SUB_64	add_3_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_3_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_3_A_ctrl_fuyong),
										  .datab(add_3_B_ctrl_fuyong),
										  .result(add_3_result)
										 );
ADD_SUB_64	add_4_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_4_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_4_A_ctrl_fuyong),
										  .datab(add_4_B_ctrl_fuyong),
										  .result(add_4_result)
										 );
ADD_SUB_64	add_5_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_5_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_5_A_ctrl_fuyong),
										  .datab(add_5_B_ctrl_fuyong),
										  .result(add_5_result)
										 );
ADD_SUB_64	add_6_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_6_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_6_A_ctrl_fuyong),
										  .datab(add_6_B_ctrl_fuyong),
										  .result(add_6_result)
										 );
ADD_SUB_64	add_7_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_7_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_7_A_ctrl_fuyong),
										  .datab(add_7_B_ctrl_fuyong),
										  .result(add_7_result)
										 );
multiplier_64	mul_1_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_1_A_ctrl_fuyong),
										  .datab(mul_1_B_ctrl_fuyong),
										  .result(mul_1_result)
										 );
multiplier_64	mul_2_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_2_A_ctrl_fuyong),
										  .datab(mul_2_B_ctrl_fuyong),
										  .result(mul_2_result)
										 );
multiplier_64	mul_3_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_3_A_ctrl_fuyong),
										  .datab(mul_3_B_ctrl_fuyong),
										  .result(mul_3_result)
										 );
multiplier_64	mul_4_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_4_A_ctrl_fuyong),
										  .datab(mul_4_B_ctrl_fuyong),
										  .result(mul_4_result)
										 );
multiplier_64	mul_5_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_5_A_ctrl_fuyong),
										  .datab(mul_5_B_ctrl_fuyong),
										  .result(mul_5_result)
										 );
multiplier_64	mul_6_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_6_A_ctrl_fuyong),
										  .datab(mul_6_B_ctrl_fuyong),
										  .result(mul_6_result)
										 );
multiplier_64	mul_7_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_7_A_ctrl_fuyong),
										  .datab(mul_7_B_ctrl_fuyong),
										  .result(mul_7_result)
										 );
multiplier_64	mul_8_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_8_A_ctrl_fuyong),
										  .datab(mul_8_B_ctrl_fuyong),
										  .result(mul_8_result)
										 );
multiplier_64	mul_9_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_9_A_ctrl_fuyong),
										  .datab(mul_9_B_ctrl_fuyong),
										  .result(mul_9_result)
										 );
multiplier_64	mul_10_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(mul_10_A_ctrl_fuyong),
										  .datab(mul_10_B_ctrl_fuyong),
										  .result(mul_10_result)
										 );
Divide_64	div_1_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .dataa(div_1_A_ctrl_fuyong),
										  .datab(div_1_B_ctrl_fuyong),
										  .result(div_1_result)
										 );
always@ (posedge clk or posedge rst_user) begin
   if (rst_user==1'b1)
	   sin_1_theta <=64'h0;
	else if((sin_1_C_ctrl_fuyong[63]==1'b1)||((sin_1_C_ctrl_fuyong[63]==1'b0)&&(sin_1_A_ctrl_fuyong[63]==1'b1)))
	   sin_1_theta <= sin_1_C_ctrl_fuyong;
	else if((sin_1_C_ctrl_fuyong[63]==1'b0)&&(sin_1_A_ctrl_fuyong[63]==1'b0)&&(sin_1_B_ctrl_fuyong[63]==1'b0))
	   sin_1_theta <= sin_1_B_ctrl_fuyong;
	else if((sin_1_C_ctrl_fuyong[63]==1'b0)&&(sin_1_A_ctrl_fuyong[63]==1'b0)&&(sin_1_B_ctrl_fuyong[63]==1'b1))
	   sin_1_theta <= sin_1_A_ctrl_fuyong;
end
EXTENDED_SINGLE2SINGLE	double2single_sin_1_theta(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(sin_1_theta),
													        .result(sin_1_theta_32)
													        );
Sin_control_system_water	sin_1_ctrl_fuyong(
							.clk(clk),
							.theta(sin_1_theta_32),
							.sin(sin_1_result_32)
										 );
SINGLE2EXTENDED_SINGLE	single2float_sin_1_result(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(sin_1_result_32),
													        .result(sin_1_result)
													        );
always@ (posedge clk or posedge rst_user) begin
   if (rst_user==1'b1)
	   cos_1_theta <=64'h0;
	else if((cos_1_C_ctrl_fuyong[63]==1'b1)||((cos_1_C_ctrl_fuyong[63]==1'b0)&&(cos_1_A_ctrl_fuyong[63]==1'b1)))
	   cos_1_theta <= cos_1_C_ctrl_fuyong;
	else if((cos_1_C_ctrl_fuyong[63]==1'b0)&&(cos_1_A_ctrl_fuyong[63]==1'b0)&&(cos_1_B_ctrl_fuyong[63]==1'b0))
	   cos_1_theta <= cos_1_B_ctrl_fuyong;
	else if((cos_1_C_ctrl_fuyong[63]==1'b0)&&(cos_1_A_ctrl_fuyong[63]==1'b0)&&(cos_1_B_ctrl_fuyong[63]==1'b1))
	   cos_1_theta <= cos_1_A_ctrl_fuyong;
end
EXTENDED_SINGLE2SINGLE	double2single_cos_1_theta(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(cos_1_theta),
													        .result(cos_1_theta_32)
													        );
Cos_control_system_water	cos_1_ctrl_fuyong(
							.clk(clk),
							.theta(cos_1_theta_32),
							.cos(cos_1_result_32)
										 );
SINGLE2EXTENDED_SINGLE	single2float_cos_1_result(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(cos_1_result_32),
													        .result(cos_1_result)
													        );
exp_64	exp_1_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .clock(clk),
										  .data(exp_1_A_ctrl_fuyong),
										  .result(exp_1_result)
										 );

///////////////////////////////////////////////////////////////////////////////////////////////////////////C17

wire [`SINGLE - 1:0] triangle_out132;
PWM PWM2(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sta),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out132)
		 );
wire [`EXTENDED_SINGLE - 1:0] triangle_out1_lyf;
SINGLE2EXTENDED_SINGLE	single2float_triangle_out1_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(triangle_out132),
													        .result(triangle_out1_lyf)
													        );

Comparator_64 Comparator_1(
								 .clk(clk),
								 .rst(rst),
								 .input_1(mul_7_result),
								 .input_2(triangle_out1_lyf),
								 .output_1(compareone_1_lyf)
							   );
always@(posedge clk or posedge rst) begin
	if(rst) begin
		compare_1_reg <= 64'h0000000000000000;
	end
	else if(compareone_1_lyf) begin
		compare_1_reg <= 64'h3FF0000000000000;
	end
	else if(!compareone_1_lyf) begin
		compare_1_reg <= 64'h0000000000000000;
	end
end
assign compare_1_lyf = compare_1_reg;
Comparator_64 Comparator_2(
								 .clk(clk),
								 .rst(rst),
								 .input_1(mul_8_result),
								 .input_2(triangle_out1_lyf),
								 .output_1(compareone_2_lyf)
							   );
always@(posedge clk or posedge rst) begin
	if(rst) begin
		compare_2_reg <= 64'h0000000000000000;
	end
	else if(compareone_2_lyf) begin
		compare_2_reg <= 64'h3FF0000000000000;
	end
	else if(!compareone_2_lyf) begin
		compare_2_reg <= 64'h0000000000000000;
	end
end
assign compare_2_lyf = compare_2_reg;
Comparator_64 Comparator_3(
								 .clk(clk),
								 .rst(rst),
								 .input_1(mul_9_result),
								 .input_2(triangle_out1_lyf),
								 .output_1(compareone_3_lyf)
							   );
always@(posedge clk or posedge rst) begin
	if(rst) begin
		compare_3_reg <= 64'h0000000000000000;
	end
	else if(compareone_3_lyf) begin
		compare_3_reg <= 64'h3FF0000000000000;
	end
	else if(!compareone_3_lyf) begin
		compare_3_reg <= 64'h0000000000000000;
	end
end
assign compare_3_lyf = compare_3_reg;

										 
///////////////////////////////////////////////////////////////////////////////////////////////////////////

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
	
wire [`EXTENDED_SINGLE - 1:0] Uab_SFM_Inv_fifo;
System_FIFO_64_1	FIFO_Uab_SFM_Inv_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[316]),
											.before_enawrite(sta_sig[293]),
								.cin( mul_1_result ),
								.cout( Uab_SFM_Inv_fifo )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ubc_SFM_Inv_fifo;
System_FIFO_64_1	FIFO_Ubc_SFM_Inv_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[316]),
											.before_enawrite(sta_sig[293]),
								.cin( mul_2_result ),
								.cout( Ubc_SFM_Inv_fifo )
					                 );
									 
wire [`EXTENDED_SINGLE - 1:0] Iph_fifo_fifo;
System_FIFO_64_1	FIFO_Iph_fifo_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[316]),
											.before_enawrite(sta_sig[66]),
								.cin( add_2_result ),
								.cout( Iph_fifo_fifo )
					                 );


wire [`EXTENDED_SINGLE - 1:0] Id_fifo_fifo;
DELAY_NCLK  #(64,19)  DELAY_NCLK_Id_fifo_fifo(
						               .clk(clk),
											.rst(rst),
						               .d(mul_5_result),
						               .q(Id_fifo_fifo)
					                 );
									 
wire [`SINGLE - 1:0] div_1_result_32;
EXTENDED_SINGLE2SINGLE	double2single_div_1_result32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(div_1_result),
													        .result(div_1_result_32)
													        );
wire [`SINGLE - 1:0] Uab_SFM_Inv_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Uab_SFM_Inv_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Uab_SFM_Inv_fifo),
													        .result(Uab_SFM_Inv_fifo_32)
													        );
															
wire [`SINGLE - 1:0] Ubc_SFM_Inv_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Ubc_SFM_Inv_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ubc_SFM_Inv_fifo),
													        .result(Ubc_SFM_Inv_fifo_32)
													        );
															
wire [`SINGLE - 1:0] Iph_fifo_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Iph_fifo_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Iph_fifo_fifo),
													        .result(Iph_fifo_fifo_32)
													        );
															
wire [`SINGLE - 1:0] Id_fifo_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Id_fifo_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Id_fifo_fifo),
													        .result(Id_fifo_fifo_32)
													        );
															
generate_ena #(`N_PV ) generate_ena_WTI11(
						.clk(clk),
						.rst(rst),
						.d(sta_sig[321]),
						.q(ena_write_I)
					  );
					  
FIFO_Source_Exchange	FIFO_PV_I11 (
	.data ( {32'h00000000,32'h00000000,32'h00000000,Ubc_SFM_Inv_fifo_32,Uab_SFM_Inv_fifo_32,div_1_result_32,Id_fifo_fifo_32,Iph_fifo_fifo_32} ),
	.rdclk ( clk ),
	.rdreq ( ena_read ),
	.wrclk ( clk ),
	.wrreq ( ena_write_I ),
	.q ( source_output_single )
	);
														  					  
SINGLE2EXTENDED_SINGLE	SINGLE2EXTENDED_SINGLE110011 (
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(source_output_single),
													        .result(source_output)
													        );	
															  

 
 

endmodule
