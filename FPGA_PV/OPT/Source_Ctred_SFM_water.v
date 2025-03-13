`include "../parameter/global_parameter.v"

module Source_Ctred_SFM_water (
				  clk,
				  rst_user,
				  rst,
				  sta,
			
			     sta_fifo_w,
				  Vdc,
				  Ia_SFM_Inv,
				  Ic_SFM_Inv,
				  					
				  pwm_1,
				  pwm_3,
				  pwm_5,
				  				  
              Idc_SFM,		
              Uab_SFM_Inv,	
              Ubc_SFM_Inv,										 
				  sta_SFM_w,
				  sta_IphId_r
				 );


input clk;
input rst;
input rst_user;
input sta,sta_fifo_w;
input [`SINGLE - 1:0] Vdc;
input [`SINGLE - 1:0] Ia_SFM_Inv;
input [`SINGLE - 1:0] Ic_SFM_Inv;
input pwm_1,pwm_3,pwm_5;

output [`SINGLE - 1:0] Uab_SFM_Inv,Ubc_SFM_Inv;
output [`SINGLE - 1:0] Idc_SFM;
output sta_SFM_w,sta_IphId_r;

wire [`SINGLE - 1:0] g1_single,g3_single,g5_single;
reg  [`SINGLE - 1:0] g1_reg,g3_reg,g5_reg;
wire sta_Vdc,sta_read_Vdc,sta_read_Ia_SFM;
wire [`SINGLE - 1:0] Vdc_fifo,Vdc_delay;
wire [`SINGLE - 1:0] g13_SFM,g35_SFM;
wire [`SINGLE - 1:0] Ia_SFM_Inv_fifo,Ic_SFM_Inv_fifo;
wire [`SINGLE - 1:0] inner_1,inner_2,inner_3;
wire [`SINGLE - 1:0] Uab_SFM_Inv_pre,Ubc_SFM_Inv_pre;

always@(posedge clk or posedge rst) begin
	if(rst) begin
		g1_reg <= 32'h00000000;
	end
	else if(pwm_1) begin
		g1_reg <= 32'h3F800000;
	end
	else if(!pwm_1) begin
		g1_reg <= 32'h00000000;
	end
end
			
always@(posedge clk or posedge rst) begin
	if(rst) begin
		g3_reg <= 32'h00000000;
	end
	else if(pwm_3) begin
		g3_reg <= 32'h3F800000;
	end
	else if(!pwm_3) begin
		g3_reg <= 32'h00000000;
	end
end

always@(posedge clk or posedge rst) begin
	if(rst) begin
		g5_reg <= 32'h00000000;
	end
	else if(pwm_5) begin
		g5_reg <= 32'h3F800000;
	end
	else if(!pwm_5) begin
		g5_reg <= 32'h00000000;
	end
end

assign g1_single = g1_reg;
assign g3_single = g3_reg;
assign g5_single = g5_reg;			
											
DELAY_1CLK #(6) Delay_sta_read_Vdc(
										.clk(clk),
										.rst(rst),
										.d(sta),
										.q(sta_read_Vdc)
											);											

DELAY_1CLK #(5) Delay_sta_read_Ia_SFM(
										.clk(clk),
										.rst(rst),
										.d(sta_read_Vdc),
										.q(sta_read_Ia_SFM)
											);	


DELAY_1CLK #(31) Delay_sta_SFM_w(
										.clk(clk),
										.rst(rst),
										.d(sta),
										.q(sta_SFM_w)
											);

DELAY_1CLK #(29) Delay_sta_IphId_r(
										.clk(clk),
										.rst(rst),
										.d(sta),
										.q(sta_IphId_r)
											);											
									
System_FIFO_32   FIFO_Vdc(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Vdc),
								.before_enawrite(sta_fifo_w),
								.cin( Vdc ),
								.cout( Vdc_fifo )
							  );
							 									  										  
System_FIFO_32   FIFO_Ia_SFM_Inv(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Ia_SFM),
								.before_enawrite(sta_fifo_w),
								.cin( Ia_SFM_Inv ),
								.cout( Ia_SFM_Inv_fifo )
							  );

System_FIFO_32   FIFO_Ic_SFM_Inv(
								.clk( clk ),
								.rst(rst),
								.rst_user(rst_user),
								.before_enaread(sta_read_Ia_SFM),
								.before_enawrite(sta_fifo_w),
								.cin( Ic_SFM_Inv ),
								.cout( Ic_SFM_Inv_fifo )
							  );
		
DELAY_NCLK  #(32,17)  DELAY_Vdc(
						               .clk(clk),
											.rst(rst),
						               .d(Vdc_fifo),
						               .q(Vdc_delay)
					                 );				

//INV
Adder_nodsp	Adder_inner_result_1(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(g1_single),
											.datab(g3_single),
											.result(g13_SFM)
										  );//J43
										  
Adder_nodsp	Adder_inner_result_2(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(g3_single),
											.datab(g5_single),
											.result(g35_SFM)
										  );		//J44								  	
	
Multiplier_nodsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vdc_fifo),
														 .datab(g13_SFM),
														 .result(Uab_SFM_Inv_pre)
														);//C56

Multiplier_nodsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Vdc_fifo),
														 .datab(g35_SFM),
														 .result(Ubc_SFM_Inv_pre)
														);			//C57											
														

Multiplier_nodsp	Multiplier_inner_result3(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Uab_SFM_Inv_pre),
														 .datab(Ia_SFM_Inv_fifo),
														 .result(inner_1)
														);//C58

		
Multiplier_nodsp	Multiplier_inner_result4(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(Ubc_SFM_Inv_pre),
														 .datab(Ic_SFM_Inv_fifo),
														 .result(inner_2)
														);//C59



Adder_nodsp	Adder_inner_result_3(
											.aclr(rst),
											.clk_en(`ena_math),
											.add_sub(`sub),
											.clock(clk),
											.dataa(inner_1),
											.datab(inner_2),
											.result(inner_3)
										  );//J45


		
Divide_nodsp	Divider_1(
							  .aclr(rst),
							  .clk_en(`ena_math),
							  .clock(clk),
							  .dataa(inner_3),
							  .datab(Vdc_delay),
							  .result(Idc_SFM)								 
							 );
		

DELAY_NCLK  #(32,18)  DELAY_Uab_SFM_Inv(
						               .clk(clk),
											.rst(rst),
						               .d(Uab_SFM_Inv_pre),
						               .q(Uab_SFM_Inv)
					                 );


DELAY_NCLK  #(32,18)  DELAY_Ubc_SFM_Inv(
						               .clk(clk),
											.rst(rst),
						               .d(Ubc_SFM_Inv_pre),
						               .q(Ubc_SFM_Inv)
					                 );





endmodule




