`include "../parameter/global_parameter.v"

module WindGEN_water(			 		 		 
			 clk,
			 rst,
			 sta,
			 sim_time, 
          			 
			 VWind			
			);
		
input clk,rst,sta;
input [`WIDTH_TIME - 1:0] sim_time;
output [`SINGLE - 1:0] VWind;
reg [`SINGLE - 1:0] VWind11;

wire [`ADDR_WIDTH_N_WindTurbine - 1:0] addr_VWind;
wire pulse_VWind;
wire ena_VWind;
wire step_VWind;
wire ena_cal_VWind;
wire [`SINGLE - 1:0] wind1;
wire [`SINGLE - 1:0] wind2;
parameter consttwo=32'd400000;

ADDR #( `ADDR_WIDTH_N_WindTurbine , `N_WindTurbine , `TIMES_N_WindTurbine , `INI_ADDR_N_WindTurbine ) ADDR_Vwind(
																																								.clk(clk),
																																								.rst(rst),
																																								.sta(sta),
																																								.addr(addr_VWind),
																																								.pulse(pulse_VWind),
																																								.ena_mem(ena_VWind),
																																								.step(step_VWind),
																																								.ena_cal(ena_cal_VWind)
																																								 );
																																								 
Vwind1 	Vwind1(
					.aclr(rst),
					.clock(clk),
				   .clken(ena_VWind),
					.address(addr_VWind),
					.rden(ena_cal_VWind),
					.q(wind1)
					);

Vwind2 	Vwind2(
					.aclr(rst),
					.clock(clk),
				   .clken(ena_VWind),
					.address(addr_VWind),
					.rden(ena_cal_VWind),
					.q(wind2)
					);



always@(posedge clk)
begin
    if(sim_time<=consttwo)
	  begin
	    VWind11<=wind1;
     end
	 else if((sim_time>consttwo))
	   begin
		  VWind11<=wind2;
	   end

end
assign VWind=VWind11;

endmodule
