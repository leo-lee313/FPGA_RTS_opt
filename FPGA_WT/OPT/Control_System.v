`include "../parameter/global_parameter.v"

module Control_System(
							 clk,
							 sta,
							 sta_user,
							 rst,
							 rst_user,
							 exchange_data_sig,
							 sim_time,
							 output_num,
					       Va_PM,
                      Vb_PM,
					       Vc_PM,
					       Vdc_IC,
					       V3a,
					       V3b,
					       V3c,
					       I3a,
					       I3b,
					       I3c,
					       Ia_pm_rect,
					       Ib_pm_rect,
					       Ic_pm_rect,
                      Ia_SFM_Inv,
							 Ic_SFM_Inv,
							 
							 							 						 							 
							 exchange_Source_sig,
							 source_output							
							);
							
input clk;
input sta;
input sta_user;
input rst;
input rst_user;
input [`WIDTH_TIME - 1:0] sim_time;
input [`SINGLE - 1:0] Va_PM;
input [`SINGLE - 1:0] Vb_PM;
input [`SINGLE - 1:0] Vc_PM;
input [`SINGLE - 1:0] Vdc_IC;
input [`SINGLE - 1:0] V3a;
input [`SINGLE - 1:0] V3b;
input [`SINGLE - 1:0] V3c;
input [`SINGLE - 1:0] I3a;
input [`SINGLE - 1:0] I3b;
input [`SINGLE - 1:0] I3c;
input [`SINGLE - 1:0] Ia_pm_rect;
input [`SINGLE - 1:0] Ib_pm_rect;
input [`SINGLE - 1:0] Ic_pm_rect;
input [`SINGLE - 1:0] Ia_SFM_Inv;
input [`SINGLE - 1:0] Ic_SFM_Inv;

input [7:0] output_num;


output exchange_Source_sig;
output [`EXTENDED_SINGLE - 1:0] source_output;
output exchange_data_sig;
										  
////////////////////////////////Wind Turbine//////////////////////////////////
wire [`SINGLE - 1:0] source_output_single;
wire [`SINGLE - 1:0] Vdc;
reg  [`SINGLE - 1:0] Vdc_reg;

wire [`SINGLE - 1:0] m1_single,m3_single,m5_single;
wire [`SINGLE - 1:0] g1_single,g3_single,g5_single;
wire [`SINGLE - 1:0] Ia_PM,Ia_PM_fifo;
wire [`SINGLE - 1:0] Ib_PM,Ib_PM_fifo;
wire done_sig_PrimeMotor;
wire done_INV_SFM_g;
wire sta_before_m_3clk;
wire done_sig_finish_Iab;
wire before_sta_control,sta_interface;
wire done_Idc_SFM_SUM;
wire sta_read_source_output;

wire [`SINGLE - 1:0] Uab_SFM_Inv,Ubc_SFM_Inv,Uab_SFM_Inv_fifo,Ubc_SFM_Inv_fifo;
wire [`SINGLE - 1:0] Uab_SFM_REC,Ubc_SFM_REC,Uab_SFM_REC_fifo,Ubc_SFM_REC_fifo;
wire [`SINGLE - 1:0] Idc_SFM_SUM;

parameter const_timestep_Vdc = 32'd4;
parameter const_Vdc = 32'h44BB8000;

always@(posedge clk)
begin
    if(sim_time <= const_timestep_Vdc)
	  begin
	    Vdc_reg <= const_Vdc;
     end
	 else if((sim_time > const_timestep_Vdc))
	   begin
		  Vdc_reg <= Vdc_IC;
	   end

end
assign Vdc = Vdc_reg;

reg FLAGFH;
always@(posedge clk or posedge rst_user)
begin
    if(rst_user) 
	   begin
	     FLAGFH <= 1'b0;
		end 
    else if(sim_time <= 1)
	  begin
	    FLAGFH <= 1'b0;
     end
	 else if((sim_time > 1))
	   begin
		  FLAGFH <= 1'b1;
	   end
end


DELAY_1CLK #(8) Delay_EXCHANGE_DATA_SIG11011(
													   .clk(clk),
													   .rst(rst),
													   .d(sta),
													   .q(before_sta_control)
													  );

DELAY_1CLK #(10) Delay_EXCHANGE_DATA_SIG11(
													   .clk(clk),
													   .rst(rst),
													   .d(sta),
													   .q(sta_interface)
													  );
													  
DELAY_1CLK #(7) Delay_EXCHANGE_DATA_SIG12(
													   .clk(clk),
													   .rst(rst),
													   .d(sta),
													   .q(exchange_data_sig)
													  );

													  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////C13

parameter A_001_260_lyf_lyf = 64'h3f30614174a4911e;//有功功率滤波器中PI参数
parameter B_002_261_lyf_lyf = 64'h3f30614174a4911e;
parameter C_003_262_lyf_lyf = 64'h3feffbe7afa2d6da;
parameter G_004_263_lyf_lyf = 64'h3ff0000000000000;

parameter A_624_lyf_lyf = 64'h3f7110ec6ff95ea8;//PMSM中的Id的PI参数
parameter B_625_lyf_lyf = 64'h3f7110ec6ff95ea8;
parameter C_626_lyf_lyf = 64'h3fefff72726674e8;
parameter G_627_lyf_lyf = 64'h405edd3c0c8b28be;

parameter A_647_lyf_lyf = 64'h3f7110ec6ff95ea8;//PMSM中的Iq的PI参数
parameter B_648_lyf_lyf = 64'h3f7110ec6ff95ea8;
parameter C_649_lyf_lyf = 64'h3fefff72726674e8;
parameter G_650_lyf_lyf = 64'h405edd3c0c8b28be;

parameter A_622_lyf_lyf = 64'h3dcb7cdfd9d7bdbc;//PMSM中的wm_temp的PI参数
parameter B_623_lyf_lyf = 64'h3dcb7cdfd9d7bdbc;

parameter A_600_lyf_lyf = 64'h3ed4f8b588e368f1;//PMSM中的theta_temp的PI参数
parameter B_601_lyf_lyf = 64'h3ed4f8b588e368f1;

parameter A1_700_lyf_lyf = 64'h3ff0000000000000;//整流器控制器中的iq_rec的PI参数
parameter A2_701_lyf_lyf = 64'h3f0a36e2eb1c432d;

parameter A1_515_lyf_lyf = 64'h4010000000000000;//整流器控制器中的vq_rec的PI参数
parameter A2_516_lyf_lyf = 64'h3f30624dd2f1a9fc;

parameter A1_534_lyf_lyf = 64'h4010000000000000;//整流器控制器中的vd_rec的PI参数
parameter A2_535_lyf_lyf = 64'h3f30624dd2f1a9fc;

parameter A1_719_lyf_lyf = 64'h3fb999999999999a;//逆变器控制器中的id_inv的PI参数
parameter A2_720_lyf_lyf = 64'h3eb0c6f7a0b5ed8e;

parameter A1_757_lyf_lyf = 64'h3fa999999999999a;//逆变器控制器中的iq_inv的PI参数
parameter A2_758_lyf_lyf = 64'h3ee4f8b588e368f1;

parameter A1_290_lyf_lyf = 64'h4066800000000000;//逆变器PLL中的inner_result_10的PI参数
parameter A2_291_lyf_lyf = 64'h3f90624dd2f1a9fc;

parameter A2_347_lyf_lyf = 64'h3ed4f8b588e368f1;//逆变器PLL中的theta_pll的PI参数

parameter A1_553_lyf_lyf = 64'h4000000000000000;//逆变器控制器中的vd_inv的PI参数
parameter A2_554_lyf_lyf = 64'h3ed4f8b588e368f1;

parameter A1_738_lyf_lyf = 64'h4000000000000000;//逆变器控制器中的vq_inv的PI参数
parameter A2_739_lyf_lyf = 64'h3ed4f8b588e368f1;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
parameter idref_lyf_lyf = 64'h0000000000000000;
parameter wm_starter_lyf_lyf = 64'h4002c49ba5e353f8;
parameter const_2pi_lyf_lyf = 64'h401921FB54442D18;
parameter const5_lyf_lyf = 64'h4014000000000000;
parameter const_Vdcref_lyf_lyf = 64'h4097700000000000;
parameter Flux_lyf_lyf = 64'h4003a9fbe76c8b44;
parameter inner_result5_lyf_lyf = 64'h3fa1eb851eb851ec;


parameter const_1_divide_2_lyf_lyf = 64'h3fe0000000000000;
parameter const_sqrt_3_divide_3_lyf_lyf = 64'h3FE279A74590331C;
parameter const1_rec_lyf_lyf = 64'h3f4275f9566d9fec;



parameter const_2_lyf_lyf = 64'h4000000000000000;
parameter const_fu1_lyf_lyf = 64'hbff0000000000000;


parameter const1_25_lyf_lyf = 64'h40ff338000000000;
parameter P_double_lyf_lyf = 64'h405e000000000000;

parameter constAr_lyf_lyf = 64'h40AC5F5CC122749F;


parameter const_inv_Vbase_lyf_lyf = 64'h3f847ae147ae147b;
parameter const_1_divide_3_lyf_lyf = 64'h3fd5555555555555;


parameter const_sqrt_3_divide_2_lyf_lyf = 64'h3FEBB67AE8584CAA;
parameter const_inv_Ibase_lyf_lyf = 64'h3f3ec4a903b4a3d0;









parameter const1_lyf_lyf_lyf = 64'h3ff8000000000000;
parameter Ld_lyf_lyf = 64'h3f53a92a30553261;
parameter const4_lyf_lyf = 64'h3fe0902de00d1b71;



parameter const8_lyf_lyf = 64'h3f7bda5119ce075f;
parameter Lq_lyf_lyf = 64'h3f53a92a30553261;



parameter const3_lyf_lyf = 64'h3fe0000000000000;
parameter constRow_lyf_lyf = 64'h3ff399999999999a;
parameter const11_040_lyf_lyf = 64'h3FE279A74590331C;

parameter constR_lyf_lyf = 64'h4041000000000000;


parameter const_sqrt_inv_3_lyf_lyf = 64'h3FE279A74590331C;
parameter const_inv_Sbase_lyf_lyf = 64'h3EA65E9F80F29212;

parameter const2_26inv_lyf_lyf = 64'h3ea65e9f81229be6;

parameter constone_lyf_lyf = 64'h3ff0000000000000;
parameter const116_lyf_lyf = 64'h405d000000000000;
parameter const7_lyf_lyf = 64'hc035000000000000;
parameter upper_limit_292_lyf_lyf = 64'h412e848000000000;
parameter down_limit_293_lyf_lyf = 64'hc12e848000000000;
parameter J24_UP_lyf = 64'h4202a05f20000000;
parameter J24_DOWM_lyf = 64'hc202a05f20000000;
parameter upper_limit_721_lyf_lyf = 64'h3ff8000000000000;
parameter down_limit_722_lyf_lyf = 64'hbff8000000000000;
parameter upper_limit_759_lyf_lyf = 64'h3ff8000000000000;
parameter down_limit_760_lyf_lyf = 64'hbff8000000000000;
parameter upper_limit_702_lyf_lyf = 64'h3ff8000000000000;
parameter down_limit_703_lyf_lyf = 64'hbff8000000000000;
parameter upper_limit_555_lyf_lyf = 64'h41d65a0bc0000000;
parameter down_limit_556_lyf_lyf = 64'hc1d65a0bc0000000;
parameter upper_limit_740_lyf_lyf = 64'h41d65a0bc0000000;
parameter down_limit_741_lyf_lyf = 64'hc1d65a0bc0000000;
parameter upper_limit_517_lyf_lyf = 64'h41d65a0bc0000000;
parameter down_limit_518_lyf_lyf = 64'hc1d65a0bc0000000;
parameter upper_limit_536_lyf_lyf = 64'h41d65a0bc0000000;
parameter down_limit_537_lyf_lyf = 64'hc1d65a0bc0000000;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////C19

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
													 
wire [`EXTENDED_SINGLE - 1:0] add_1_result;
wire [`EXTENDED_SINGLE - 1:0] add_2_result;
wire [`EXTENDED_SINGLE - 1:0] add_3_result;
wire [`EXTENDED_SINGLE - 1:0] add_4_result;
wire [`EXTENDED_SINGLE - 1:0] add_5_result;
wire [`EXTENDED_SINGLE - 1:0] add_6_result;
wire [`EXTENDED_SINGLE - 1:0] add_7_result;
wire [`EXTENDED_SINGLE - 1:0] add_8_result;
wire [`EXTENDED_SINGLE - 1:0] add_9_result;
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
reg [`EXTENDED_SINGLE - 1:0] compare_4_reg;
wire compareone_4_lyf;
wire [`EXTENDED_SINGLE - 1:0] compare_4_lyf;
reg [`EXTENDED_SINGLE - 1:0] compare_5_reg;
wire compareone_5_lyf;
wire [`EXTENDED_SINGLE - 1:0] compare_5_lyf;
reg [`EXTENDED_SINGLE - 1:0] compare_6_reg;
wire compareone_6_lyf;
wire [`EXTENDED_SINGLE - 1:0] compare_6_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_1_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_2_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_3_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_4_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_5_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_6_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_7_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_8_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_9_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_10_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_11_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_12_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_13_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_14_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_15_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_16_lyf;
wire [`EXTENDED_SINGLE - 1:0] limit_17_lyf;
wire [`EXTENDED_SINGLE - 1:0] exp_1_result;
////////////////////////////////////////////////////////////////
wire	[`EXTENDED_SINGLE - 1:0] Tm_starter_pre_a_lyf,Tm1_temp_stor_lyf,Tm_lyf_lyf_pre,Tm_lyf_lyf;
wire ena_657_lyf;	
wire ena_634_lyf;
wire ena_011_270_lyf;	
generate_ena #(`N_WindTurbine ) generate_en11a_PID_Initial640_PID110  (
						.clk(clk),
						.rst(rst),
						.d(sta_sig[76]),
						.q(ena_657_lyf)
					  );	
generate_ena #(`N_WindTurbine ) generate_e11na_PID_Initial640_PID10  (
						.clk(clk),
						.rst(rst),
						.d(sta_sig[82]),
						.q(ena_634_lyf)
					  );
generate_ena #(`N_WindTurbine ) generate_en11a_PID_Initial640_P_cal1  (
						.clk(clk),
						.rst(rst),
						.d(sta_sig[119]),
						.q(ena_011_270_lyf)
					  );
wire [`ADDR_WIDTH_N_WindTurbine - 1:0] addr_Tm_starter_pre_r_LYF;
wire pulse_Tm_starter_pre_r_LYF;
wire ena_Tm_starter_pre_r_LYF;
wire step_Tm_starter_pre_r_LYF;
wire ena_cal_Tm_starter_pre_r_LYF;
ADDR #( `ADDR_WIDTH_N_WindTurbine , `N_WindTurbine , `TIMES_N_WindTurbine , `INI_ADDR_N_WindTurbine ) ADDR_Tm_starter_pre_LYF(
																																								.clk(clk),
																																								.rst(rst),
																																								.sta(sta_sig[2]),
																																								.addr(addr_Tm_starter_pre_r_LYF),
																																								.pulse(pulse_Tm_starter_pre_r_LYF),
																																								.ena_mem(ena_Tm_starter_pre_r_LYF),
																																								.step(step_Tm_starter_pre_r_LYF),
																																								.ena_cal(ena_cal_Tm_starter_pre_r_LYF)
																																								 );																																								 
	
Tm_starter_pre	Tm_starter_pre_32(
													 .aclr(rst),
													 .clock(clk),
													 .clken(ena_Tm_starter_pre_r_LYF),
													 .address(addr_Tm_starter_pre_r_LYF),
													 .rden(ena_cal_Tm_starter_pre_r_LYF),
													 .q(Tm_starter_pre_a_lyf)
													);

wire	[`EXTENDED_SINGLE - 1:0] mul1_5_result;
assign mul1_5_result = {~mul_5_result[`EXTENDED_SINGLE - 1],mul_5_result[`EXTENDED_SINGLE - 2:0]};	//C72 317
System_FIFO_64_1   FIFO_Tm1_temp_lyf(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_sig[2]),
								.before_enawrite(sta_sig[312]),
								.cin( mul1_5_result ),//314
								.cout( Tm1_temp_stor_lyf )
							  );

