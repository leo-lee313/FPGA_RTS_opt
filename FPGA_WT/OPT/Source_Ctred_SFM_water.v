`include "../parameter/global_parameter.v"

module Source_Ctred_SFM_water (
				  clk,
				  rst_user,
				  rst,
				  sta,
			
				  Vdc,
				  Ia_pm_rect,
				  Ic_pm_rect,
				  Ia_SFM_Inv,
				  Ic_SFM_Inv,
				  	
              done_INV_SFM_g,					
				  g1_single,
				  g3_single,
				  g5_single,
				  
				  sta_before_m_3clk,
				  m1_single,
				  m3_single,
				  m5_single,
				  
              Idc_SFM_SUM,		
              Uab_SFM_Inv,	
              Ubc_SFM_Inv,										 
              Uab_SFM_REC,										 
              Ubc_SFM_REC,
				  
				  donesig_Uab_SFM_Inv,
				  sta_read_fifo,
				  done_sig
				 );


input clk;
input rst;
input rst_user;
input sta;
input sta_before_m_3clk,done_INV_SFM_g;
input [`SINGLE - 1:0] Vdc;
input [`SINGLE - 1:0] Ia_pm_rect;
input [`SINGLE - 1:0] Ic_pm_rect;
input [`SINGLE - 1:0] Ia_SFM_Inv;
input [`SINGLE - 1:0] Ic_SFM_Inv;

input [`SINGLE - 1:0] g1_single,g3_single,g5_single;
input [`SINGLE - 1:0] m1_single,m3_single,m5_single;

output [`SINGLE - 1:0] Uab_SFM_Inv,Ubc_SFM_Inv;
output [`SINGLE - 1:0] Uab_SFM_REC,Ubc_SFM_REC;
output [`SINGLE - 1:0] Idc_SFM_SUM;

output donesig_Uab_SFM_Inv,done_sig,sta_read_fifo;

wire sta_Vdc,sta_read_Vdc,sta_read_Ia_SFM;

wire [`SINGLE - 1:0] Vdc_fifo,Vdc_delay;
wire [`SINGLE - 1:0] g1_single_fifo,g3_single_fifo,g5_single_fifo;
wire [`SINGLE - 1:0] g13_SFM,g35_SFM,m13_SFM,m35_SFM;

wire [`SINGLE - 1:0] Ia_pm_rect_fifo,Ic_pm_rect_fifo;
wire [`SINGLE - 1:0] Ia_SFM_REC,Ic_SFM_REC;
wire [`SINGLE - 1:0] Ia_SFM_Inv_fifo,Ic_SFM_Inv_fifo;

wire [`SINGLE - 1:0] inner_1,inner_2,inner_3;
wire [`SINGLE - 1:0] inner_11,inner_21,inner_31;

wire [`SINGLE - 1:0] Idc_SFM_INV,Idc_SFM_REC;


DELAY_1CLK #(1) Delay_sta_Vdc(
										.clk(clk),
										.rst(rst),
										.d(sta),
										.q(sta_Vdc)
											);


											

DELAY_1CLK #(7) Delay_sta_read_Vdc(
										.clk(clk),
										.rst(rst),
										.d(sta_before_m_3clk),
										.q(sta_read_Vdc)
											);

DELAY_1CLK #(5) Delay_sta_read_Ia_SFM(
										.clk(clk),
										.rst(rst),
										.d(sta_read_Vdc),
										.q(sta_read_Ia_SFM)
											);											
											
										
System_FIFO_32   FIFO_Vdc(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Vdc),
								.before_enawrite(sta_Vdc),
								.cin( Vdc ),
								.cout( Vdc_fifo )
							  );
							  
DELAY_NCLK  #(32,17)  DELAY_Vdc(
						               .clk(clk),
											.rst(rst),
						               .d(Vdc_fifo),
						               .q(Vdc_delay)
					                 );	
										  
System_FIFO_32   FIFO_Ia_pm_rect(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Ia_SFM),
								.before_enawrite(sta),
								.cin( Ia_pm_rect ),
								.cout( Ia_pm_rect_fifo )
							  );

System_FIFO_32   FIFO_Ic_pm_rect(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Ia_SFM),
								.before_enawrite(sta),
								.cin( Ic_pm_rect ),
								.cout( Ic_pm_rect_fifo )
							  );
							  
assign Ia_SFM_REC = {~Ia_pm_rect_fifo[`SINGLE - 1],Ia_pm_rect_fifo[`SINGLE - 2:0]};							  
assign Ic_SFM_REC = {~Ic_pm_rect_fifo[`SINGLE - 1],Ic_pm_rect_fifo[`SINGLE - 2:0]};		
	

