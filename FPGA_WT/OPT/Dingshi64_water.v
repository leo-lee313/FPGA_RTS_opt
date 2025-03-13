`include "../parameter/global_parameter.v"
module Dingshi64_water(
          clk,			 		 
			 sim_time,
			 Tm_temp_start, 
          Tm_temp,			 
			 Tm			
			);
			
input clk;
input [`EXTENDED_SINGLE - 1:0] Tm_temp_start;			
input [`EXTENDED_SINGLE - 1:0] Tm_temp;
input [`WIDTH_TIME - 1:0] sim_time;

			
output [`EXTENDED_SINGLE - 1:0] Tm;
reg [`EXTENDED_SINGLE - 1:0] Tm11;
parameter constq= 32'd10000;

always@(posedge clk)
begin
    if(sim_time<=constq)
	  begin
	    Tm11<=Tm_temp_start;
     end
	 else if(sim_time>constq)
	   begin
	    Tm11<=Tm_temp;
     end
end
assign Tm=Tm11;
endmodule