Dingshi64_water #(32'd2) Dingshi_Tm_starter32(
          .clk(clk),			 		 
			 .sim_time(sim_time),
			 .Tm_temp_start(Tm_starter_pre_a_lyf), 
          .Tm_temp(Tm1_temp_stor_lyf),		 
			 .Tm(Tm_lyf_lyf_pre)		
			);
			
System_FIFO_64_1   FIFO_Tm_lyf_lyf(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_sig[93]),
								.before_enawrite(sta_sig[5]),
								.cin( Tm_lyf_lyf_pre ),//7
								.cout( Tm_lyf_lyf )
							  );			
			
wire [`SINGLE - 1:0] VWind32;
wire [`SINGLE - 1:0] VWind132;
WindGEN_water  #(32'd300000) WindGEN_water123(			 		 		 
			 .clk(clk),
			 .rst(rst),
			 .sta(sta_sig[2]),
          .sim_time(sim_time),
          			 
			 .VWind(VWind32)			
			);
						
WindGEN_water  #(32'd300000) WindGEN_water1123(			 		 		 
			 .clk(clk),
			 .rst(rst),
			 .sta(sta_sig[2]),
          .sim_time(sim_time),
          			 
			 .VWind(VWind132)			
			);
wire [`EXTENDED_SINGLE - 1:0] VWind64_lyf_lyf;
wire [`EXTENDED_SINGLE - 1:0] VWind164_lyf_lyf;			
SINGLE2EXTENDED_SINGLE	single2float_WindGEN_water1(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(VWind32),
													        .result(VWind64_lyf_lyf)
													        );
SINGLE2EXTENDED_SINGLE	single2float_WindGEN_water(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(VWind132),
													        .result(VWind164_lyf_lyf)
													        );
parameter idle = 2'd0;
parameter middle = 2'd1;
parameter start = 2'd2;

wire [`EXTENDED_SINGLE - 1:0] mul_4_result_16;
DELAY_NCLK  #(64,16)  DELAY_NCLK_mul_4_result_16(
						               .clk(clk),
											.rst(rst),
						               .d(mul_4_result),
						               .q(mul_4_result_16)
					                 );
										  
reg [`EXTENDED_SINGLE - 1:0] Id_temp_lyf_temp;		
wire [`EXTENDED_SINGLE - 1:0] Id_temp_lyf;
reg [`EXTENDED_SINGLE - 1:0] counter_631_lyf;
reg [1:0] state_632_lyf;					  
always@(posedge clk or posedge rst_user)
   if(rst_user)
	  begin
      state_632_lyf <= idle;
		counter_631_lyf<=64'd0;
	  end
	else
	  case(state_632_lyf)
	     idle:
          begin
			   if(ena_634_lyf == 1'b1)
				   begin
				     Id_temp_lyf_temp <= mul_4_result_16 ;// C10
				     state_632_lyf <= middle;
				   end
			   else
				   begin
				     state_632_lyf <= idle;
				   end
		    end
		  middle:
		    begin
			   counter_631_lyf<=counter_631_lyf+1;
				if(counter_631_lyf>=64'd30)
				  begin
				     state_632_lyf <= start;
				     counter_631_lyf<=64'd0;
				  end
			 end  
        start:
		    begin
			   if(ena_634_lyf == 1'b1)
				   begin
				     Id_temp_lyf_temp <= add_9_result ;// J9
				     state_632_lyf <= start;
				   end
			   else
				   begin
				      state_632_lyf <= start;
				   end
		    end

	  endcase
	

assign Id_temp_lyf=Id_temp_lyf_temp;//85


										  
wire [`EXTENDED_SINGLE - 1:0] Id_temp_lyf_34;
System_FIFO_64_1	FIFO_Id_temp_lyf_34 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[115]),
											.before_enawrite(sta_sig[83]),
								.cin( Id_temp_lyf ),
								.cout( Id_temp_lyf_34 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] Id_temp_lyf_106;
System_FIFO_64_1	FIFO_Id_temp_lyf_106 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[187]),
											.before_enawrite(sta_sig[83]),
								.cin( Id_temp_lyf ),
								.cout( Id_temp_lyf_106 )
					                 );
	
wire [`EXTENDED_SINGLE - 1:0] Id_temp_lyf_98;
System_FIFO_64_1	FIFO_Id_temp_lyf_98 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[179]),
											.before_enawrite(sta_sig[83]),
								.cin( Id_temp_lyf ),
								.cout( Id_temp_lyf_98 )
					                 );
										 
wire [`EXTENDED_SINGLE - 1:0] Id_temp_lyf_169;
System_FIFO_64_1	FIFO_Id_temp_lyf_169 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[250]),
											.before_enawrite(sta_sig[83]),
								.cin( Id_temp_lyf ),
								.cout( Id_temp_lyf_169 )
					                 );
										 
wire [`EXTENDED_SINGLE - 1:0] Id_temp_lyf_183;
System_FIFO_64_1	FIFO_Id_temp_lyf_183 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[264]),
											.before_enawrite(sta_sig[83]),
								.cin( Id_temp_lyf ),
								.cout( Id_temp_lyf_183 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] y_reg_643_lyf70;
System_FIFO_64_1	FIFO_y_reg_643_lyf70 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[66]),
											.before_enawrite(sta_sig[117]),
								.cin( Id_temp_lyf_34 ),
								.cout( y_reg_643_lyf70 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] mul_10_result_16;
DELAY_NCLK  #(64,16)  DELAY_NCLK_mul_10_result_16(
						               .clk(clk),
											.rst(rst),
						               .d(mul_10_result),
						               .q(mul_10_result_16)
					                 );
										  
reg [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf_temp;		
wire [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf;
reg [`EXTENDED_SINGLE - 1:0] counter_654_lyf;
reg [1:0] state_655_lyf;	
					  
always@(posedge clk or posedge rst_user)
   if(rst_user)
	  begin
      state_655_lyf <= idle;
		counter_654_lyf<=64'd0;
	  end
	else
	  case(state_655_lyf)
	     idle:
          begin
			   if(ena_657_lyf == 1'b1)
				   begin
				     Iq_temp_lyf_temp <= mul_10_result_16 ; // C14
				     state_655_lyf <= middle;
				   end
			   else
				   begin
				     state_655_lyf <= idle;
				   end
		    end
		  middle:
		    begin
			   counter_654_lyf<=counter_654_lyf+1;
				if(counter_654_lyf>=64'd30)
				  begin
				     state_655_lyf <= start;
				     counter_654_lyf<=64'd0;
				  end
			 end  
        start:
		    begin
			   if(ena_657_lyf == 1'b1)
				   begin
				     Iq_temp_lyf_temp <= add_7_result ;// J11
				     state_655_lyf <= start;
				   end
			   else
				   begin
				      state_655_lyf <= start;
				   end
		    end

	  endcase
	

assign Iq_temp_lyf=Iq_temp_lyf_temp;//79

wire [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf_40;
System_FIFO_64_1	FIFO_Iq_temp_lyf_40 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[115]),
											.before_enawrite(sta_sig[77]),
								.cin( Iq_temp_lyf ),
								.cout( Iq_temp_lyf_40 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf_112;
System_FIFO_64_1	FIFO_Iq_temp_lyf_112 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[187]),
											.before_enawrite(sta_sig[77]),
								.cin( Iq_temp_lyf ),
								.cout( Iq_temp_lyf_112 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf_104;
System_FIFO_64_1	FIFO_Iq_temp_lyf_104 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[179]),
											.before_enawrite(sta_sig[77]),
								.cin( Iq_temp_lyf ),
								.cout( Iq_temp_lyf_104 )
					                 );										  

wire [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf_183;
System_FIFO_64_1	FIFO_Iq_temp_lyf_183 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[258]),
											.before_enawrite(sta_sig[77]),
								.cin( Iq_temp_lyf ),
								.cout( Iq_temp_lyf_183 )
					                 );	

wire [`EXTENDED_SINGLE - 1:0] Iq_temp_lyf_189;
System_FIFO_64_1	FIFO_Iq_temp_lyf_189 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[264]),
											.before_enawrite(sta_sig[77]),
								.cin( Iq_temp_lyf ),
								.cout( Iq_temp_lyf_189 )
					                 );	

wire [`EXTENDED_SINGLE - 1:0] y_reg_666_lyf64;
System_FIFO_64_1	FIFO_y_reg_666_lyf64 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[60]),
											.before_enawrite(sta_sig[117]),
								.cin( Iq_temp_lyf_40 ),
								.cout( y_reg_666_lyf64 )
					                 );

										  
wire [`EXTENDED_SINGLE - 1:0] mul_2_result_16;
DELAY_NCLK  #(64,16)  DELAY_NCLK_mul_2_result_16(
						               .clk(clk),
											.rst(rst),
						               .d(mul_2_result),
						               .q(mul_2_result_16)
					                 );
										  
reg [`EXTENDED_SINGLE - 1:0] P_PM_Cal_lyf_temp;		
wire [`EXTENDED_SINGLE - 1:0] P_PM_Cal_lyf;
reg [`EXTENDED_SINGLE - 1:0] counter_008_267_lyf;
reg [1:0] state_009_268_lyf;
					  
always@(posedge clk or posedge rst_user)
   if(rst_user)
	  begin
      state_009_268_lyf <= idle;
		counter_008_267_lyf<=64'd0;
	  end
	else
	  case(state_009_268_lyf)
	     idle:
          begin
			   if(ena_011_270_lyf == 1'b1)
				   begin
				     P_PM_Cal_lyf_temp <= mul_2_result_16 ; // C79
				     state_009_268_lyf <= middle;
				   end
			   else
				   begin
				     state_009_268_lyf <= idle;
				   end
		    end
		  middle:
		    begin
			   counter_008_267_lyf<=counter_008_267_lyf+1;
				if(counter_008_267_lyf>=64'd30)
				  begin
				     state_009_268_lyf <= start;
				     counter_008_267_lyf<=64'd0;
				  end
			 end  
        start:
		    begin
			   if(ena_011_270_lyf == 1'b1)
				   begin
				     P_PM_Cal_lyf_temp <= add_5_result ; // J54
				     state_009_268_lyf <= start;
				   end
			   else
				   begin
				      state_009_268_lyf <= start;
				   end
		    end

	  endcase
	

assign P_PM_Cal_lyf=P_PM_Cal_lyf_temp;//122

wire [`EXTENDED_SINGLE - 1:0] P_PM_Cal_lyf_33;
System_FIFO_64_1	FIFO_P_PM_Cal_lyf_33 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[151]),
											.before_enawrite(sta_sig[120]),
								.cin( P_PM_Cal_lyf ),
								.cout( P_PM_Cal_lyf_33 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] y_reg_021_280_lyf107;
System_FIFO_64_1	FIFO_y_reg_021_280_lyf107 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[103]),
											.before_enawrite(sta_sig[153]),
								.cin( P_PM_Cal_lyf_33 ),
								.cout( y_reg_021_280_lyf107 )
					                 );										  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////C15
wire [`EXTENDED_SINGLE - 1:0] Vdc_lyf;
SINGLE2EXTENDED_SINGLE	single2float_Vdc_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vdc),
													        .result(Vdc_lyf)
													        );
															  
wire [`EXTENDED_SINGLE - 1:0] Vdc_lyf_140;
System_FIFO_64_1	FIFO_Vdc_lyf_140 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[136]),
											.before_enawrite(sta_sig[11]),
								.cin( Vdc_lyf ),
								.cout( Vdc_lyf_140 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vdc_lyf_277;
System_FIFO_64_1	FIFO_Vdc_lyf_277 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[273]),
											.before_enawrite(sta_sig[11]),
								.cin( Vdc_lyf ),
								.cout( Vdc_lyf_277 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vdc_lyf_262;
System_FIFO_64_1	FIFO_Vdc_lyf_262 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[258]),
											.before_enawrite(sta_sig[11]),
								.cin( Vdc_lyf ),
								.cout( Vdc_lyf_262 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vdc_lyf_282;
System_FIFO_64_1	FIFO_Vdc_lyf_282 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[278]),
											.before_enawrite(sta_sig[11]),
								.cin( Vdc_lyf ),
								.cout( Vdc_lyf_282 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vdc_lyf_297;
System_FIFO_64_1	FIFO_Vdc_lyf_297 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[293]),
											.before_enawrite(sta_sig[11]),
								.cin( Vdc_lyf ),
								.cout( Vdc_lyf_297 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Vb_PM_64;
SINGLE2EXTENDED_SINGLE	single2float_Vb_PM(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vb_PM),
													        .result(Vb_PM_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] V3a_64;
SINGLE2EXTENDED_SINGLE	single2float_V3a(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(V3a),
													        .result(V3a_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] V3a_64_67;
System_FIFO_64_1	FIFO_V3a_64_67 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[75]),
											.before_enawrite(sta_sig[10]),
								.cin( V3a_64 ),
								.cout( V3a_64_67 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vc_PM_64;
SINGLE2EXTENDED_SINGLE	single2float_Vc_PM(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Vc_PM),
													        .result(Vc_PM_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] V3b_64;
SINGLE2EXTENDED_SINGLE	single2float_V3b(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(V3b),
													        .result(V3b_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] V3b_64_67;
System_FIFO_64_1	FIFO_V3b_64_67 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[75]),
											.before_enawrite(sta_sig[10]),
								.cin( V3b_64 ),
								.cout( V3b_64_67 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vb_PM_64_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_Vb_PM_64_8(
						               .clk(clk),
											.rst(rst),
						               .d(Vb_PM_64),
						               .q(Vb_PM_64_8)
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vc_PM_64_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_Vc_PM_64_8(
						               .clk(clk),
											.rst(rst),
						               .d(Vc_PM_64),
						               .q(Vc_PM_64_8)
					                 );
wire [`EXTENDED_SINGLE - 1:0] V3c_64;
SINGLE2EXTENDED_SINGLE	single2float_V3c(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(V3c),
													        .result(V3c_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] V3c_64_67;
System_FIFO_64_1	FIFO_V3c_64_67 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[75]),
											.before_enawrite(sta_sig[10]),
								.cin( V3c_64 ),
								.cout( V3c_64_67 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] V3c_64_75;
System_FIFO_64_1	FIFO_V3c_64_75 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[83]),
											.before_enawrite(sta_sig[10]),
								.cin( V3c_64 ),
								.cout( V3c_64_75 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] V3a_64_75;
System_FIFO_64_1	FIFO_V3a_64_75 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[83]),
											.before_enawrite(sta_sig[10]),
								.cin( V3a_64 ),
								.cout( V3a_64_75 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vb_PM_64_59;
System_FIFO_64_1	FIFO_Vb_PM_64_59 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[67]),
											.before_enawrite(sta_sig[10]),
								.cin( Vb_PM_64 ),
								.cout( Vb_PM_64_59 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ib_pm_rect_64;
SINGLE2EXTENDED_SINGLE	single2float_Ib_pm_rect(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ib_pm_rect),
													        .result(Ib_pm_rect_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ib_pm_rect_64_59;
System_FIFO_64_1	FIFO_Ib_pm_rect_64_59 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[67]),
											.before_enawrite(sta_sig[10]),
								.cin( Ib_pm_rect_64 ),
								.cout( Ib_pm_rect_64_59 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] I3b_64;
SINGLE2EXTENDED_SINGLE	single2float_I3b(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(I3b),
													        .result(I3b_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] I3b_64_83;
System_FIFO_64_1	FIFO_I3b_64_83 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[91]),
											.before_enawrite(sta_sig[10]),
								.cin( I3b_64 ),
								.cout( I3b_64_83 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ia_SFM_Inv_64;
SINGLE2EXTENDED_SINGLE	single2float_Ia_SFM_Inv(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ia_SFM_Inv),
													        .result(Ia_SFM_Inv_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ia_SFM_Inv_64_256;
System_FIFO_64_1	FIFO_Ia_SFM_Inv_64_256 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[264]),
											.before_enawrite(sta_sig[10]),
								.cin( Ia_SFM_Inv_64 ),
								.cout( Ia_SFM_Inv_64_256 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Va_PM_64;
SINGLE2EXTENDED_SINGLE	single2float_Va_PM(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Va_PM),
													        .result(Va_PM_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Va_PM_64_2;
DELAY_NCLK  #(64,2)  DELAY_NCLK_Va_PM_64_2(
						               .clk(clk),
											.rst(rst),
						               .d(Va_PM_64),
						               .q(Va_PM_64_2)
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ic_SFM_Inv_64;
SINGLE2EXTENDED_SINGLE	single2float_Ic_SFM_Inv(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ic_SFM_Inv),
													        .result(Ic_SFM_Inv_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ic_SFM_Inv_64_256;
System_FIFO_64_1	FIFO_Ic_SFM_Inv_64_256 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[264]),
											.before_enawrite(sta_sig[10]),
								.cin( Ic_SFM_Inv_64 ),
								.cout( Ic_SFM_Inv_64_256 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] V3b_64_5;
DELAY_NCLK  #(64,5)  DELAY_NCLK_V3b_64_5(
						               .clk(clk),
											.rst(rst),
						               .d(V3b_64),
						               .q(V3b_64_5)
					                 );
wire [`EXTENDED_SINGLE - 1:0] Vc_PM_64_67;
System_FIFO_64_1	FIFO_Vc_PM_64_67 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[75]),
											.before_enawrite(sta_sig[10]),
								.cin( Vc_PM_64 ),
								.cout( Vc_PM_64_67 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] I3b_64_128;
System_FIFO_64_1	FIFO_I3b_64_128 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[136]),
											.before_enawrite(sta_sig[10]),
								.cin( I3b_64 ),
								.cout( I3b_64_128 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ic_pm_rect_64;
SINGLE2EXTENDED_SINGLE	single2float_Ic_pm_rect(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ic_pm_rect),
													        .result(Ic_pm_rect_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ic_pm_rect_64_67;
System_FIFO_64_1	FIFO_Ic_pm_rect_64_67 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[75]),
											.before_enawrite(sta_sig[10]),
								.cin( Ic_pm_rect_64 ),
								.cout( Ic_pm_rect_64_67 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] V3c_64_5;
DELAY_NCLK  #(64,5)  DELAY_NCLK_V3c_64_5(
						               .clk(clk),
											.rst(rst),
						               .d(V3c_64),
						               .q(V3c_64_5)
					                 );
wire [`EXTENDED_SINGLE - 1:0] I3c_64;
SINGLE2EXTENDED_SINGLE	single2float_I3c(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(I3c),
													        .result(I3c_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] I3c_64_128;
System_FIFO_64_1	FIFO_I3c_64_128 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[136]),
											.before_enawrite(sta_sig[10]),
								.cin( I3c_64 ),
								.cout( I3c_64_128 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] V3a_64_7;
DELAY_NCLK  #(64,7)  DELAY_NCLK_V3a_64_7(
						               .clk(clk),
											.rst(rst),
						               .d(V3a_64),
						               .q(V3a_64_7)
					                 );
wire [`EXTENDED_SINGLE - 1:0] I3a_64;
SINGLE2EXTENDED_SINGLE	single2float_I3a(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(I3a),
													        .result(I3a_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] I3a_64_130;
System_FIFO_64_1	FIFO_I3a_64_130 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[138]),
											.before_enawrite(sta_sig[10]),
								.cin( I3a_64 ),
								.cout( I3a_64_130 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] I3c_64_75;
System_FIFO_64_1	FIFO_I3c_64_75 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[83]),
											.before_enawrite(sta_sig[10]),
								.cin( I3c_64 ),
								.cout( I3c_64_75 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] I3a_64_75;
System_FIFO_64_1	FIFO_I3a_64_75 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[83]),
											.before_enawrite(sta_sig[10]),
								.cin( I3a_64 ),
								.cout( I3a_64_75 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ia_pm_rect_64;
SINGLE2EXTENDED_SINGLE	single2float_Ia_pm_rect(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ia_pm_rect),
													        .result(Ia_pm_rect_64)
													        );
