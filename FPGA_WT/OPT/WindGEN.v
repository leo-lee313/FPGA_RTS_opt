`include "../parameter/global_parameter.v"

module WindGEN(			 		 		 
			 clk,
			 sim_time, 
          			 
			 VWind			
			);
		
input clk;
input [`WIDTH_TIME - 1:0] sim_time;
output [`SINGLE - 1:0] VWind;
reg [`SINGLE - 1:0] VWind11;

parameter consttwo=32'd400000;
parameter constfour=32'd800000;
//wind1 is 9.7
parameter wind1 = 32'h411B3333;
//wind2 is 12
parameter wind2 = 32'h41400000;
//wind3 is 14
parameter wind3 = 32'h41600000;

always@(posedge clk)
begin
    if(sim_time<=consttwo)
	  begin
	    VWind11<=wind1;
     end
	 else if((sim_time>consttwo)&&(sim_time<=constfour))
	   begin
		  VWind11<=wind2;
	   end
	 else if(sim_time>constfour)	
     begin
	    VWind11<=wind3; 
     end
end
assign VWind=VWind11;

endmodule
