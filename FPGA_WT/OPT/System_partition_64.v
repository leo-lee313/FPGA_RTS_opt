`include "../parameter/global_parameter.v"


module System_partition_64(
								clk,
								rst,
								control_valuation_sig,
								cin,
								cout
							  );
							  
input clk;
input rst;
input control_valuation_sig;

input [63:0] cin;
output [63:0] cout;
reg [63:0] cout;

always@ (posedge clk or posedge rst) begin
	if(rst) begin
		cout <= 1'b0;
	end
	else if(control_valuation_sig) begin
		cout <= cin;
	end
end

endmodule
