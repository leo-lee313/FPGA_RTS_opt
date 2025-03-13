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
													  
	
												  
PrimeMotor_water   PrimeMotor(
			 .clk_sim(clk),
			 .sta_user(sta_user),
			 .FLAGFH(FLAGFH),
			 .rst_user(rst_user),
			 .rst_control(rst),
			 .sta_control(sta_interface), 
          .sim_time(sim_time),
	       .output_num(output_num),		 
			 .Va(Va_PM),
			 .Vb(Vb_PM),
			 .Vc(Vc_PM),	 
			 .Ia_pm_rec(Ia_pm_rect),
			 .Ib_pm_rec(Ib_pm_rect),
          .Ic_pm_rec(Ic_pm_rect),
			 .before_sta_control(before_sta_control),			 

			 .Ia(Ia_PM),
			 .Ib(Ib_PM),
			 
			 .m1_single(m1_single),
			 .m3_single(m3_single),
			 .m5_single(m5_single),			 
			 
			 .sta_before_m_3clk(sta_before_m_3clk),
			 .done_sig_finish_Iab(done_sig_finish_Iab),			 
			 .done_sig(done_sig_PrimeMotor)
			);//SFM
			
wire sta_done_read_x;

DELAY_1CLK #(5) Delay_sta_done_read_x(
													   .clk(clk),
													   .rst(rst),
													   .d(sta),
													   .q(sta_done_read_x)
													  );
													  
InverterControl_water  InverterControl1(
			 .clk(clk),
			 .rst(rst),
			 .sta_done_read_x(sta_done_read_x),
			 .sta(sta_interface), 
          .FLAGFH(FLAGFH),			 
          .sta_user(sta_user),
          .rst_user(rst_user),	 
          .Vdc(Vdc),
         
          .V3a(V3a),
          .V3b(V3b),
          .V3c(V3c),
          .I3a(I3a),
          .I3b(I3b),
          .I3c(I3c),	
                             			 			 			 
          .g1_single(g1_single),
			 .g3_single(g3_single),
			 .g5_single(g5_single),
			 
			 .done_sig(done_INV_SFM_g)
			);//SFM

wire donesig_Uab_SFM_Inv,sta_read_fifo;

Source_Ctred_SFM_water    Source_Ctred_SFM_water(
				  .clk(clk),
			     .rst(rst),
				  .rst_user(rst_user),
				  .sta(sta_interface),
			
				  .Vdc(Vdc),
				  .Ia_pm_rect(Ia_pm_rect),
				  .Ic_pm_rect(Ic_pm_rect),
				  .Ia_SFM_Inv(Ia_SFM_Inv),
				  .Ic_SFM_Inv(Ic_SFM_Inv),
				  				  
				  .done_INV_SFM_g(done_INV_SFM_g),
				  .g1_single(g1_single),
				  .g3_single(g3_single),
				  .g5_single(g5_single),
				  
				  .sta_before_m_3clk(sta_before_m_3clk),
				  .m1_single(m1_single),
				  .m3_single(m3_single),
				  .m5_single(m5_single),
				  
				  .Uab_SFM_Inv(Uab_SFM_Inv),
				  .Ubc_SFM_Inv(Ubc_SFM_Inv),
				  .Uab_SFM_REC(Uab_SFM_REC),
				  .Ubc_SFM_REC(Ubc_SFM_REC),
				  .Idc_SFM_SUM(Idc_SFM_SUM),
				  
				  .donesig_Uab_SFM_Inv(donesig_Uab_SFM_Inv),
				  .sta_read_fifo(sta_read_fifo),
				  .done_sig(done_Idc_SFM_SUM)
				 );

																	  
														  
														  
																																								  													  
/************************************************************interface_output******************************************************/
														  
/////fifo_Ia_PM&Ib_PM
wire ena_write_I,ena_read;

System_FIFO_32   FIFO_Ia_PM(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_fifo),
								.before_enawrite(done_sig_finish_Iab),
								.cin( Ia_PM ),
								.cout( Ia_PM_fifo )
							  );
							  
System_FIFO_32   FIFO_Ib_PM(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_fifo),
								.before_enawrite(done_sig_finish_Iab),
								.cin( Ib_PM ),
								.cout( Ib_PM_fifo )
							  );							  
							  
System_FIFO_32   FIFO_Uab_SFM_Inv(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_fifo),
								.before_enawrite(donesig_Uab_SFM_Inv),
								.cin( Uab_SFM_Inv ),
								.cout( Uab_SFM_Inv_fifo )
							  );							  
							  
System_FIFO_32   FIFO_Ubc_SFM_Inv(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_fifo),
								.before_enawrite(donesig_Uab_SFM_Inv),
								.cin( Ubc_SFM_Inv ),
								.cout( Ubc_SFM_Inv_fifo )
							  );															  
															  
															  
System_FIFO_32   FIFO_Uab_SFM_REC(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_fifo),
								.before_enawrite(donesig_Uab_SFM_Inv),
								.cin( Uab_SFM_REC ),
								.cout( Uab_SFM_REC_fifo )
							  );
							  
															  
System_FIFO_32   FIFO_Ubc_SFM_REC(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_fifo),
								.before_enawrite(donesig_Uab_SFM_Inv),
								.cin( Ubc_SFM_REC ),
								.cout( Ubc_SFM_REC_fifo )
							  );


							  
															  
															  
															  
generate_ena #(`N_WindTurbine ) generate_ena_WTI(
						.clk(clk),
						.rst(rst),
						.d(done_Idc_SFM_SUM),
						.q(ena_write_I)
					  );
	
DELAY_1CLK #(`delay_exchange) DELAY_3_readI(
						.clk(clk),
						.rst(rst),
						.d(done_Idc_SFM_SUM),
						.q(sta_read_source_output)
					  );
					  
generate_ena #(`N_WindTurbine_Multip_eight ) generate_ena_readI(
						.clk(clk),
						.rst(rst),
						.d(sta_read_source_output),
						.q(ena_read)
					  );
					  
					  
FIFO_Control_Source_new	FIFO_WT_I (
	.data ( {32'h00000000,Ubc_SFM_REC_fifo,Uab_SFM_REC_fifo,Ubc_SFM_Inv_fifo,Uab_SFM_Inv_fifo,Idc_SFM_SUM,Ib_PM_fifo,Ia_PM_fifo} ),
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
	
DELAY_1CLK #(2) DELAY_exchange111(
						.clk(clk),
						.rst(rst),
						.d(sta_read_source_output),
						.q(exchange_Source_sig)
					  );
					 
					 
//////Wait till the time is appropriate, then write into RAM of SIN_AMP.
//////The control signals of IGBT_Diode are written into RAM as soon as the calculation is completed.	
	

							
							
							
							
							
endmodule