wire [`EXTENDED_SINGLE - 1:0] Ia_pm_rect_64_271;
System_FIFO_64_1	FIFO_Ia_pm_rect_64_271 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[279]),
											.before_enawrite(sta_sig[10]),
								.cin( Ia_pm_rect_64 ),
								.cout( Ia_pm_rect_64_271 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ic_pm_rect_64_271;
System_FIFO_64_1	FIFO_Ic_pm_rect_64_271 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[279]),
											.before_enawrite(sta_sig[10]),
								.cin( Ic_pm_rect_64 ),
								.cout( Ic_pm_rect_64_271 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Va_PM_64_59;
System_FIFO_64_1	FIFO_Va_PM_64_59 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[67]),
											.before_enawrite(sta_sig[10]),
								.cin( Va_PM_64 ),
								.cout( Va_PM_64_59 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ia_pm_rect_64_59;
System_FIFO_64_1	FIFO_Ia_pm_rect_64_59 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[67]),
											.before_enawrite(sta_sig[10]),
								.cin( Ia_pm_rect_64 ),
								.cout( Ia_pm_rect_64_59 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ia_pm_rect_64_271_1;
wire [`EXTENDED_SINGLE - 1:0] Ic_pm_rect_64_271_1;
assign Ia_pm_rect_64_271_1 = {~Ia_pm_rect_64_271[`EXTENDED_SINGLE - 1],Ia_pm_rect_64_271[`EXTENDED_SINGLE - 2:0]};	//312						  
assign Ic_pm_rect_64_271_1 = {~Ic_pm_rect_64_271[`EXTENDED_SINGLE - 1],Ic_pm_rect_64_271[`EXTENDED_SINGLE - 2:0]};		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////C16 
wire [`EXTENDED_SINGLE - 1:0] y_reg_608_lyf184;
System_FIFO_64_1	FIFO_y_reg_608_lyf184 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[180]),
											.before_enawrite(sta_sig[208]),
								.cin( sin_1_theta ),
								.cout( y_reg_608_lyf184 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] y_reg_327_360_lyf99;
System_FIFO_64_1	FIFO_y_reg_327_360_lyf99 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[95]),
											.before_enawrite(sta_sig[123]),
								.cin( sin_1_theta ),
								.cout( y_reg_327_360_lyf99 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] limit_8_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_8_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[208]),
											.before_enawrite(sta_sig[170]),
						               .cin(limit_8_lyf),
						               .cout(limit_8_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_735_lyf154;
System_FIFO_64_1	FIFO_y_reg_130_735_lyf154 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[150]),
											.before_enawrite(sta_sig[210]),
								.cin( limit_8_lyf_40 ),
								.cout( y_reg_130_735_lyf154 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_14_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_14_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[250]),
											.before_enawrite(sta_sig[212]),
						               .cin(limit_14_lyf),
						               .cout(limit_14_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_550_lyf196;
System_FIFO_64_1	FIFO_y_reg_130_550_lyf196 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[192]),
											.before_enawrite(sta_sig[252]),
								.cin( limit_14_lyf_40 ),
								.cout( y_reg_130_550_lyf196 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_4_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_4_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[265]),
											.before_enawrite(sta_sig[227]),
						               .cin(limit_4_lyf),
						               .cout(limit_4_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_512_lyf211;
System_FIFO_64_1	FIFO_y_reg_130_512_lyf211 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[207]),
											.before_enawrite(sta_sig[267]),
								.cin( limit_4_lyf_40 ),
								.cout( y_reg_130_512_lyf211 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_10_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_10_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[208]),
											.before_enawrite(sta_sig[170]),
						               .cin(limit_10_lyf),
						               .cout(limit_10_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_773_lyf154;
System_FIFO_64_1	FIFO_y_reg_130_773_lyf154 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[150]),
											.before_enawrite(sta_sig[210]),
								.cin( limit_10_lyf_40 ),
								.cout( y_reg_130_773_lyf154 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] limit_16_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_16_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[250]),
											.before_enawrite(sta_sig[212]),
						               .cin(limit_16_lyf),
						               .cout(limit_16_lyf_40)
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_754_lyf196;
System_FIFO_64_1	FIFO_y_reg_130_754_lyf196 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[192]),
											.before_enawrite(sta_sig[252]),
								.cin( limit_16_lyf_40 ),
								.cout( y_reg_130_754_lyf196 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_6_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_6_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[265]),
											.before_enawrite(sta_sig[227]),
						               .cin(limit_6_lyf),
						               .cout(limit_6_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_531_lyf211;
System_FIFO_64_1	FIFO_y_reg_130_531_lyf211 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[207]),
											.before_enawrite(sta_sig[267]),
								.cin( limit_6_lyf_40 ),
								.cout( y_reg_130_531_lyf211 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_8_result_40;
System_FIFO_64_1  DELAY_NCLK_add_8_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[163]),
											.before_enawrite(sta_sig[125]),
						               .cin(add_8_result),
						               .cout(add_8_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_620_lyf111;
System_FIFO_64_1	FIFO_y_reg_620_lyf111 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[107]),
											.before_enawrite(sta_sig[165]),
								.cin( add_8_result_40 ),
								.cout( y_reg_620_lyf111 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_12_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_12_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[119]),
											.before_enawrite(sta_sig[81]),
						               .cin(limit_12_lyf),
						               .cout(limit_12_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_307_lyf65;
System_FIFO_64_1	FIFO_y_reg_307_lyf65 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[61]),
											.before_enawrite(sta_sig[121]),
								.cin( limit_12_lyf_40 ),
								.cout( y_reg_307_lyf65 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_2_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_2_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[223]),
											.before_enawrite(sta_sig[185]),
						               .cin(limit_2_lyf),
						               .cout(limit_2_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] y_reg_130_716_lyf169;
System_FIFO_64_1	FIFO_y_reg_130_716_lyf169 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[165]),
											.before_enawrite(sta_sig[225]),
								.cin( limit_2_lyf_40 ),
								.cout( y_reg_130_716_lyf169 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay_203_lyf_lyf34;
System_FIFO_64_1	FIFO_sin_theta_delay_203_lyf_lyf34 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[30]),
											.before_enawrite(sta_sig[251]),
								.cin( sin_1_result ),
								.cout( sin_theta_delay_203_lyf_lyf34 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_4_result_40;
System_FIFO_64_1  DELAY_NCLK_add_4_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[199]),
											.before_enawrite(sta_sig[161]),
						               .cin(add_4_result),
						               .cout(add_4_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_715_lyf171;
System_FIFO_64_1	FIFO_x_reg_129_715_lyf171 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[167]),
											.before_enawrite(sta_sig[201]),
								.cin( add_4_result_40 ),
								.cout( x_reg_129_715_lyf171 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_1_result_40;
System_FIFO_64_1  DELAY_NCLK_add_1_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[92]),
											.before_enawrite(sta_sig[54]),
						               .cin(add_1_result),
						               .cout(add_1_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_664_lyf56;
System_FIFO_64_1	FIFO_x_reg_664_lyf56 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[52]),
											.before_enawrite(sta_sig[94]),
								.cin( add_1_result_40 ),
								.cout( x_reg_664_lyf56 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_7_result_40;
System_FIFO_64_1  DELAY_NCLK_add_7_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[184]),
											.before_enawrite(sta_sig[146]),
						               .cin(add_7_result),
						               .cout(add_7_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_734_lyf156;
System_FIFO_64_1	FIFO_x_reg_129_734_lyf156 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[152]),
											.before_enawrite(sta_sig[186]),
								.cin( add_7_result_40 ),
								.cout( x_reg_129_734_lyf156 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_10_result_60;
System_FIFO_64_1  DELAY_NCLK_mul_10_result_60(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[177]),
											.before_enawrite(sta_sig[119]),
						               .cin(mul_10_result),
						               .cout(mul_10_result_60)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_772_lyf156;
System_FIFO_64_1	FIFO_x_reg_129_772_lyf156 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[152]),
											.before_enawrite(sta_sig[179]),
								.cin( mul_10_result_60 ),
								.cout( x_reg_129_772_lyf156 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_3_result_40;
System_FIFO_64_1  DELAY_NCLK_add_3_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[241]),
											.before_enawrite(sta_sig[203]),
						               .cin(add_3_result),
						               .cout(add_3_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_511_lyf213;
System_FIFO_64_1	FIFO_x_reg_129_511_lyf213 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[209]),
											.before_enawrite(sta_sig[243]),
								.cin( add_3_result_40 ),
								.cout( x_reg_129_511_lyf213 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay_203_lyf_lyf40;
System_FIFO_64_1	FIFO_sin_theta_delay_203_lyf_lyf40 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[36]),
											.before_enawrite(sta_sig[251]),
								.cin( sin_1_result ),
								.cout( sin_theta_delay_203_lyf_lyf40 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_9_result_40;
System_FIFO_64_1  DELAY_NCLK_mul_9_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[135]),
											.before_enawrite(sta_sig[97]),
						               .cin(mul_9_result),
						               .cout(mul_9_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_019_278_lyf99;
System_FIFO_64_1	FIFO_x_reg_019_278_lyf99 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[95]),
											.before_enawrite(sta_sig[137]),
								.cin( mul_9_result_40 ),
								.cout( x_reg_019_278_lyf99 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_4_result_40_1;
System_FIFO_64_1  DELAY_NCLK_add_4_result_40_1(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[226]),
											.before_enawrite(sta_sig[188]),
						               .cin(add_4_result),
						               .cout(add_4_result_40_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_549_lyf198;
System_FIFO_64_1	FIFO_x_reg_129_549_lyf198 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[194]),
											.before_enawrite(sta_sig[228]),
								.cin( add_4_result_40_1 ),
								.cout( x_reg_129_549_lyf198 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_4_result_40_2;
System_FIFO_64_1  DELAY_NCLK_add_4_result_40_2(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[241]),
											.before_enawrite(sta_sig[203]),
						               .cin(add_4_result),
						               .cout(add_4_result_40_2)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_530_lyf213;
System_FIFO_64_1	FIFO_x_reg_129_530_lyf213 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[209]),
											.before_enawrite(sta_sig[243]),
								.cin( add_4_result_40_2 ),
								.cout( x_reg_129_530_lyf213 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay_204_lyf_lyf40;
System_FIFO_64_1	FIFO_cos_theta_delay_204_lyf_lyf40 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[36]),
											.before_enawrite(sta_sig[251]),
								.cin( cos_1_result ),
								.cout( cos_theta_delay_204_lyf_lyf40 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_13_lyf_40;
System_FIFO_64_1  DELAY_NCLK_limit_13_lyf_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[129]),
											.before_enawrite(sta_sig[91]),
						               .cin(limit_13_lyf),
						               .cout(limit_13_lyf_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_325_358_lyf101;
System_FIFO_64_1	FIFO_x_reg_325_358_lyf101 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[97]),
											.before_enawrite(sta_sig[131]),
								.cin( limit_13_lyf_40 ),
								.cout( x_reg_325_358_lyf101 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay_203_lyf_lyf183;
System_FIFO_64_1	FIFO_sin_theta_delay_203_lyf_lyf183 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[179]),
											.before_enawrite(sta_sig[251]),
								.cin( sin_1_result ),
								.cout( sin_theta_delay_203_lyf_lyf183 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_5_result_40;
System_FIFO_64_1  DELAY_NCLK_add_5_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[226]),
											.before_enawrite(sta_sig[188]),
						               .cin(add_5_result),
						               .cout(add_5_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_129_753_lyf198;
System_FIFO_64_1	FIFO_x_reg_129_753_lyf198 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[194]),
											.before_enawrite(sta_sig[228]),
								.cin( add_5_result_40 ),
								.cout( x_reg_129_753_lyf198 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] we_stor_lyf_lyf42;
System_FIFO_64_1	FIFO_we_stor_lyf_lyf42 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[38]),
											.before_enawrite(sta_sig[176]),
								.cin( mul_2_result ),
								.cout( we_stor_lyf_lyf42 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Iambda_d_stor_lyf_lyf42;
System_FIFO_64_1	FIFO_Iambda_d_stor_lyf_lyf42 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[38]),
											.before_enawrite(sta_sig[266]),
								.cin( add_8_result ),
								.cout( Iambda_d_stor_lyf_lyf42 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_3_result_40_1;
System_FIFO_64_1  DELAY_NCLK_add_3_result_40_1(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[98]),
											.before_enawrite(sta_sig[60]),
						               .cin(add_3_result),
						               .cout(add_3_result_40_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_641_lyf62;
System_FIFO_64_1	FIFO_x_reg_641_lyf62 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[58]),
											.before_enawrite(sta_sig[100]),
								.cin( add_3_result_40_1 ),
								.cout( x_reg_641_lyf62 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay_204_lyf_lyf183;
System_FIFO_64_1	FIFO_cos_theta_delay_204_lyf_lyf183 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[179]),
											.before_enawrite(sta_sig[251]),
								.cin( cos_1_result ),
								.cout( cos_theta_delay_204_lyf_lyf183 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_reg_402_lyf45;
System_FIFO_64_1	FIFO_cos_reg_402_lyf45 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[41]),
											.before_enawrite(sta_sig[165]),
								.cin( cos_1_result ),
								.cout( cos_reg_402_lyf45 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_theta_delay_203_lyf_lyf133;
System_FIFO_64_1	FIFO_sin_theta_delay_203_lyf_lyf133 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[129]),
											.before_enawrite(sta_sig[251]),
								.cin( sin_1_result ),
								.cout( sin_theta_delay_203_lyf_lyf133 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_2_result_40;
System_FIFO_64_1  DELAY_NCLK_mul_2_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[214]),
											.before_enawrite(sta_sig[176]),
						               .cin(mul_2_result),
						               .cout(mul_2_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_606_lyf186;
System_FIFO_64_1	FIFO_x_reg_606_lyf186 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[182]),
											.before_enawrite(sta_sig[216]),
								.cin( mul_2_result_40 ),
								.cout( x_reg_606_lyf186 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_reg_401_lyf45;
System_FIFO_64_1	FIFO_sin_reg_401_lyf45 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[41]),
											.before_enawrite(sta_sig[166]),
								.cin( sin_1_result ),
								.cout( sin_reg_401_lyf45 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_2_result_40;
System_FIFO_64_1  DELAY_NCLK_add_2_result_40(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[95]),
											.before_enawrite(sta_sig[57]),
						               .cin(add_2_result),
						               .cout(add_2_result_40)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_305_lyf67;
System_FIFO_64_1	FIFO_x_reg_305_lyf67 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[63]),
											.before_enawrite(sta_sig[97]),
								.cin( add_2_result_40 ),
								.cout( x_reg_305_lyf67 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay_204_lyf_lyf133;
System_FIFO_64_1	FIFO_cos_theta_delay_204_lyf_lyf133 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[129]),
											.before_enawrite(sta_sig[251]),
								.cin( cos_1_result ),
								.cout( cos_theta_delay_204_lyf_lyf133 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] we_stor_lyf_lyf48;
System_FIFO_64_1	FIFO_we_stor_lyf_lyf48 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[44]),
											.before_enawrite(sta_sig[176]),
								.cin( mul_2_result ),
								.cout( we_stor_lyf_lyf48 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Iambda_q_stor_lyf_lyf48;
System_FIFO_64_1	FIFO_Iambda_q_stor_lyf_lyf48 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[44]),
											.before_enawrite(sta_sig[266]),
								.cin( mul_6_result ),
								.cout( Iambda_q_stor_lyf_lyf48 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_8_result_40_1;
System_FIFO_64_1  DELAY_NCLK_add_8_result_40_1(
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[141]),
											.before_enawrite(sta_sig[103]),
						               .cin(add_8_result),
						               .cout(add_8_result_40_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] x_reg_618_lyf113;
System_FIFO_64_1	FIFO_x_reg_618_lyf113 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[109]),
											.before_enawrite(sta_sig[143]),
								.cin( add_8_result_40_1 ),
								.cout( x_reg_618_lyf113 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] cos_theta_delay_204_lyf_lyf34;
System_FIFO_64_1	FIFO_cos_theta_delay_204_lyf_lyf34 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[30]),
											.before_enawrite(sta_sig[251]),
								.cin( cos_1_result ),
								.cout( cos_theta_delay_204_lyf_lyf34 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] Pm_lyf;
ComparePm64_water  ComparePm641lyf(
			 .clk(clk),
			 .rst(rst),
			 .rst_user(rst_user),
			 .x(mul_4_result),//C71 305
			 					 
			 .y(Pm_lyf)//307
		   );
			
wire [`EXTENDED_SINGLE - 1:0] Pm_lyf_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_Pm_lyf_1(
						               .clk(clk),
											.rst(rst),
						               .d(Pm_lyf),
						               .q(Pm_lyf_1)
					                 );