System_FIFO_32   FIFO_Ia_SFM_Inv(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Ia_SFM),
								.before_enawrite(sta),
								.cin( Ia_SFM_Inv ),
								.cout( Ia_SFM_Inv_fifo )
							  );

System_FIFO_32   FIFO_Ic_SFM_Inv(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Ia_SFM),
								.before_enawrite(sta),
								.cin( Ic_SFM_Inv ),
								.cout( Ic_SFM_Inv_fifo )
							  );
							 
							
System_FIFO_32   FIFO_g1_single(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_before_m_3clk),
								.before_enawrite(done_INV_SFM_g),
								.cin( g1_single ),
								.cout( g1_single_fifo )
							  );						
					
System_FIFO_32   FIFO_g3_single(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_before_m_3clk),
								.before_enawrite(done_INV_SFM_g),
								.cin( g3_single ),
								.cout( g3_single_fifo )
							  );
					
System_FIFO_32   FIFO_g5_single(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_before_m_3clk),
								.before_enawrite(done_INV_SFM_g),
								.cin( g5_single ),
								.cout( g5_single_fifo )
							  );	

	
				

//INV
Adder_nodsp	Adder_inner_result_1(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(g1_single_fifo),
											.datab(g3_single_fifo),
											.result(g13_SFM)
										  );
										  
Adder_nodsp	Adder_inner_result_2(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(g3_single_fifo),
											.datab(g5_single_fifo),
											.result(g35_SFM)
										  );										  
										  										 														
Multiplier_nodsp_dsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vdc_fifo),
														 .datab(g13_SFM),
														 .result(Uab_SFM_Inv)
														);

Multiplier_nodsp_dsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vdc_fifo),
														 .datab(g35_SFM),
														 .result(Ubc_SFM_Inv)
														);														
														

Multiplier_nodsp_dsp	Multiplier_inner_result3(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Uab_SFM_Inv),
														 .datab(Ia_SFM_Inv_fifo),
														 .result(inner_1)
														);

		
Multiplier_nodsp_dsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Ubc_SFM_Inv),
														 .datab(Ic_SFM_Inv_fifo),
														 .result(inner_2)
														);



Adder_nodsp	Adder_inner_result_3(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(inner_1),
											.datab(inner_2),
											.result(inner_3)
										  );


		
Divide_nodsp	Divider_1(
							  .aclr(rst),
							  .clk_en(`ena_math),
							  .clock(clk),
							  .dataa(inner_3),
							  .datab(Vdc_delay),
							  .result(Idc_SFM_INV)								 
							 );
		
//REC
Adder_nodsp	Adder_inner_result_11(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(m1_single),
											.datab(m3_single),
											.result(m13_SFM)
										  );
										  
Adder_nodsp	Adder_inner_result_21(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(m3_single),
											.datab(m5_single),
											.result(m35_SFM)
										  );										  
										  										 														
Multiplier_nodsp_dsp	Multiplier_inner_result11(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vdc_fifo),
														 .datab(m13_SFM),
														 .result(Uab_SFM_REC)
														);

Multiplier_nodsp_dsp	Multiplier_inner_result21(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vdc_fifo),
														 .datab(m35_SFM),
														 .result(Ubc_SFM_REC)
														);														
														
Multiplier_nodsp_dsp	Multiplier_inner_result31(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Uab_SFM_REC),
														 .datab(Ia_SFM_REC),
														 .result(inner_11)
														);
	
Multiplier_nodsp_dsp	Multiplier_inner_result41(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Ubc_SFM_REC),
														 .datab(Ic_SFM_REC),
														 .result(inner_21)
														);

Adder_nodsp	Adder_inner_result_31(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(inner_11),
											.datab(inner_21),
											.result(inner_31)
										  );
		
Divide_nodsp	Divider_11(
							  .aclr(rst),
							  .clk_en(`ena_math),
							  .clock(clk),
							  .dataa(inner_31),
							  .datab(Vdc_delay),
							  .result(Idc_SFM_REC)								 
							 );		
		
///////
		
Adder_nodsp	Adder_inner_result_4(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`add),
											.clock(clk),
											.dataa(Idc_SFM_REC),
											.datab(Idc_SFM_INV),
											.result(Idc_SFM_SUM)
										  );		
		
														 																	
										 
DELAY_1CLK #(39) Delay_donesig(
										.clk(clk),
										.rst(rst),
										.d(sta_before_m_3clk),
										.q(done_sig)
											);
											

DELAY_1CLK #(37) Delay_sta_read_fifo(
										.clk(clk),
										.rst(rst),
										.d(sta_before_m_3clk),
										.q(sta_read_fifo)
											);



DELAY_1CLK #(14) Delay_donesig_Uab_SFM_Inv(
										.clk(clk),
										.rst(rst),
										.d(sta_before_m_3clk),
										.q(donesig_Uab_SFM_Inv)
											);









endmodule




