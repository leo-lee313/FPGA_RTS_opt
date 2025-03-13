`include "../parameter/global_parameter.v"

module PI_theta(
			 clk,
			 rst,
			 rst_user,
			 control_valuation_sig,
			 x,
			 y
		   );

parameter A = 32'h3f800000;
parameter B = 32'h3f800000;
parameter const_2pi = 32'h40C90FDB;
parameter const_0 = 32'h00000000;	

input clk;
input rst;
input rst_user;
input control_valuation_sig;
input [`SINGLE - 1:0] x;

output [`SINGLE - 1:0] y;

wire [`SINGLE - 1:0] inner_result1;
reg [`SINGLE - 1:0] y;
wire [`SINGLE - 1:0] inner_result2;
wire [`SINGLE - 1:0] inner_result3;
wire [`SINGLE - 1:0] x_reg;
wire [`SINGLE - 1:0] y_reg;
wire [`SINGLE - 1:0] y_cal;
wire [`SINGLE - 1:0] y_1;
wire [`SINGLE - 1:0] y_2;


//reg [`SINGLE - 1:0] x_reg;
//reg [`SINGLE - 1:0] y_reg;

//A = delta_t/2*Ki + Kp
//B = delta_t/2*Ki - Kp


Multiplier_nodsp	Multiplier_inner_result1(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(A),
														 .datab(x),
														 .result(inner_result1)
														);
										
Multiplier_nodsp	Multiplier_inner_result2(
														 .aclr(rst),
														 .clk_en(`ena_math),
														 .clock(clk),
														 .dataa(B),
														 .datab(x_reg),
														 .result(inner_result2)
														);
	
Adder_nodsp	Adder_inner_result3(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result1),
										  .datab(y_reg),
										  .result(inner_result3)
										 );
										 


Adder_nodsp	Adder_inner_result4(
										  .aclr(rst),
										  .clk_en(`ena_math),
										  .add_sub(`add),
										  .clock(clk),
										  .dataa(inner_result3),
										  .datab(inner_result2),
										  .result(y_cal)
										 );
////////////////////////////////////////////////////
									 
Adder_nodsp	Substract_inner_result9a(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(y_cal),
												.datab(const_2pi),
												.result(y_1)
											  );												  
												  
Adder_nodsp	Substract_inner_result9b(
												.aclr(rst),
												.clk_en(`ena_math),
												.add_sub(`sub),
												.clock(clk),
												.dataa(y_cal),
												.datab(const_0),
												.result(y_2)
											  );
											  
always@ (posedge clk or posedge rst_user) begin
   if (rst_user==1'b1)
	   y <=32'h0;
	else if(y_1[31]==1'b0)
		y <= y_1;
	else if(y_1[31]==1'b1)
		y <= y_2;
end										 
										 
										 										 																				 
System_partition Storage_x(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(x),
									.cout(x_reg)
								  );
														 
System_partition Storage_y(
									.clk(clk),
									.rst(rst_user),
									.control_valuation_sig(control_valuation_sig),
									.cin(y),
									.cout(y_reg)
								  );
	
endmodule
	