////////////////////////////////////////////////////////////////////////////////////////////////////////////////C12

wire [`EXTENDED_SINGLE - 1:0] mul_5_result_FIFO_27;
System_FIFO_64_1	FIFO_mul_5_result_FIFO_27 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[150]),
											.before_enawrite(sta_sig[125]),
								.cin( mul_5_result ),
								.cout( mul_5_result_FIFO_27 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] compare_4_lyf_14;
System_FIFO_64_1	FIFO_compare_4_lyf_14 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[250]),
											.before_enawrite(sta_sig[238]),
								.cin( compare_4_lyf ),
								.cout( compare_4_lyf_14 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_6_result_FIFO_86;
System_FIFO_64_1	FIFO_mul_6_result_FIFO_86 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[287]),
											.before_enawrite(sta_sig[203]),
								.cin( mul_6_result ),
								.cout( mul_6_result_FIFO_86 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] div_1_result_FIFO_15;
System_FIFO_64_1	FIFO_div_1_result_FIFO_15 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[304]),
											.before_enawrite(sta_sig[291]),
								.cin( div_1_result ),
								.cout( div_1_result_FIFO_15 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_8_result_FIFO_18;
System_FIFO_64_1	FIFO_mul_8_result_FIFO_18 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[225]),
											.before_enawrite(sta_sig[209]),
								.cin( mul_8_result ),
								.cout( mul_8_result_FIFO_18 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] mul_8_result_FIFO_18_1;
System_FIFO_64_1	FIFO_mul_8_result_FIFO_18_1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[168]),
											.before_enawrite(sta_sig[152]),
								.cin( mul_8_result ),
								.cout( mul_8_result_FIFO_18_1 )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] mul_10_result_FIFO_18;
System_FIFO_64_1	FIFO_mul_10_result_FIFO_18 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[225]),
											.before_enawrite(sta_sig[209]),
								.cin( mul_10_result ),
								.cout( mul_10_result_FIFO_18 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_6_result_FIFO_45;
System_FIFO_64_1	FIFO_mul_6_result_FIFO_45 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[168]),
											.before_enawrite(sta_sig[125]),
								.cin( mul_6_result ),
								.cout( mul_6_result_FIFO_45 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_4_result_FIFO_18;
System_FIFO_64_1	FIFO_add_4_result_FIFO_18 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[204]),
											.before_enawrite(sta_sig[188]),
								.cin( add_4_result ),
								.cout( add_4_result_FIFO_18 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_1_result_FIFO_70;
System_FIFO_64_1	FIFO_sin_1_result_FIFO_70 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[234]),
											.before_enawrite(sta_sig[166]),
								.cin( sin_1_result ),
								.cout( sin_1_result_FIFO_70 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_2_result_FIFO_18;
System_FIFO_64_1	FIFO_add_2_result_FIFO_18 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[73]),
											.before_enawrite(sta_sig[57]),
								.cin( add_2_result ),
								.cout( add_2_result_FIFO_18 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_1_lyf_35;
System_FIFO_64_1	FIFO_limit_1_lyf_35 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[168]),
											.before_enawrite(sta_sig[135]),
								.cin( limit_1_lyf ),
								.cout( limit_1_lyf_35 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_5_result_FIFO_18;
System_FIFO_64_1	FIFO_add_5_result_FIFO_18 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[204]),
											.before_enawrite(sta_sig[188]),
								.cin( add_5_result ),
								.cout( add_5_result_FIFO_18 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_1_result_FIFO_71;
System_FIFO_64_1	FIFO_cos_1_result_FIFO_71 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[234]),
											.before_enawrite(sta_sig[165]),
								.cin( cos_1_result ),
								.cout( cos_1_result_FIFO_71 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_7_lyf_14;
System_FIFO_64_1	FIFO_limit_7_lyf_14 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[249]),
											.before_enawrite(sta_sig[237]),
								.cin( limit_7_lyf ),
								.cout( limit_7_lyf_14 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] mul_7_result_6;
DELAY_NCLK  #(64,6)  DELAY_NCLK_mul_7_result_6(
						               .clk(clk),
											.rst(rst),
						               .d(mul_7_result),
						               .q(mul_7_result_6)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_4_result_FIFO_18_1;
System_FIFO_64_1	FIFO_add_4_result_FIFO_18_1 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[177]),
											.before_enawrite(sta_sig[161]),
								.cin( add_4_result ),
								.cout( add_4_result_FIFO_18_1 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_5_lyf_14;
System_FIFO_64_1	FIFO_limit_5_lyf_14 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[249]),
											.before_enawrite(sta_sig[237]),
								.cin( limit_5_lyf ),
								.cout( limit_5_lyf_14 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] mul_1_result_2;
DELAY_NCLK  #(64,2)  DELAY_NCLK_mul_1_result_2(
						               .clk(clk),
											.rst(rst),
						               .d(mul_1_result),
						               .q(mul_1_result_2)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_5_result_FIFO_27;
System_FIFO_64_1	FIFO_add_5_result_FIFO_27 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[275]),
											.before_enawrite(sta_sig[250]),
								.cin( add_5_result ),
								.cout( add_5_result_FIFO_27 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] div_1_result_FIFO_160;
System_FIFO_64_1	FIFO_div_1_result_FIFO_160 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[304]),
											.before_enawrite(sta_sig[146]),
								.cin( div_1_result ),
								.cout( div_1_result_FIFO_160 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] cos_1_result_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_cos_1_result_1(
						               .clk(clk),
											.rst(rst),
						               .d(cos_1_result),
						               .q(cos_1_result_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_9_result_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_mul_9_result_8(
						               .clk(clk),
											.rst(rst),
						               .d(mul_9_result),
						               .q(mul_9_result_8)
					                 );
wire [`EXTENDED_SINGLE - 1:0] mul_1_result_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_mul_1_result_8(
						               .clk(clk),
											.rst(rst),
						               .d(mul_1_result),
						               .q(mul_1_result_8)
					                 );
wire [`EXTENDED_SINGLE - 1:0] limit_1_lyf_50;
System_FIFO_64_1	FIFO_limit_1_lyf_50 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[183]),
											.before_enawrite(sta_sig[135]),
								.cin( limit_1_lyf ),
								.cout( limit_1_lyf_50 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] sin_1_result_FIFO_56;
System_FIFO_64_1	FIFO_sin_1_result_FIFO_56 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[220]),
											.before_enawrite(sta_sig[166]),
								.cin( sin_1_result ),
								.cout( sin_1_result_FIFO_56 )
					                 );

wire [`EXTENDED_SINGLE - 1:0] cos_1_result_FIFO_57;
System_FIFO_64_1	FIFO_cos_1_result_FIFO_57 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[220]),
											.before_enawrite(sta_sig[165]),
								.cin( cos_1_result ),
								.cout( cos_1_result_FIFO_57 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] div_1_result_4;
DELAY_NCLK  #(64,4)  DELAY_NCLK_div_1_result_4(
						               .clk(clk),
											.rst(rst),
						               .d(div_1_result),
						               .q(div_1_result_4)
					                 );
wire [`EXTENDED_SINGLE - 1:0] div_1_result_FIFO_19;
System_FIFO_64_1	FIFO_div_1_result_FIFO_19 (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[244]),
											.before_enawrite(sta_sig[227]),
								.cin( div_1_result ),
								.cout( div_1_result_FIFO_19 )
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_3_result_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_add_3_result_8(
						               .clk(clk),
											.rst(rst),
						               .d(add_3_result),
						               .q(add_3_result_8)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_9_result_8;
DELAY_NCLK  #(64,8)  DELAY_NCLK_add_9_result_8(
						               .clk(clk),
											.rst(rst),
						               .d(add_9_result),
						               .q(add_9_result_8)
					                 );

wire [`EXTENDED_SINGLE - 1:0] add_9_result_9;
DELAY_NCLK  #(64,9)  DELAY_NCLK_add_9_result_9(
						               .clk(clk),
											.rst(rst),
						               .d(add_9_result),
						               .q(add_9_result_9)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_5_result_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_add_5_result_1(
						               .clk(clk),
											.rst(rst),
						               .d(add_5_result),
						               .q(add_5_result_1)
					                 );
