`include "../parameter/global_parameter.v"
module Dingshi(
          clk,			 		 
			 sim_time, 
          Tm_temp,			 
			 Tm			
			);
			
input clk;			
input [`SINGLE - 1:0] Tm_temp;
input [`WIDTH_TIME - 1:0] sim_time;

			
output [`SINGLE - 1:0] Tm;
reg [`SINGLE - 1:0] Tm11;
parameter constw=32'hC1F00000;
parameter constq=32'd10000;

always@(posedge clk)
begin
    if(sim_time<=constq)
	  begin
	    Tm11<=constw;
	    //Tm11<=constw;
     end
	 else if(sim_time>constq)
	   begin
	    Tm11<=Tm_temp;
     end
end
assign Tm=Tm11;
endmodule