wire [`EXTENDED_SINGLE - 1:0] add_6_result_1;
DELAY_NCLK  #(64,1)  DELAY_NCLK_add_6_result_1(
						               .clk(clk),
											.rst(rst),
						               .d(add_6_result),
						               .q(add_6_result_1)
					                 );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////C11

wire [`EXTENDED_SINGLE - 1:0] add_1_A_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd48),//7
															  .value_1(add_8_result),
															  .time_2(12'd77),//51
															  .value_2(mul_10_result),
															  .time_3(12'd101),//59
															  .value_3(add_7_result),
															  .time_4(12'd125),//13
															  .value_4(mul_2_result),
															  .time_5(12'd154),//61
															  .value_5(mul_7_result),
															  .time_6(12'd174),//81
															  .value_6(mul_7_result),
															  .time_7(12'd196),//85
															  .value_7(mul_9_result),
															  .time_8(12'd211),//35
															  .value_8(mul_7_result),
															  .time_9(12'd230),//92
															  .value_9(mul_6_result),
															  .time_10(12'd245),//43
															  .value_10(mul_5_result),
															  .time_11(12'd269),//102
															  .value_11(compare_2_lyf),
													        .y(add_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_1_B_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd48),//7
															  .value_1(mul_6_result),
															  .time_2(12'd77),//51
															  .value_2(mul_1_result),
															  .time_3(12'd101),//59
															  .value_3(mul_1_result),
															  .time_4(12'd125),//13
															  .value_4(mul_3_result),
															  .time_5(12'd154),//61
															  .value_5(y_reg_130_735_lyf154),
															  .time_6(12'd174),//81
															  .value_6(mul_8_result),
															  .time_7(12'd196),//85
															  .value_7(y_reg_130_550_lyf196),
															  .time_8(12'd211),//35
															  .value_8(y_reg_130_512_lyf211),
															  .time_9(12'd230),//92
															  .value_9(mul_7_result),
															  .time_10(12'd245),//43
															  .value_10(mul_8_result),
															  .time_11(12'd269),//102
															  .value_11(compare_3_lyf),
													        .y(add_1_B_ctrl_fuyong)
													        );	
wire add_1_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_11 add_1_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd48),//7
															  .value_1(`sub),
															  .time_2(12'd77),//51
															  .value_2(`add),
															  .time_3(12'd101),//59
															  .value_3(`add),
															  .time_4(12'd125),//13
															  .value_4(`add),
															  .time_5(12'd154),//61
															  .value_5(`add),
															  .time_6(12'd174),//81
															  .value_6(`add),
															  .time_7(12'd196),//85
															  .value_7(`add),
															  .time_8(12'd211),//35
															  .value_8(`add),
															  .time_9(12'd230),//92
															  .value_9(`add),
															  .time_10(12'd245),//43
															  .value_10(`add),
															  .time_11(12'd269),//102
															  .value_11(`sub),
													        .y(add_1_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_2_A_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_2_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//1
															  .value_1(Vb_PM_64),
															  .time_2(12'd51),//70
															  .value_2(mul_7_result),
															  .time_3(12'd79),//55
															  .value_3(V3a_64_67),
															  .time_4(12'd105),//53
															  .value_4(mul_3_result),
															  .time_5(12'd125),//14
															  .value_5(mul_1_result),
															  .time_6(12'd154),//64
															  .value_6(mul_5_result_FIFO_27),
															  .time_7(12'd174),//82
															  .value_7(mul_9_result),
															  .time_8(12'd196),//88
															  .value_8(mul_10_result),
															  .time_9(12'd211),//38
															  .value_9(mul_9_result),
															  .time_10(12'd230),//93
															  .value_10(mul_5_result),
															  .time_11(12'd245),//44
															  .value_11(mul_7_result),
															  .time_12(12'd274),//20
															  .value_12(mul_9_result),
													        .y(add_2_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_2_B_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_2_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//1
															  .value_1(Vc_PM_64),
															  .time_2(12'd51),//70
															  .value_2(mul_8_result),
															  .time_3(12'd79),//55
															  .value_3(V3b_64_67),
															  .time_4(12'd105),//53
															  .value_4(mul_4_result),
															  .time_5(12'd125),//14
															  .value_5(mul_4_result),
															  .time_6(12'd154),//64
															  .value_6(y_reg_130_773_lyf154),
															  .time_7(12'd174),//82
															  .value_7(mul_10_result),
															  .time_8(12'd196),//88
															  .value_8(y_reg_130_754_lyf196),
															  .time_9(12'd211),//38
															  .value_9(y_reg_130_531_lyf211),
															  .time_10(12'd230),//93
															  .value_10(mul_8_result),
															  .time_11(12'd245),//44
															  .value_11(mul_6_result),
															  .time_12(12'd274),//20
															  .value_12(mul_10_result),
													        .y(add_2_B_ctrl_fuyong)
													        );	
wire add_2_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_12 add_2_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd12),//1
															  .value_1(`add),
															  .time_2(12'd51),//70
															  .value_2(`sub),
															  .time_3(12'd79),//55
															  .value_3(`sub),
															  .time_4(12'd105),//53
															  .value_4(`add),
															  .time_5(12'd125),//14
															  .value_5(`add),
															  .time_6(12'd154),//64
															  .value_6(`add),
															  .time_7(12'd174),//82
															  .value_7(`add),
															  .time_8(12'd196),//88
															  .value_8(`add),
															  .time_9(12'd211),//38
															  .value_9(`add),
															  .time_10(12'd230),//93
															  .value_10(`add),
															  .time_11(12'd245),//44
															  .value_11(`sub),
															  .time_12(12'd274),//20
															  .value_12(`sub),
													        .y(add_2_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_3_A_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_3_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//2
															  .value_1(Vb_PM_64_8),
															  .time_2(12'd54),//6
															  .value_2(add_9_result),
															  .time_3(12'd79),//56
															  .value_3(V3b_64_67),
															  .time_4(12'd107),//75
															  .value_4(add_9_result),
															  .time_5(12'd125),//15
															  .value_5(mul_3_result),
															  .time_6(12'd154),//80
															  .value_6(mul_9_result),
															  .time_7(12'd177),//31
															  .value_7(add_7_result),
															  .time_8(12'd197),//33
															  .value_8(limit_3_lyf),
															  .time_9(12'd214),//87
															  .value_9(limit_14_lyf),
															  .time_10(12'd230),//94
															  .value_10(mul_7_result),
															  .time_11(12'd254),//98
															  .value_11(compare_4_lyf_14),
															  .time_12(12'd274),//100
															  .value_12(mul_1_result),
													        .y(add_3_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_3_B_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_3_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//2
															  .value_1(Vc_PM_64_8),
															  .time_2(12'd54),//6
															  .value_2(mul_9_result),
															  .time_3(12'd79),//56
															  .value_3(V3c_64_67),
															  .time_4(12'd107),//75
															  .value_4(mul_5_result),
															  .time_5(12'd125),//15
															  .value_5(mul_2_result),
															  .time_6(12'd154),//80
															  .value_6(add_8_result),
															  .time_7(12'd177),//31
															  .value_7(mul_1_result),
															  .time_8(12'd197),//33
															  .value_8(mul_2_result),
															  .time_9(12'd214),//87
															  .value_9(mul_1_result),
															  .time_10(12'd230),//94
															  .value_10(mul_6_result),
															  .time_11(12'd254),//98
															  .value_11(compare_5_lyf),
															  .time_12(12'd274),//100
															  .value_12(mul_2_result),
													        .y(add_3_B_ctrl_fuyong)
													        );	
wire add_3_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_12 add_3_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//2
															  .value_1(`sub),
															  .time_2(12'd54),//6
															  .value_2(`add),
															  .time_3(12'd79),//56
															  .value_3(`sub),
															  .time_4(12'd107),//75
															  .value_4(`add),
															  .time_5(12'd125),//15
															  .value_5(`sub),
															  .time_6(12'd154),//80
															  .value_6(`sub),
															  .time_7(12'd177),//31
															  .value_7(`add),
															  .time_8(12'd197),//33
															  .value_8(`sub),
															  .time_9(12'd214),//87
															  .value_9(`add),
															  .time_10(12'd230),//94
															  .value_10(`sub),
															  .time_11(12'd254),//98
															  .value_11(`sub),
															  .time_12(12'd274),//100
															  .value_12(`sub),
													        .y(add_3_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_4_A_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_4_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//3
															  .value_1(mul_2_result),
															  .time_2(12'd62),//10
															  .value_2(mul_1_result),
															  .time_3(12'd83),//73
															  .value_3(limit_12_lyf),
															  .time_4(12'd111),//22
															  .value_4(mul_6_result),
															  .time_5(12'd127),//24
															  .value_5(add_8_result),
															  .time_6(12'd155),//29
															  .value_6(P_PM_Cal_lyf_33),
															  .time_7(12'd182),//83
															  .value_7(limit_9_lyf),
															  .time_8(12'd197),//34
															  .value_8(idref_lyf_lyf),
															  .time_9(12'd214),//90
															  .value_9(limit_16_lyf),
															  .time_10(12'd230),//95
															  .value_10(mul_9_result),
															  .time_11(12'd254),//99
															  .value_11(compare_5_lyf),
															  .time_12(12'd289),//103
															  .value_12(mul_8_result),
													        .y(add_4_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_4_B_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_4_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//3
															  .value_1(add_2_result),
															  .time_2(12'd62),//10
															  .value_2(mul_2_result),
															  .time_3(12'd83),//73
															  .value_3(mul_2_result),
															  .time_4(12'd111),//22
															  .value_4(y_reg_620_lyf111),
															  .time_5(12'd127),//24
															  .value_5(wm_starter_lyf_lyf),
															  .time_6(12'd155),//29
															  .value_6(mul_10_result),
															  .time_7(12'd182),//83
															  .value_7(add_2_result),
															  .time_8(12'd197),//34
															  .value_8(mul_1_result),
															  .time_9(12'd214),//90
															  .value_9(mul_2_result),
															  .time_10(12'd230),//95
															  .value_10(mul_10_result),
															  .time_11(12'd254),//99
															  .value_11(compare_6_lyf),
															  .time_12(12'd289),//103
															  .value_12(mul_9_result),
													        .y(add_4_B_ctrl_fuyong)
													        );	
wire add_4_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_12 add_4_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd20),//3
															  .value_1(`sub),
															  .time_2(12'd62),//10
															  .value_2(`add),
															  .time_3(12'd83),//73
															  .value_3(`add),
															  .time_4(12'd111),//22
															  .value_4(`add),
															  .time_5(12'd127),//24
															  .value_5(`add),
															  .time_6(12'd155),//29
															  .value_6(`sub),
															  .time_7(12'd182),//83
															  .value_7(`sub),
															  .time_8(12'd197),//34
															  .value_8(`sub),
															  .time_9(12'd214),//90
															  .value_9(`add),
															  .time_10(12'd230),//95
															  .value_10(`add),
															  .time_11(12'd254),//99
															  .value_11(`sub),
															  .time_12(12'd289),//103
															  .value_12(`sub),
													        .y(add_4_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_5_A_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_5_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd23),//67
															  .value_1(mul_4_result),
															  .time_2(12'd65),//71
															  .value_2(mul_3_result),
															  .time_3(12'd85),//52
															  .value_3(add_1_result),
															  .time_4(12'd113),//54
															  .value_4(add_2_result),
															  .time_5(12'd139),//17
															  .value_5(mul_7_result),
															  .time_6(12'd162),//62
															  .value_6(add_1_result),
															  .time_7(12'd182),//84
															  .value_7(limit_11_lyf),
															  .time_8(12'd200),//27
															  .value_8(add_9_result),
															  .time_9(12'd219),//36
															  .value_9(add_1_result),
															  .time_10(12'd244),//49
															  .value_10(div_1_result),
															  .time_11(12'd259),//45
															  .value_11(mul_3_result),
															  .time_12(12'd291),//50
															  .value_12(mul_10_result),
													        .y(add_5_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_5_B_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_5_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd23),//67
															  .value_1(mul_3_result),
															  .time_2(12'd65),//71
															  .value_2(y_reg_307_lyf65),
															  .time_3(12'd85),//52
															  .value_3(mul_3_result),
															  .time_4(12'd113),//54
															  .value_4(mul_7_result),
															  .time_5(12'd139),//17
															  .value_5(mul_8_result),
															  .time_6(12'd162),//62
															  .value_6(mul_2_result),
															  .time_7(12'd182),//84
															  .value_7(add_1_result),
															  .time_8(12'd200),//27
															  .value_8(const_2pi_lyf_lyf),
															  .time_9(12'd219),//36
															  .value_9(mul_3_result),
															  .time_10(12'd244),//49
															  .value_10(const5_lyf_lyf),
															  .time_11(12'd259),//45
															  .value_11(mul_4_result),
															  .time_12(12'd291),//50
															  .value_12(mul_6_result_FIFO_86),
													        .y(add_5_B_ctrl_fuyong)
													        );	
wire add_5_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_12 add_5_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd23),//67
															  .value_1(`add),
															  .time_2(12'd65),//71
															  .value_2(`add),
															  .time_3(12'd85),//52
															  .value_3(`add),
															  .time_4(12'd113),//54
															  .value_4(`add),
															  .time_5(12'd139),//17
															  .value_5(`sub),
															  .time_6(12'd162),//62
															  .value_6(`add),
															  .time_7(12'd182),//84
															  .value_7(`sub),
															  .time_8(12'd200),//27
															  .value_8(`sub),
															  .time_9(12'd219),//36
															  .value_9(`add),
															  .time_10(12'd244),//49
															  .value_10(`sub),
															  .time_11(12'd259),//45
															  .value_11(`add),
															  .time_12(12'd291),//50
															  .value_12(`add),
													        .y(add_5_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_6_A_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_6_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd23),//68
															  .value_1(mul_4_result),
															  .time_2(12'd68),//8
															  .value_2(mul_5_result),
															  .time_3(12'd87),//57
															  .value_3(V3c_64_75),
															  .time_4(12'd115),//76
															  .value_4(add_3_result),
															  .time_5(12'd139),//18
															  .value_5(mul_10_result),
															  .time_6(12'd162),//65
															  .value_6(add_2_result),
															  .time_7(12'd184),//25
															  .value_7(mul_3_result),
															  .time_8(12'd200),//28
															  .value_8(add_9_result),
															  .time_9(12'd219),//39
															  .value_9(add_2_result),
															  .time_10(12'd244),//96
															  .value_10(mul_1_result),
															  .time_11(12'd259),//46
															  .value_11(mul_9_result),
															  .time_12(12'd308),//104
															  .value_12(div_1_result),
													        .y(add_6_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_6_B_ctrl_fuyong;	
ctrl_time_12 ctrl_time_add_6_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd23),//68
															  .value_1(mul_3_result),
															  .time_2(12'd68),//8
															  .value_2(mul_6_result),
															  .time_3(12'd87),//57
															  .value_3(V3a_64_75),
															  .time_4(12'd115),//76
															  .value_4(const_2pi_lyf_lyf),
															  .time_5(12'd139),//18
															  .value_5(mul_9_result),
															  .time_6(12'd162),//65
															  .value_6(mul_3_result),
															  .time_7(12'd184),//25
															  .value_7(y_reg_608_lyf184),
															  .time_8(12'd200),//28
															  .value_8(const_2pi_lyf_lyf),
															  .time_9(12'd219),//39
															  .value_9(mul_4_result),
															  .time_10(12'd244),//96
															  .value_10(mul_2_result),
															  .time_11(12'd259),//46
															  .value_11(mul_10_result),
															  .time_12(12'd308),//104
															  .value_12(div_1_result_FIFO_15),
													        .y(add_6_B_ctrl_fuyong)
													        );	
wire add_6_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_12 add_6_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd23),//68
															  .value_1(`sub),
															  .time_2(12'd68),//8
															  .value_2(`add),
															  .time_3(12'd87),//57
															  .value_3(`sub),
															  .time_4(12'd115),//76
															  .value_4(`sub),
															  .time_5(12'd139),//18
															  .value_5(`sub),
															  .time_6(12'd162),//65
															  .value_6(`add),
															  .time_7(12'd184),//25
															  .value_7(`add),
															  .time_8(12'd200),//28
															  .value_8(`add),
															  .time_9(12'd219),//39
															  .value_9(`add),
															  .time_10(12'd244),//96
															  .value_10(`sub),
															  .time_11(12'd259),//46
															  .value_11(`sub),
															  .time_12(12'd308),//104
															  .value_12(`add),
													        .y(add_6_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_7_A_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_7_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd31),//69
															  .value_1(mul_6_result),
															  .time_2(12'd70),//11
															  .value_2(add_4_result),
															  .time_3(12'd93),//58
															  .value_3(mul_6_result),
															  .time_4(12'd115),//77
															  .value_4(add_3_result),
															  .time_5(12'd140),//60
															  .value_5(Vdc_lyf_140),
															  .time_6(12'd169),//30
															  .value_6(mul_6_result),
															  .time_7(12'd187),//32
															  .value_7(limit_2_lyf),
															  .time_8(12'd204),//86
															  .value_8(add_1_result),
															  .time_9(12'd229),//37
															  .value_9(limit_4_lyf),
															  .time_10(12'd244),//97
															  .value_10(mul_4_result),
															  .time_11(12'd259),//47
															  .value_11(mul_2_result),
													        .y(add_7_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_7_B_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_7_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd31),//69
															  .value_1(add_5_result),
															  .time_2(12'd70),//11
															  .value_2(mul_7_result),
															  .time_3(12'd93),//58
															  .value_3(mul_7_result),
															  .time_4(12'd115),//77
															  .value_4(const_2pi_lyf_lyf),
															  .time_5(12'd140),//60
															  .value_5(const_Vdcref_lyf_lyf),
															  .time_6(12'd169),//30
															  .value_6(y_reg_130_716_lyf169),
															  .time_7(12'd187),//32
															  .value_7(mul_4_result),
															  .time_8(12'd204),//86
															  .value_8(mul_4_result),
															  .time_9(12'd229),//37
															  .value_9(mul_8_result_FIFO_18),
															  .time_10(12'd244),//97
															  .value_10(mul_3_result),
															  .time_11(12'd259),//47
															  .value_11(mul_1_result),
													        .y(add_7_B_ctrl_fuyong)
													        );	
wire add_7_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_11 add_7_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd31),//69
															  .value_1(`sub),
															  .time_2(12'd70),//11
															  .value_2(`add),
															  .time_3(12'd93),//58
															  .value_3(`add),
															  .time_4(12'd115),//77
															  .value_4(`add),
															  .time_5(12'd140),//60
															  .value_5(`sub),
															  .time_6(12'd169),//30
															  .value_6(`add),
															  .time_7(12'd187),//32
															  .value_7(`add),
															  .time_8(12'd204),//86
															  .value_8(`add),
															  .time_9(12'd229),//37
															  .value_9(`add),
															  .time_10(12'd244),//97
															  .value_10(`sub),
															  .time_11(12'd259),//47
															  .value_11(`sub),
													        .y(add_7_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_8_A_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_8_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//4
															  .value_1(mul_10_result),
															  .time_2(12'd73),//72
															  .value_2(add_5_result),
															  .time_3(12'd97),//21
															  .value_3(mul_8_result),
															  .time_4(12'd119),//23
															  .value_4(add_4_result),
															  .time_5(12'd146),//78
															  .value_5(mul_3_result),
															  .time_6(12'd172),//63
															  .value_6(limit_8_lyf),
															  .time_7(12'd189),//16
															  .value_7(mul_5_result),
															  .time_8(12'd204),//89
															  .value_8(add_2_result),
															  .time_9(12'd229),//40
															  .value_9(limit_6_lyf),
															  .time_10(12'd245),//41
															  .value_10(mul_8_result),
															  .time_11(12'd260),//19
															  .value_11(mul_5_result),
													        .y(add_8_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_8_B_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_8_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//4
															  .value_1(mul_1_result),
															  .time_2(12'd73),//72
															  .value_2(mul_8_result),
															  .time_3(12'd97),//21
															  .value_3(Tm_lyf_lyf),
															  .time_4(12'd119),//23
															  .value_4(mul_9_result),
															  .time_5(12'd146),//78
															  .value_5(mul_4_result),
															  .time_6(12'd172),//63
															  .value_6(mul_8_result_FIFO_18_1),
															  .time_7(12'd189),//16
															  .value_7(mul_6_result),
															  .time_8(12'd204),//89
															  .value_8(mul_5_result),
															  .time_9(12'd229),//40
															  .value_9(mul_10_result_FIFO_18),
															  .time_10(12'd245),//41
															  .value_10(mul_5_result),
															  .time_11(12'd260),//19
															  .value_11(Flux_lyf_lyf),
													        .y(add_8_B_ctrl_fuyong)
													        );	
wire add_8_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_11 add_8_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd40),//4
															  .value_1(`add),
															  .time_2(12'd73),//72
															  .value_2(`add),
															  .time_3(12'd97),//21
															  .value_3(`sub),
															  .time_4(12'd119),//23
															  .value_4(`add),
															  .time_5(12'd146),//78
															  .value_5(`add),
															  .time_6(12'd172),//63
															  .value_6(`add),
															  .time_7(12'd189),//16
															  .value_7(`add),
															  .time_8(12'd204),//89
															  .value_8(`add),
															  .time_9(12'd229),//40
															  .value_9(`add),
															  .time_10(12'd245),//41
															  .value_10(`sub),
															  .time_11(12'd260),//19
															  .value_11(`add),
													        .y(add_8_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_9_A_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_9_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//5
															  .value_1(mul_4_result),
															  .time_2(12'd76),//9
															  .value_2(add_6_result),
															  .time_3(12'd99),//74
															  .value_3(mul_10_result),
															  .time_4(12'd125),//12
															  .value_4(mul_4_result),
															  .time_5(12'd146),//79
															  .value_5(mul_3_result),
															  .time_6(12'd172),//66
															  .value_6(limit_10_lyf),
															  .time_7(12'd192),//26
															  .value_7(add_6_result),
															  .time_8(12'd210),//48
															  .value_8(div_1_result),
															  .time_9(12'd230),//91
															  .value_9(mul_8_result),
															  .time_10(12'd245),//42
															  .value_10(mul_6_result),
															  .time_11(12'd269),//101
															  .value_11(compare_1_lyf),
													        .y(add_9_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] add_9_B_ctrl_fuyong;	
ctrl_time_11 ctrl_time_add_9_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//5
															  .value_1(mul_5_result),
															  .time_2(12'd76),//9
															  .value_2(mul_9_result),
															  .time_3(12'd99),//74
															  .value_3(y_reg_327_360_lyf99),
															  .time_4(12'd125),//12
															  .value_4(mul_1_result),
															  .time_5(12'd146),//79
															  .value_5(mul_4_result),
															  .time_6(12'd172),//66
															  .value_6(mul_6_result_FIFO_45),
															  .time_7(12'd192),//26
															  .value_7(mul_7_result),
															  .time_8(12'd210),//48
															  .value_8(inner_result5_lyf_lyf),
															  .time_9(12'd230),//91
															  .value_9(mul_5_result),
															  .time_10(12'd245),//42
															  .value_10(mul_7_result),
															  .time_11(12'd269),//101
															  .value_11(compare_2_lyf),
													        .y(add_9_B_ctrl_fuyong)
													        );	
wire add_9_add_sub_ctrl_fuyong;	
ctrl_time_ADDSUB_11 add_9_add_sub(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd46),//5
															  .value_1(`add),
															  .time_2(12'd76),//9
															  .value_2(`add),
															  .time_3(12'd99),//74
															  .value_3(`add),
															  .time_4(12'd125),//12
															  .value_4(`sub),
															  .time_5(12'd146),//79
															  .value_5(`sub),
															  .time_6(12'd172),//66
															  .value_6(`add),
															  .time_7(12'd192),//26
															  .value_7(`add),
															  .time_8(12'd210),//48
															  .value_8(`sub),
															  .time_9(12'd230),//91
															  .value_9(`sub),
															  .time_10(12'd245),//42
															  .value_10(`add),
															  .time_11(12'd269),//101
															  .value_11(`sub),
													        .y(add_9_add_sub_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_1_A_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd34),//5
															  .value_1(mul_8_result),
															  .time_2(12'd56),//15
															  .value_2(add_1_result),
															  .time_3(12'd71),//76
															  .value_3(Vb_PM_64_59),
															  .time_4(12'd95),//85
															  .value_4(add_6_result),
															  .time_5(12'd119),//18
															  .value_5(Id_temp_lyf_34),
															  .time_6(12'd137),//39
															  .value_6(limit_1_lyf),
															  .time_7(12'd154),//113
															  .value_7(add_9_result),
															  .time_8(12'd171),//43
															  .value_8(A2_701_lyf_lyf),
															  .time_9(12'd191),//45
															  .value_9(Id_temp_lyf_106),
															  .time_10(12'd208),//120
															  .value_10(add_4_result_FIFO_18),
															  .time_11(12'd238),//128
															  .value_11(add_9_result),
															  .time_12(12'd253),//59
															  .value_12(add_1_result),
															  .time_13(12'd268),//136
															  .value_13(mul_7_result),
															  .time_14(12'd287),//64
															  .value_14(mul_6_result),
													        .y(mul_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_1_B_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd34),//5
															  .value_1(sin_theta_delay_203_lyf_lyf34),
															  .time_2(12'd56),//15
															  .value_2(A_647_lyf_lyf),
															  .time_3(12'd71),//76
															  .value_3(Ib_pm_rect_64_59),
															  .time_4(12'd95),//85
															  .value_4(I3b_64_83),
															  .time_5(12'd119),//18
															  .value_5(const_1_divide_2_lyf_lyf),
															  .time_6(12'd137),//39
															  .value_6(limit_1_lyf),
															  .time_7(12'd154),//113
															  .value_7(const_sqrt_3_divide_3_lyf_lyf),
															  .time_8(12'd171),//43
															  .value_8(x_reg_129_715_lyf171),
															  .time_9(12'd191),//45
															  .value_9(const1_rec_lyf_lyf),
															  .time_10(12'd208),//120
															  .value_10(A1_553_lyf_lyf),
															  .time_11(12'd238),//128
															  .value_11(sin_1_result_FIFO_70),
															  .time_12(12'd253),//59
															  .value_12(sin_1_result),
															  .time_13(12'd268),//136
															  .value_13(Ia_SFM_Inv_64_256),
															  .time_14(12'd287),//64
															  .value_14(VWind64_lyf_lyf),
													        .y(mul_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_2_A_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_2_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd14),//1
															  .value_1(Va_PM_64_2),
															  .time_2(12'd34),//143
															  .value_2(mul_8_result),
															  .time_3(12'd56),//16
															  .value_3(B_648_lyf_lyf),
															  .time_4(12'd77),//107
															  .value_4(add_2_result_FIFO_18),
															  .time_5(12'd99),//79
															  .value_5(mul_9_result),
															  .time_6(12'd119),//19
															  .value_6(Iq_temp_lyf_40),
															  .time_7(12'd137),//40
															  .value_7(limit_1_lyf),
															  .time_8(12'd156),//89
															  .value_8(A2_720_lyf_lyf),
															  .time_9(12'd172),//36
															  .value_9(limit_1_lyf_35),
															  .time_10(12'd191),//46
															  .value_10(Iq_temp_lyf_112),
															  .time_11(12'd208),//123
															  .value_11(add_5_result_FIFO_18),
															  .time_12(12'd238),//129
															  .value_12(add_1_result),
															  .time_13(12'd253),//60
															  .value_13(add_2_result),
															  .time_14(12'd268),//137
															  .value_14(mul_8_result),
															  .time_15(12'd287),//66
															  .value_15(mul_7_result),
													        .y(mul_2_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_2_B_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_2_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd14),//1
															  .value_1(const_2_lyf_lyf),
															  .time_2(12'd34),//143
															  .value_2(const_fu1_lyf_lyf),
															  .time_3(12'd56),//16
															  .value_3(x_reg_664_lyf56),
															  .time_4(12'd77),//107
															  .value_4(A1_290_lyf_lyf),
															  .time_5(12'd99),//79
															  .value_5(G_004_263_lyf_lyf),
															  .time_6(12'd119),//19
															  .value_6(const_1_divide_2_lyf_lyf),
															  .time_7(12'd137),//40
															  .value_7(const1_25_lyf_lyf),
															  .time_8(12'd156),//89
															  .value_8(x_reg_129_734_lyf156),
															  .time_9(12'd172),//36
															  .value_9(P_double_lyf_lyf),
															  .time_10(12'd191),//46
															  .value_10(const1_rec_lyf_lyf),
															  .time_11(12'd208),//123
															  .value_11(A1_738_lyf_lyf),
															  .time_12(12'd238),//129
															  .value_12(cos_1_result_FIFO_71),
															  .time_13(12'd253),//60
															  .value_13(cos_1_result),
															  .time_14(12'd268),//137
															  .value_14(Ic_SFM_Inv_64_256),
															  .time_15(12'd287),//66
															  .value_15(constAr_lyf_lyf),
													        .y(mul_2_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_3_A_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_3_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd17),//95
															  .value_1(V3b_64_5),
															  .time_2(12'd39),//101
															  .value_2(add_7_result),
															  .time_3(12'd59),//105
															  .value_3(add_2_result),
															  .time_4(12'd79),//77
															  .value_4(Vc_PM_64_67),
															  .time_5(12'd99),//80
															  .value_5(mul_9_result),
															  .time_6(12'd119),//20
															  .value_6(Id_temp_lyf_34),
															  .time_7(12'd140),//98
															  .value_7(I3b_64_128),
															  .time_8(12'd156),//92
															  .value_8(A2_758_lyf_lyf),
															  .time_9(12'd178),//37
															  .value_9(mul_2_result),
															  .time_10(12'd193),//62
															  .value_10(mul_8_result),
															  .time_11(12'd213),//48
															  .value_11(A2_516_lyf_lyf),
															  .time_12(12'd238),//130
															  .value_12(add_2_result),
															  .time_13(12'd253),//73
															  .value_13(limit_7_lyf_14),
															  .time_14(12'd277),//138
															  .value_14(add_9_result),
															  .time_15(12'd293),//67
															  .value_15(mul_1_result),
													        .y(mul_3_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_3_B_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_3_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd17),//95
															  .value_1(const_inv_Vbase_lyf_lyf),
															  .time_2(12'd39),//101
															  .value_2(const_1_divide_3_lyf_lyf),
															  .time_3(12'd59),//105
															  .value_3(A2_291_lyf_lyf),
															  .time_4(12'd79),//77
															  .value_4(Ic_pm_rect_64_67),
															  .time_5(12'd99),//80
															  .value_5(A_001_260_lyf_lyf),
															  .time_6(12'd119),//20
															  .value_6(const_sqrt_3_divide_2_lyf_lyf),
															  .time_7(12'd140),//98
															  .value_7(const_inv_Ibase_lyf_lyf),
															  .time_8(12'd156),//92
															  .value_8(x_reg_129_772_lyf156),
															  .time_9(12'd178),//37
															  .value_9(A_600_lyf_lyf),
															  .time_10(12'd193),//62
															  .value_10(div_1_result),
															  .time_11(12'd213),//48
															  .value_11(x_reg_129_511_lyf213),
															  .time_12(12'd238),//130
															  .value_12(sin_1_result_FIFO_70),
															  .time_13(12'd253),//73
															  .value_13(sin_1_result),
															  .time_14(12'd277),//138
															  .value_14(Vdc_lyf_277),
															  .time_15(12'd293),//67
															  .value_15(mul_2_result),
													        .y(mul_3_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_4_A_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_4_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd17),//96
															  .value_1(V3c_64_5),
															  .time_2(12'd40),//6
															  .value_2(mul_7_result_6),
															  .time_3(12'd62),//10
															  .value_3(add_3_result),
															  .time_4(12'd79),//142
															  .value_4(Iq_temp_lyf),
															  .time_5(12'd99),//81
															  .value_5(B_002_261_lyf_lyf),
															  .time_6(12'd119),//21
															  .value_6(Iq_temp_lyf_40),
															  .time_7(12'd140),//99
															  .value_7(I3c_64_128),
															  .time_8(12'd162),//111
															  .value_8(add_3_result),
															  .time_9(12'd181),//44
															  .value_9(add_4_result_FIFO_18_1),
															  .time_10(12'd198),//119
															  .value_10(A2_554_lyf_lyf),
															  .time_11(12'd213),//51
															  .value_11(A2_535_lyf_lyf),
															  .time_12(12'd238),//131
															  .value_12(add_3_result),
															  .time_13(12'd253),//74
															  .value_13(limit_5_lyf_14),
															  .time_14(12'd277),//139
															  .value_14(add_1_result),
															  .time_15(12'd299),//71
															  .value_15(add_5_result),
													        .y(mul_4_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_4_B_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_4_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd17),//96
															  .value_1(const_inv_Vbase_lyf_lyf),
															  .time_2(12'd40),//6
															  .value_2(sin_theta_delay_203_lyf_lyf40),
															  .time_3(12'd62),//10
															  .value_3(G_627_lyf_lyf),
															  .time_4(12'd79),//142
															  .value_4(Flux_lyf_lyf),
															  .time_5(12'd99),//81
															  .value_5(x_reg_019_278_lyf99),
															  .time_6(12'd119),//21
															  .value_6(const_sqrt_3_divide_2_lyf_lyf),
															  .time_7(12'd140),//99
															  .value_7(const_inv_Ibase_lyf_lyf),
															  .time_8(12'd162),//111
															  .value_8(const_1_divide_3_lyf_lyf),
															  .time_9(12'd181),//44
															  .value_9(A1_700_lyf_lyf),
															  .time_10(12'd198),//119
															  .value_10(x_reg_129_549_lyf198),
															  .time_11(12'd213),//51
															  .value_11(x_reg_129_530_lyf213),
															  .time_12(12'd238),//131
															  .value_12(cos_1_result_FIFO_71),
															  .time_13(12'd253),//74
															  .value_13(cos_1_result),
															  .time_14(12'd277),//139
															  .value_14(Vdc_lyf_277),
															  .time_15(12'd299),//71
															  .value_15(mul_3_result),
													        .y(mul_4_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_5_A_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_5_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd19),//94
															  .value_1(V3a_64_7),
															  .time_2(12'd40),//7
															  .value_2(mul_2_result),
															  .time_3(12'd62),//11
															  .value_3(add_3_result),
															  .time_4(12'd85),//32
															  .value_4(mul_4_result),
															  .time_5(12'd101),//109
															  .value_5(A2_347_lyf_lyf),
															  .time_6(12'd121),//91
															  .value_6(mul_10_result),
															  .time_7(12'd142),//97
															  .value_7(I3a_64_130),
															  .time_8(12'd162),//114
															  .value_8(mul_1_result_2),
															  .time_9(12'd183),//26
															  .value_9(Id_temp_lyf_98),
															  .time_10(12'd198),//122
															  .value_10(A2_739_lyf_lyf),
															  .time_11(12'd224),//124
															  .value_11(limit_15_lyf),
															  .time_12(12'd239),//53
															  .value_12(limit_7_lyf),
															  .time_13(12'd254),//28
															  .value_13(Id_temp_lyf_169),
															  .time_14(12'd279),//69
															  .value_14(add_5_result_FIFO_27),
															  .time_15(12'd308),//72
															  .value_15(Pm_lyf_1),
													        .y(mul_5_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_5_B_ctrl_fuyong;	
ctrl_time_15 ctrl_time_mul_5_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd19),//94
															  .value_1(const_inv_Vbase_lyf_lyf),
															  .time_2(12'd40),//7
															  .value_2(cos_theta_delay_204_lyf_lyf40),
															  .time_3(12'd62),//11
															  .value_3(A_624_lyf_lyf),
															  .time_4(12'd85),//32
															  .value_4(const1_lyf_lyf_lyf),
															  .time_5(12'd101),//109
															  .value_5(x_reg_325_358_lyf101),
															  .time_6(12'd121),//91
															  .value_6(A2_758_lyf_lyf),
															  .time_7(12'd142),//97
															  .value_7(const_inv_Ibase_lyf_lyf),
															  .time_8(12'd162),//114
															  .value_8(const_fu1_lyf_lyf),
															  .time_9(12'd183),//26
															  .value_9(sin_theta_delay_203_lyf_lyf183),
															  .time_10(12'd198),//122
															  .value_10(x_reg_129_753_lyf198),
															  .time_11(12'd224),//124
															  .value_11(const_1_divide_2_lyf_lyf),
															  .time_12(12'd239),//53
															  .value_12(const_1_divide_2_lyf_lyf),
															  .time_13(12'd254),//28
															  .value_13(Ld_lyf_lyf),
															  .time_14(12'd279),//69
															  .value_14(const4_lyf_lyf),
															  .time_15(12'd308),//72
															  .value_15(div_1_result_FIFO_160),
													        .y(mul_5_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_6_A_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_6_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd25),//100
															  .value_1(mul_5_result),
															  .time_2(12'd42),//9
															  .value_2(we_stor_lyf_lyf42),
															  .time_3(12'd62),//12
															  .value_3(B_625_lyf_lyf),
															  .time_4(12'd87),//83
															  .value_4(add_2_result),
															  .time_5(12'd105),//34
															  .value_5(add_8_result),
															  .time_6(12'd121),//93
															  .value_6(mul_10_result),
															  .time_7(12'd143),//41
															  .value_7(mul_2_result),
															  .time_8(12'd163),//42
															  .value_8(add_4_result),
															  .time_9(12'd183),//27
															  .value_9(Iq_temp_lyf_104),
															  .time_10(12'd199),//68
															  .value_10(mul_3_result),
															  .time_11(12'd224),//125
															  .value_11(limit_17_lyf),
															  .time_12(12'd239),//54
															  .value_12(limit_5_lyf),
															  .time_13(12'd262),//29
															  .value_13(Iq_temp_lyf_183),
															  .time_14(12'd281),//63
															  .value_14(VWind64_lyf_lyf),
													        .y(mul_6_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_6_B_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_6_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd25),//100
															  .value_1(const_2_lyf_lyf),
															  .time_2(12'd42),//9
															  .value_2(Iambda_d_stor_lyf_lyf42),
															  .time_3(12'd62),//12
															  .value_3(x_reg_641_lyf62),
															  .time_4(12'd87),//83
															  .value_4(I3c_64_75),
															  .time_5(12'd105),//34
															  .value_5(A_622_lyf_lyf),
															  .time_6(12'd121),//93
															  .value_6(A1_757_lyf_lyf),
															  .time_7(12'd143),//41
															  .value_7(mul_1_result),
															  .time_8(12'd163),//42
															  .value_8(A2_701_lyf_lyf),
															  .time_9(12'd183),//27
															  .value_9(cos_theta_delay_204_lyf_lyf183),
															  .time_10(12'd199),//68
															  .value_10(const8_lyf_lyf),
															  .time_11(12'd224),//125
															  .value_11(const_1_divide_2_lyf_lyf),
															  .time_12(12'd239),//54
															  .value_12(const_1_divide_2_lyf_lyf),
															  .time_13(12'd262),//29
															  .value_13(Lq_lyf_lyf),
															  .time_14(12'd281),//63
															  .value_14(VWind64_lyf_lyf),
													        .y(mul_6_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_7_A_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_7_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd28),//2
															  .value_1(add_4_result),
															  .time_2(12'd45),//102
															  .value_2(mul_3_result),
															  .time_3(12'd64),//17
															  .value_3(C_649_lyf_lyf),
															  .time_4(12'd87),//84
															  .value_4(add_3_result),
															  .time_5(12'd107),//82
															  .value_5(C_003_262_lyf_lyf),
															  .time_6(12'd133),//22
															  .value_6(add_9_result),
															  .time_7(12'd148),//88
															  .value_7(add_7_result),
															  .time_8(12'd168),//112
															  .value_8(mul_4_result),
															  .time_9(12'd186),//38
															  .value_9(B_601_lyf_lyf),
															  .time_10(12'd205),//47
															  .value_10(add_3_result),
															  .time_11(12'd224),//126
															  .value_11(limit_15_lyf),
															  .time_12(12'd239),//55
															  .value_12(limit_7_lyf),
															  .time_13(12'd262),//134
															  .value_13(add_3_result),
															  .time_14(12'd281),//65
															  .value_14(const3_lyf_lyf),
													        .y(mul_7_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_7_B_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_7_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd28),//2
															  .value_1(const_1_divide_3_lyf_lyf),
															  .time_2(12'd45),//102
															  .value_2(cos_reg_402_lyf45),
															  .time_3(12'd64),//17
															  .value_3(y_reg_666_lyf64),
															  .time_4(12'd87),//84
															  .value_4(I3a_64_75),
															  .time_5(12'd107),//82
															  .value_5(y_reg_021_280_lyf107),
															  .time_6(12'd133),//22
															  .value_6(sin_theta_delay_203_lyf_lyf133),
															  .time_7(12'd148),//88
															  .value_7(A2_720_lyf_lyf),
															  .time_8(12'd168),//112
															  .value_8(cos_1_result_1),
															  .time_9(12'd186),//38
															  .value_9(x_reg_606_lyf186),
															  .time_10(12'd205),//47
															  .value_10(A2_516_lyf_lyf),
															  .time_11(12'd224),//126
															  .value_11(const_sqrt_3_divide_2_lyf_lyf),
															  .time_12(12'd239),//55
															  .value_12(const_sqrt_3_divide_2_lyf_lyf),
															  .time_13(12'd262),//134
															  .value_13(Vdc_lyf_262),
															  .time_14(12'd281),//65
															  .value_14(constRow_lyf_lyf),
													        .y(mul_7_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_8_A_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_8_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd28),//4
															  .value_1(add_3_result),
															  .time_2(12'd45),//104
															  .value_2(mul_9_result_8),
															  .time_3(12'd67),//106
															  .value_3(A2_291_lyf_lyf),
															  .time_4(12'd91),//33
															  .value_4(mul_5_result),
															  .time_5(12'd109),//86
															  .value_5(add_1_result),
															  .time_6(12'd133),//23
															  .value_6(add_1_result),
															  .time_7(12'd148),//90
															  .value_7(add_7_result),
															  .time_8(12'd168),//115
															  .value_8(mul_1_result_8),
															  .time_9(12'd187),//61
															  .value_9(limit_1_lyf_50),
															  .time_10(12'd205),//49
															  .value_10(add_3_result),
															  .time_11(12'd224),//127
															  .value_11(limit_17_lyf),
															  .time_12(12'd239),//56
															  .value_12(limit_5_lyf),
															  .time_13(12'd262),//135
															  .value_13(add_4_result),
															  .time_14(12'd283),//140
															  .value_14(mul_3_result),
													        .y(mul_8_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_8_B_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_8_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd28),//4
															  .value_1(const_sqrt_3_divide_3_lyf_lyf),
															  .time_2(12'd45),//104
															  .value_2(sin_reg_401_lyf45),
															  .time_3(12'd67),//106
															  .value_3(x_reg_305_lyf67),
															  .time_4(12'd91),//33
															  .value_4(P_double_lyf_lyf),
															  .time_5(12'd109),//86
															  .value_5(const11_040_lyf_lyf),
															  .time_6(12'd133),//23
															  .value_6(cos_theta_delay_204_lyf_lyf133),
															  .time_7(12'd148),//90
															  .value_7(A1_719_lyf_lyf),
															  .time_8(12'd168),//115
															  .value_8(sin_1_result),
															  .time_9(12'd187),//61
															  .value_9(constR_lyf_lyf),
															  .time_10(12'd205),//49
															  .value_10(A1_515_lyf_lyf),
															  .time_11(12'd224),//127
															  .value_11(const_sqrt_3_divide_2_lyf_lyf),
															  .time_12(12'd239),//56
															  .value_12(const_sqrt_3_divide_2_lyf_lyf),
															  .time_13(12'd262),//135
															  .value_13(Vdc_lyf_262),
															  .time_14(12'd283),//140
															  .value_14(Ia_pm_rect_64_271_1),
													        .y(mul_8_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_9_A_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_9_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd31),//103
															  .value_1(add_6_result),
															  .time_2(12'd48),//8
															  .value_2(we_stor_lyf_lyf48),
															  .time_3(12'd70),//13
															  .value_3(C_626_lyf_lyf),
															  .time_4(12'd93),//78
															  .value_4(add_5_result),
															  .time_5(12'd113),//35
															  .value_5(B_623_lyf_lyf),
															  .time_6(12'd133),//24
															  .value_6(add_2_result),
															  .time_7(12'd148),//110
															  .value_7(mul_5_result),
															  .time_8(12'd168),//116
															  .value_8(mul_4_result),
															  .time_9(12'd190),//118
															  .value_9(add_4_result),
															  .time_10(12'd205),//50
															  .value_10(add_4_result),
															  .time_11(12'd224),//132
															  .value_11(limit_15_lyf),
															  .time_12(12'd253),//57
															  .value_12(add_8_result),
															  .time_13(12'd268),//30
															  .value_13(add_8_result),
															  .time_14(12'd283),//141
															  .value_14(mul_4_result),
													        .y(mul_9_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_9_B_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_9_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd31),//103
															  .value_1(const_sqrt_inv_3_lyf_lyf),
															  .time_2(12'd48),//8
															  .value_2(Iambda_q_stor_lyf_lyf48),
															  .time_3(12'd70),//13
															  .value_3(y_reg_643_lyf70),
															  .time_4(12'd93),//78
															  .value_4(const_inv_Sbase_lyf_lyf),
															  .time_5(12'd113),//35
															  .value_5(x_reg_618_lyf113),
															  .time_6(12'd133),//24
															  .value_6(sin_theta_delay_203_lyf_lyf133),
															  .time_7(12'd148),//110
															  .value_7(const_2_lyf_lyf),
															  .time_8(12'd168),//116
															  .value_8(sin_1_result),
															  .time_9(12'd190),//118
															  .value_9(A2_554_lyf_lyf),
															  .time_10(12'd205),//50
															  .value_10(A2_535_lyf_lyf),
															  .time_11(12'd224),//132
															  .value_11(sin_1_result_FIFO_56),
															  .time_12(12'd253),//57
															  .value_12(sin_1_result),
															  .time_13(12'd268),//30
															  .value_13(Iq_temp_lyf_189),
															  .time_14(12'd283),//141
															  .value_14(Ic_pm_rect_64_271_1),
													        .y(mul_9_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_10_A_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_10_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd34),//3
															  .value_1(mul_7_result),
															  .time_2(12'd56),//14
															  .value_2(add_1_result),
															  .time_3(12'd71),//75
															  .value_3(Va_PM_64_59),
															  .time_4(12'd93),//108
															  .value_4(limit_13_lyf),
															  .time_5(12'd115),//87
															  .value_5(mul_8_result),
															  .time_6(12'd133),//25
															  .value_6(add_3_result),
															  .time_7(12'd149),//144
															  .value_7(mul_6_result),
															  .time_8(12'd168),//117
															  .value_8(mul_5_result),
															  .time_9(12'd190),//121
															  .value_9(add_5_result),
															  .time_10(12'd205),//52
															  .value_10(add_4_result),
															  .time_11(12'd224),//133
															  .value_11(limit_17_lyf),
															  .time_12(12'd253),//58
															  .value_12(add_9_result),
															  .time_13(12'd268),//31
															  .value_13(mul_6_result),
															  .time_14(12'd285),//70
															  .value_14(exp_1_result),
													        .y(mul_10_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] mul_10_B_ctrl_fuyong;	
ctrl_time_14 ctrl_time_mul_10_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd34),//3
															  .value_1(cos_theta_delay_204_lyf_lyf34),
															  .time_2(12'd56),//14
															  .value_2(G_650_lyf_lyf),
															  .time_3(12'd71),//75
															  .value_3(Ia_pm_rect_64_59),
															  .time_4(12'd93),//108
															  .value_4(A2_347_lyf_lyf),
															  .time_5(12'd115),//87
															  .value_5(const_inv_Sbase_lyf_lyf),
															  .time_6(12'd133),//25
															  .value_6(cos_theta_delay_204_lyf_lyf133),
															  .time_7(12'd149),//144
															  .value_7(const2_26inv_lyf_lyf),
															  .time_8(12'd168),//117
															  .value_8(cos_1_result_1),
															  .time_9(12'd190),//121
															  .value_9(A2_739_lyf_lyf),
															  .time_10(12'd205),//52
															  .value_10(A1_534_lyf_lyf),
															  .time_11(12'd224),//133
															  .value_11(cos_1_result_FIFO_57),
															  .time_12(12'd253),//58
															  .value_12(cos_1_result),
															  .time_13(12'd268),//31
															  .value_13(Id_temp_lyf_183),
															  .time_14(12'd285),//70
															  .value_14(mul_5_result),
													        .y(mul_10_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] div_1_A_ctrl_fuyong;	
ctrl_time_8 ctrl_time_div_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd137),//6
															  .value_1(constone_lyf_lyf),
															  .time_2(12'd182),//1
															  .value_2(constone_lyf_lyf),
															  .time_3(12'd199),//2
															  .value_3(constone_lyf_lyf),
															  .time_4(12'd218),//3
															  .value_4(constone_lyf_lyf),
															  .time_5(12'd233),//4
															  .value_5(const116_lyf_lyf),
															  .time_6(12'd248),//5
															  .value_6(const7_lyf_lyf),
															  .time_7(12'd282),//7
															  .value_7(add_3_result),
															  .time_8(12'd297),//8
															  .value_8(add_4_result),
													        .y(div_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] div_1_B_ctrl_fuyong;	
ctrl_time_8 ctrl_time_div_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd137),//6
															  .value_1(limit_1_lyf),
															  .time_2(12'd182),//1
															  .value_2(VWind164_lyf_lyf),
															  .time_3(12'd199),//2
															  .value_3(mul_3_result),
															  .time_4(12'd218),//3
															  .value_4(add_9_result),
															  .time_5(12'd233),//4
															  .value_5(div_1_result_4),
															  .time_6(12'd248),//5
															  .value_6(div_1_result_FIFO_19),
															  .time_7(12'd282),//7
															  .value_7(Vdc_lyf_282),
															  .time_8(12'd297),//8
															  .value_8(Vdc_lyf_297),
													        .y(div_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] sin_1_A_ctrl_fuyong;	
ctrl_time_2 ctrl_time_sin_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd123),//2
															  .value_1(add_3_result_8),
															  .time_2(12'd208),//1
															  .value_2(add_9_result_8),
													        .y(sin_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] sin_1_B_ctrl_fuyong;	
ctrl_time_2 ctrl_time_sin_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd123),//2
															  .value_1(add_6_result),
															  .time_2(12'd208),//1
															  .value_2(add_5_result),
													        .y(sin_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] sin_1_C_ctrl_fuyong;	
ctrl_time_2 ctrl_time_sin_1_C(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd123),//2
															  .value_1(add_7_result),
															  .time_2(12'd208),//1
															  .value_2(add_6_result),
													        .y(sin_1_C_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] cos_1_A_ctrl_fuyong;	
ctrl_time_2 ctrl_time_cos_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd123),//2
															  .value_1(add_3_result_8),
															  .time_2(12'd209),//1
															  .value_2(add_9_result_9),
													        .y(cos_1_A_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] cos_1_B_ctrl_fuyong;	
ctrl_time_2 ctrl_time_cos_1_B(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd123),//2
															  .value_1(add_6_result),
															  .time_2(12'd209),//1
															  .value_2(add_5_result_1),
													        .y(cos_1_B_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] cos_1_C_ctrl_fuyong;	
ctrl_time_2 ctrl_time_cos_1_C(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd123),//2
															  .value_1(add_7_result),
															  .time_2(12'd209),//1
															  .value_2(add_6_result_1),
													        .y(cos_1_C_ctrl_fuyong)
													        );	
wire [`EXTENDED_SINGLE - 1:0] exp_1_A_ctrl_fuyong;	
ctrl_time_1 ctrl_time_exp_1_A(
	                                            .clk(clk),
													        .sta(sta),
													        .counter(counter),
															  .time_1(12'd259),//1
															  .value_1(div_1_result),
													        .y(exp_1_A_ctrl_fuyong)
													        );	
					
///////////////////////////////////////////////////////////////////////////////////////////////////////////////C14

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
ADD_SUB_64	add_8_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_8_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_8_A_ctrl_fuyong),
										  .datab(add_8_B_ctrl_fuyong),
										  .result(add_8_result)
										 );
ADD_SUB_64	add_9_ctrl_fuyong(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(add_9_add_sub_ctrl_fuyong),
										  .clock(clk),
										  .dataa(add_9_A_ctrl_fuyong),
										  .datab(add_9_B_ctrl_fuyong),
										  .result(add_9_result)
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
wire [`SINGLE - 1:0] sin_1_result_32d;
Sin_control_system_water	sin_1_ctrl_fuyong(
							.clk(clk),
							.theta(sin_1_theta_32),
							.sin(sin_1_result_32d)
										 );
										 

DELAY_NCLK  #(32,1)  DELAY_NCLK_sin_1_result_32d(
						               .clk(clk),
											.rst(rst),
						               .d(sin_1_result_32d),
						               .q(sin_1_result_32)
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
wire [`SINGLE - 1:0] cos_1_result_32d;
Cos_control_system_water	cos_1_ctrl_fuyong(
							.clk(clk),
							.theta(cos_1_theta_32),
							.cos(cos_1_result_32d)
										 );
										 
DELAY_NCLK  #(32,1)  DELAY_NCLK_cos_1_result_32d(
						               .clk(clk),
											.rst(rst),
						               .d(cos_1_result_32d),
						               .q(cos_1_result_32)
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

						
///////////////////////////////////////////////////////////////////////////////////////////////////////////////C17
wire [`SINGLE - 1:0] triangle_out_inv_lyf_lyf_32;
wire [`SINGLE - 1:0] triangle_out_lyf_lyf_32;
wire [`EXTENDED_SINGLE - 1:0] triangle_out_inv_lyf_lyf;
wire [`EXTENDED_SINGLE - 1:0] triangle_out_lyf_lyf;
SINGLE2EXTENDED_SINGLE	single2float_triangle_out_inv_lyf_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(triangle_out_inv_lyf_lyf_32),
													        .result(triangle_out_inv_lyf_lyf)
													        );

SINGLE2EXTENDED_SINGLE	single2float_triangle_out_lyf_lyf(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(triangle_out_lyf_lyf_32),
													        .result(triangle_out_lyf_lyf)
													        );
															  
PWM #(3'b001,32'd19,32'd1,32'd0,32'h3d579436,3'b000,3'b001,3'b010,3'b011,3'b100) pwm_triangle_out_inv_lyf_lyf(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sta_sig[10]),
		  .FLAGFH(FLAGFH),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out_inv_lyf_lyf_32)
		 );

PWM #(3'b001,32'd19,32'd1,32'd0,32'h3d579436,3'b000,3'b001,3'b010,3'b011,3'b100) pwm_triangle_out_lyf_lyf(
		  .clk(clk),
		  .rst(rst),
	 	  .rst_user(rst_user),
		  .sta(sta_sig[10]),
		  .FLAGFH(FLAGFH),
		  .sta_user(sta_user),
		  
	     .triangle_out(triangle_out_lyf_lyf_32)
		 );
		 
Comparator_64 Comparator_4(
								 .clk(clk),
								 .rst(rst),
								 .input_1(add_4_result),
								 .input_2(triangle_out_inv_lyf_lyf),
								 .output_1(compareone_4_lyf)
							   );
always@(posedge clk or posedge rst) begin
	if(rst) begin
		compare_4_reg <= 64'h0000000000000000;
	end
	else if(compareone_4_lyf) begin
		compare_4_reg <= 64'h3FF0000000000000;
	end
	else if(!compareone_4_lyf) begin
		compare_4_reg <= 64'h0000000000000000;
	end
end
assign compare_4_lyf = compare_4_reg;
Comparator_64 Comparator_5(
								 .clk(clk),
								 .rst(rst),
								 .input_1(add_6_result),
								 .input_2(triangle_out_inv_lyf_lyf),
								 .output_1(compareone_5_lyf)
							   );
always@(posedge clk or posedge rst) begin
	if(rst) begin
		compare_5_reg <= 64'h0000000000000000;
	end
	else if(compareone_5_lyf) begin
		compare_5_reg <= 64'h3FF0000000000000;
	end
	else if(!compareone_5_lyf) begin
		compare_5_reg <= 64'h0000000000000000;
	end
end
assign compare_5_lyf = compare_5_reg;
Comparator_64 Comparator_6(
								 .clk(clk),
								 .rst(rst),
								 .input_1(add_7_result),
								 .input_2(triangle_out_inv_lyf_lyf),
								 .output_1(compareone_6_lyf)
							   );
always@(posedge clk or posedge rst) begin
	if(rst) begin
		compare_6_reg <= 64'h0000000000000000;
	end
	else if(compareone_6_lyf) begin
		compare_6_reg <= 64'h3FF0000000000000;
	end
	else if(!compareone_6_lyf) begin
		compare_6_reg <= 64'h0000000000000000;
	end
end
assign compare_6_lyf = compare_6_reg;
Comparator_64 Comparator_1(
								 .clk(clk),
								 .rst(rst),
								 .input_1(add_5_result),
								 .input_2(triangle_out_lyf_lyf),
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
								 .input_1(add_6_result),
								 .input_2(triangle_out_lyf_lyf),
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
								 .input_1(add_7_result),
								 .input_2(triangle_out_lyf_lyf),
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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////C18
limit_control_system64_water limit_12(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_292_lyf_lyf),
									  .down_limit(down_limit_293_lyf_lyf),
					              .x(add_8_result),
					              .y(limit_12_lyf)
							   );
limit_control_system64_water limit_13(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_292_lyf_lyf),
									  .down_limit(down_limit_293_lyf_lyf),
					              .x(add_4_result),
					              .y(limit_13_lyf)
							   );
limit_control_system64_water limit_1(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(J24_UP_lyf),
									  .down_limit(J24_DOWM_lyf),
					              .x(add_4_result),
					              .y(limit_1_lyf)
							   );
limit_control_system64_water limit_8(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_721_lyf_lyf),
									  .down_limit(down_limit_722_lyf_lyf),
					              .x(add_5_result),
					              .y(limit_8_lyf)
							   );
limit_control_system64_water limit_10(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_759_lyf_lyf),
									  .down_limit(down_limit_760_lyf_lyf),
					              .x(add_6_result),
					              .y(limit_10_lyf)
							   );
limit_control_system64_water limit_9(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_721_lyf_lyf),
									  .down_limit(down_limit_722_lyf_lyf),
					              .x(add_8_result),
					              .y(limit_9_lyf)
							   );
limit_control_system64_water limit_11(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_759_lyf_lyf),
									  .down_limit(down_limit_760_lyf_lyf),
					              .x(add_9_result),
					              .y(limit_11_lyf)
							   );
limit_control_system64_water limit_2(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_702_lyf_lyf),
									  .down_limit(down_limit_703_lyf_lyf),
					              .x(add_3_result),
					              .y(limit_2_lyf)
							   );
limit_control_system64_water limit_3(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_702_lyf_lyf),
									  .down_limit(down_limit_703_lyf_lyf),
					              .x(add_7_result),
					              .y(limit_3_lyf)
							   );
limit_control_system64_water limit_14(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_555_lyf_lyf),
									  .down_limit(down_limit_556_lyf_lyf),
					              .x(add_7_result),
					              .y(limit_14_lyf)
							   );
limit_control_system64_water limit_16(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_740_lyf_lyf),
									  .down_limit(down_limit_741_lyf_lyf),
					              .x(add_8_result),
					              .y(limit_16_lyf)
							   );
limit_control_system64_water limit_15(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_555_lyf_lyf),
									  .down_limit(down_limit_556_lyf_lyf),
					              .x(add_3_result),
					              .y(limit_15_lyf)
							   );
limit_control_system64_water limit_17(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_740_lyf_lyf),
									  .down_limit(down_limit_741_lyf_lyf),
					              .x(add_4_result),
					              .y(limit_17_lyf)
							   );
limit_control_system64_water limit_4(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_517_lyf_lyf),
									  .down_limit(down_limit_518_lyf_lyf),
					              .x(add_5_result),
					              .y(limit_4_lyf)
							   );
limit_control_system64_water limit_6(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_536_lyf_lyf),
									  .down_limit(down_limit_537_lyf_lyf),
					              .x(add_6_result),
					              .y(limit_6_lyf)
							   );
limit_control_system64_water limit_5(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_517_lyf_lyf),
									  .down_limit(down_limit_518_lyf_lyf),
					              .x(add_7_result),
					              .y(limit_5_lyf)
							   );
limit_control_system64_water limit_7(
								 .clk(clk),
								 .rst(rst),
									  .upper_limit(upper_limit_536_lyf_lyf),
									  .down_limit(down_limit_537_lyf_lyf),
					              .x(add_8_result),
					              .y(limit_7_lyf)
							   );


////////////////////////////////////////////////////////

wire ena_write_I,ena_read;	
//wire [`SINGLE - 1:0] source_output_single;

			  
wire [`EXTENDED_SINGLE - 1:0] Ubc_SFM_REC_L_fifo;
System_FIFO_64_1	FIFO_Ubc_SFM_REC_L_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[312]),
											.before_enawrite(sta_sig[281]),
								.cin( mul_4_result ),
								.cout( Ubc_SFM_REC_L_fifo )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Uab_SFM_REC_L_fifo;
System_FIFO_64_1	FIFO_Uab_SFM_REC_L_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[312]),
											.before_enawrite(sta_sig[281]),
								.cin( mul_3_result ),
								.cout( Uab_SFM_REC_L_fifo )
					                 );
wire [`EXTENDED_SINGLE - 1:0] Ubc_SFM_INV_L_fifo;
System_FIFO_64_1	FIFO_Ubc_SFM_INV_L_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[312]),
											.before_enawrite(sta_sig[266]),
								.cin( mul_8_result ),
								.cout( Ubc_SFM_INV_L_fifo )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Uab_SFM_INV_L_fifo;
System_FIFO_64_1	FIFO_Uab_SFM_INV_L_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[312]),
											.before_enawrite(sta_sig[266]),
								.cin( mul_7_result ),
								.cout( Uab_SFM_INV_L_fifo )
					                 );
										  
wire [`EXTENDED_SINGLE - 1:0] Ib_PM_L_fifo;
System_FIFO_64_1	FIFO_Ib_PM_L_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[312]),
											.before_enawrite(sta_sig[145]),
								.cin( add_5_result ),
								.cout( Ib_PM_L_fifo )
					                 );
									 
wire [`EXTENDED_SINGLE - 1:0] Ia_PM_L_fifo;
System_FIFO_64_1	FIFO_Ia_PM_L_fifo (
						               .clk(clk),
											.rst(rst),
											.rst_user(rst_user),
											.before_enaread(sta_sig[312]),
											.before_enawrite(sta_sig[195]),
								.cin( add_8_result ),
								.cout( Ia_PM_L_fifo )
					                 );


									 

wire [`SINGLE - 1:0] Ubc_SFM_REC_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Ubc_SFM_REC_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ubc_SFM_REC_L_fifo),
													        .result(Ubc_SFM_REC_L_fifo_32)
													        );
															  
wire [`SINGLE - 1:0] Uab_SFM_REC_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Uab_SFM_REC_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Uab_SFM_REC_L_fifo),
													        .result(Uab_SFM_REC_L_fifo_32)
													        );
															  
wire [`SINGLE - 1:0] Uab_SFM_INV_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Uab_SFM_INV_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Uab_SFM_INV_L_fifo),
													        .result(Uab_SFM_INV_L_fifo_32)
													        );
															  
wire [`SINGLE - 1:0] Ubc_SFM_INV_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Ubc_SFM_INV_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ubc_SFM_INV_L_fifo),
													        .result(Ubc_SFM_INV_L_fifo_32)
													        );
															
wire [`SINGLE - 1:0] Idc_SFM_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Idc_SFM_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(add_6_result),
													        .result(Idc_SFM_L_fifo_32)
													        );
															
wire [`SINGLE - 1:0] Ib_PM_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Ib_PM_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ib_PM_L_fifo),
													        .result(Ib_PM_L_fifo_32)
													        );
															
wire [`SINGLE - 1:0] Ia_PM_L_fifo_32;
EXTENDED_SINGLE2SINGLE	double2single_Ia_PM_L_fifo_32(
	                                            .aclr(rst),
													        .clk_en(`ena_math),
													        .clock(clk),
													        .dataa(Ia_PM_L_fifo),
													        .result(Ia_PM_L_fifo_32)
													        );

					  
generate_ena #(`N_WindTurbine ) generate_ena_WTI11(
						.clk(clk),
						.rst(rst),
						.d(sta_sig[317]),
						.q(ena_write_I)
					  );
	
DELAY_1CLK #(`delay_exchange) DELAY_3_readI(
						.clk(clk),
						.rst(rst),
						.d(sta_sig[317]),
						.q(sta_read_source_output)
					  );
					  
generate_ena #(`N_WindTurbine_Multip_eight ) generate_ena_readI(
						.clk(clk),
						.rst(rst),
						.d(sta_read_source_output),
						.q(ena_read)
					  );					  
					  
FIFO_Control_Source_new	FIFO_PV_I11 (
	.data ( {32'h00000000,Ubc_SFM_REC_L_fifo_32,Uab_SFM_REC_L_fifo_32,Ubc_SFM_INV_L_fifo_32,Uab_SFM_INV_L_fifo_32,Idc_SFM_L_fifo_32,Ib_PM_L_fifo_32,Ia_PM_L_fifo_32} ),
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
DELAY_1CLK #(2) DELAY_exchange111(
						.clk(clk),
						.rst(rst),
						.d(sta_read_source_output),
						.q(exchange_Source_sig)
					  );															  

							
							
							
endmodule
